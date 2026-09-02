# FastAPI Patterns — Clean Architecture

Patrones de referencia para backends Aquelarre. Alinear con ADR del proyecto si difiere.

## Respuesta de error estándar

```python
# app/domain/schemas/error.py
from typing import Any
from pydantic import BaseModel


class ErrorResponse(BaseModel):
    code: str
    message: str
    details: dict[str, Any] | None = None
```

Registrar handlers en `app/api/middleware/error_handler.py` mapeando excepciones de `app/core/exceptions.py` a JSON con códigos HTTP consistentes (`NOT_FOUND`, `VALIDATION_ERROR`, etc.).

## Config (pydantic-settings)

```python
# app/core/config.py
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", case_sensitive=False)

    app_name: str = "API"
    debug: bool = False
    api_v1_prefix: str = "/api/v1"
    supabase_url: str = ""
    supabase_anon_key: str = ""
    supabase_service_role_key: str = ""


settings = Settings()
```

## Excepciones de dominio

```python
# app/core/exceptions.py
class AppException(Exception):
    def __init__(self, message: str, code: str = "INTERNAL_ERROR"):
        self.message = message
        self.code = code
        super().__init__(message)


class NotFoundException(AppException):
    def __init__(self, resource: str, identifier: str):
        super().__init__(
            f"{resource} with id '{identifier}' not found",
            code="NOT_FOUND",
        )
```

## Service (caso de uso)

```python
# app/services/entity_service.py
class EntityService:
    def __init__(self, repo: EntityRepository):
        self._repo = repo

    async def get_by_id(self, entity_id: str) -> dict:
        entity = await self._repo.get_by_id(entity_id)
        if not entity:
            raise NotFoundException("Entity", entity_id)
        return entity
```

## Router delgado

```python
# app/api/v1/endpoints/entities.py
from fastapi import APIRouter, Depends, status

router = APIRouter(prefix="/entities", tags=["entities"])


@router.post("/", status_code=status.HTTP_201_CREATED)
async def create_entity(
    payload: EntityCreate,
    service: EntityService = Depends(get_entity_service),
):
    return await service.create(payload)
```

## Repository (Supabase)

```python
# app/infrastructure/supabase/repositories/entity_repository.py
class EntityRepository:
    def __init__(self, client: AsyncClient):
        self._client = client

    async def get_by_id(self, entity_id: str) -> dict | None:
        result = await self._client.table("entities").select("*").eq("id", entity_id).maybe_single().execute()
        return result.data
```

## Schemas Pydantic

| Sufijo | Uso |
|--------|-----|
| `*Create` | Body POST |
| `*Update` | Body PATCH (campos opcionales) |
| `*Response` | Salida API |

## Health check

```python
@router.get("/health")
async def health_check():
    return {"status": "healthy"}
```

## Clientes HTTP externos

Colocar en `app/infrastructure/<provider>/client.py`. Mockear con **respx** en tests. Documentar contrato en `docs/architecture/api-contracts/` o vía `aquelarre-doc-crawler`.
