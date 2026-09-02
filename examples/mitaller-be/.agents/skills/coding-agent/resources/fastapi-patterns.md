# FastAPI Patterns — AI SDLC Factory

> **Propósito**: Patrones de referencia para implementación de backends con FastAPI + Clean Architecture.

---

## Clean Architecture — Estructura de Capas

```
app/
├── core/                   # Configuración global, seguridad, constantes
│   ├── __init__.py
│   ├── config.py           # Settings con pydantic-settings
│   ├── exceptions.py       # Excepciones personalizadas del sistema
│   ├── logging.py          # Configuración de logging estructurado
│   └── security.py         # Utilidades de seguridad (JWT validation, etc.)
│
├── domain/                 # Entidades y schemas — NO importa otras capas
│   ├── __init__.py
│   ├── models/             # Clases del dominio interno
│   │   └── __init__.py
│   └── schemas/            # DTOs Pydantic v2 (request/response)
│       └── __init__.py
│
├── infrastructure/         # Adaptadores externos — importa solo domain/
│   ├── __init__.py
│   ├── supabase/           # Cliente y repositorios de Supabase
│   │   ├── __init__.py
│   │   ├── client.py       # Configuración del cliente Supabase
│   │   └── repositories/   # Repositorios por entidad
│   │       └── __init__.py
│   └── [external]/         # Otros clientes HTTP (ej. kapix/)
│       ├── __init__.py
│       └── client.py
│
├── services/               # Casos de uso — importa domain/ + infrastructure/
│   ├── __init__.py
│   └── [entity]_service.py # Un servicio por dominio/feature
│
├── api/                    # Capa de presentación — importa services/ + schemas/
│   ├── __init__.py
│   ├── dependencies.py     # FastAPI dependencies (DI)
│   ├── v1/
│   │   ├── __init__.py
│   │   ├── api.py          # Router principal v1
│   │   └── endpoints/      # Un router por recurso
│   │       ├── __init__.py
│   │       └── [resource].py
│   └── middleware/
│       ├── __init__.py
│       ├── auth.py         # Middleware de autenticación JWT
│       └── error_handler.py # Middleware de manejo global de errores
│
└── main.py                 # Punto de entrada — inicialización FastAPI
```

---

## Standard Error Response

Todos los endpoints deben usar un formato de error consistente:

```python
# app/domain/schemas/error.py
from typing import Any
from pydantic import BaseModel


class ErrorResponse(BaseModel):
    """Standard error response for all API errors."""
    code: str
    message: str
    details: dict[str, Any] | None = None
```

```python
# app/api/middleware/error_handler.py
from fastapi import FastAPI, Request, status
from fastapi.responses import JSONResponse

from app.core.exceptions import AppException, NotFoundException, ValidationException


def setup_error_handlers(app: FastAPI) -> None:
    @app.exception_handler(NotFoundException)
    async def not_found_handler(request: Request, exc: NotFoundException) -> JSONResponse:
        return JSONResponse(
            status_code=status.HTTP_404_NOT_FOUND,
            content={"code": exc.code, "message": exc.message, "details": None},
        )

    @app.exception_handler(ValidationException)
    async def validation_handler(request: Request, exc: ValidationException) -> JSONResponse:
        return JSONResponse(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            content={"code": exc.code, "message": exc.message, "details": None},
        )

    @app.exception_handler(AppException)
    async def app_exception_handler(request: Request, exc: AppException) -> JSONResponse:
        return JSONResponse(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            content={"code": exc.code, "message": exc.message, "details": None},
        )
```

---

## Patrones por Capa

### Core — Config (pydantic-settings)

```python
# app/core/config.py
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
    )

    # Application
    app_name: str = "MyAPI"
    debug: bool = False
    api_v1_prefix: str = "/api/v1"

    # Supabase
    supabase_url: str
    supabase_anon_key: str
    supabase_service_role_key: str

    # External APIs
    # external_api_url: str
    # external_api_key: str


settings = Settings()
```

### Core — Exceptions

```python
# app/core/exceptions.py
from fastapi import HTTPException, status


class AppException(Exception):
    """Base application exception."""
    def __init__(self, message: str, code: str = "INTERNAL_ERROR"):
        self.message = message
        self.code = code
        super().__init__(self.message)


class NotFoundException(AppException):
    def __init__(self, resource: str, identifier: str):
        super().__init__(
            message=f"{resource} with id '{identifier}' not found",
            code="NOT_FOUND",
        )


class ValidationException(AppException):
    def __init__(self, message: str):
        super().__init__(message=message, code="VALIDATION_ERROR")


class ExternalServiceException(AppException):
    def __init__(self, service: str, message: str):
        super().__init__(
            message=f"External service '{service}' error: {message}",
            code="EXTERNAL_SERVICE_ERROR",
        )
```

### Domain — Schemas (Pydantic v2)

```python
# app/domain/schemas/[entity].py
from datetime import datetime
from pydantic import BaseModel, ConfigDict


class EntityBase(BaseModel):
    """Shared fields."""
    name: str
    description: str | None = None


class EntityCreate(EntityBase):
    """Fields for creation (request body)."""
    pass


class EntityUpdate(BaseModel):
    """Fields for update (all optional)."""
    name: str | None = None
    description: str | None = None


class EntityResponse(EntityBase):
    """Fields for response (includes DB fields)."""
    model_config = ConfigDict(from_attributes=True)

    id: str
    created_at: datetime
    updated_at: datetime
```

### Infrastructure — Repository Pattern

```python
# app/infrastructure/supabase/repositories/[entity]_repository.py
from supabase import AsyncClient

from app.domain.schemas.[entity] import EntityCreate, EntityResponse


class EntityRepository:
    def __init__(self, client: AsyncClient):
        self._client = client
        self._table = "entities"

    async def get_by_id(self, entity_id: str) -> EntityResponse | None:
        response = await (
            self._client.table(self._table)
            .select("*")
            .eq("id", entity_id)
            .maybe_single()
            .execute()
        )
        if response.data:
            return EntityResponse.model_validate(response.data)
        return None

    async def create(self, data: EntityCreate) -> EntityResponse:
        response = await (
            self._client.table(self._table)
            .insert(data.model_dump())
            .execute()
        )
        return EntityResponse.model_validate(response.data[0])

    async def list_all(self, limit: int = 100, offset: int = 0) -> list[EntityResponse]:
        response = await (
            self._client.table(self._table)
            .select("*")
            .range(offset, offset + limit - 1)
            .execute()
        )
        return [EntityResponse.model_validate(item) for item in response.data]
```

### Services — Use Cases

```python
# app/services/[entity]_service.py
from app.core.exceptions import NotFoundException
from app.domain.schemas.[entity] import EntityCreate, EntityResponse
from app.infrastructure.supabase.repositories.[entity]_repository import EntityRepository


class EntityService:
    def __init__(self, repository: EntityRepository):
        self._repository = repository

    async def get_entity(self, entity_id: str) -> EntityResponse:
        entity = await self._repository.get_by_id(entity_id)
        if not entity:
            raise NotFoundException("Entity", entity_id)
        return entity

    async def create_entity(self, data: EntityCreate) -> EntityResponse:
        return await self._repository.create(data)

    async def list_entities(self, limit: int = 100, offset: int = 0) -> list[EntityResponse]:
        return await self._repository.list_all(limit=limit, offset=offset)
```

### API — Endpoints

```python
# app/api/v1/endpoints/[resource].py
from fastapi import APIRouter, Depends, status

from app.api.dependencies import get_entity_service
from app.domain.schemas.[entity] import EntityCreate, EntityResponse
from app.services.[entity]_service import EntityService

router = APIRouter(prefix="/entities", tags=["entities"])


@router.get("/{entity_id}", response_model=EntityResponse)
async def get_entity(
    entity_id: str,
    service: EntityService = Depends(get_entity_service),
) -> EntityResponse:
    return await service.get_entity(entity_id)


@router.post("/", response_model=EntityResponse, status_code=status.HTTP_201_CREATED)
async def create_entity(
    data: EntityCreate,
    service: EntityService = Depends(get_entity_service),
) -> EntityResponse:
    return await service.create_entity(data)


@router.get("/", response_model=list[EntityResponse])
async def list_entities(
    limit: int = 100,
    offset: int = 0,
    service: EntityService = Depends(get_entity_service),
) -> list[EntityResponse]:
    return await service.list_entities(limit=limit, offset=offset)
```

### API — Dependencies (DI)

```python
# app/api/dependencies.py
from functools import lru_cache

from supabase import create_async_client, AsyncClient

from app.core.config import settings
from app.infrastructure.supabase.repositories.[entity]_repository import EntityRepository
from app.services.[entity]_service import EntityService


async def get_supabase_client() -> AsyncClient:
    return await create_async_client(
        settings.supabase_url,
        settings.supabase_anon_key,
    )


async def get_entity_service() -> EntityService:
    client = await get_supabase_client()
    repository = EntityRepository(client)
    return EntityService(repository)
```

### Main — Application Entry Point

```python
# app/main.py
from contextlib import asynccontextmanager
from fastapi import FastAPI

from app.core.config import settings
from app.api.v1.api import api_router
from app.api.middleware.error_handler import setup_error_handlers


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    yield
    # Shutdown


app = FastAPI(
    title=settings.app_name,
    lifespan=lifespan,
)

setup_error_handlers(app)
app.include_router(api_router, prefix=settings.api_v1_prefix)
```

---

## Dependency Flow

```
domain/ ← infrastructure/ ← services/ ← api/
  ↑                                        ↑
  └────────────────────────────────────────┘
                (schemas only)
```

**Regla**: Las dependencias SIEMPRE fluyen hacia adentro. `domain/` nunca importa de otras capas.
