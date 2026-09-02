# Supabase Patterns — AI SDLC Factory

> **Propósito**: Patrones de integración con Supabase para backends Python/FastAPI.

---

## Cliente Supabase

### Configuración del Cliente

```python
# app/infrastructure/supabase/client.py
from supabase import create_async_client, AsyncClient
from app.core.config import settings


async def get_supabase_client() -> AsyncClient:
    """Get async Supabase client with anon key (respects RLS)."""
    return await create_async_client(
        settings.supabase_url,
        settings.supabase_anon_key,
    )


async def get_supabase_admin_client() -> AsyncClient:
    """Get async Supabase client with service role key (bypasses RLS)."""
    return await create_async_client(
        settings.supabase_url,
        settings.supabase_service_role_key,
    )
```

### Cuándo usar cada cliente

| Cliente | Key | RLS | Uso |
|:---|:---|:---|:---|
| `get_supabase_client()` | Anon Key | ✅ Respeta RLS | Operaciones de usuario autenticado |
| `get_supabase_admin_client()` | Service Role | ❌ Bypassa RLS | Operaciones administrativas, webhooks |

---

## Autenticación JWT

### Middleware de Validación JWT

```python
# app/api/middleware/auth.py
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from supabase import AsyncClient

from app.infrastructure.supabase.client import get_supabase_client

security = HTTPBearer()


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
) -> dict:
    """Validate JWT token from Supabase Auth and return user data."""
    client = await get_supabase_client()
    try:
        user_response = await client.auth.get_user(credentials.credentials)
        if not user_response or not user_response.user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid or expired token",
            )
        return {
            "id": user_response.user.id,
            "email": user_response.user.email,
            "role": user_response.user.role,
            "app_metadata": user_response.user.app_metadata,
            "user_metadata": user_response.user.user_metadata,
        }
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Authentication failed: {str(e)}",
        )
```

### Uso en Endpoints

```python
from app.api.middleware.auth import get_current_user

@router.get("/protected")
async def protected_endpoint(
    current_user: dict = Depends(get_current_user),
):
    return {"user_id": current_user["id"]}
```

---

## Row Level Security (RLS)

### Patrón de Multitenencia

```sql
-- Ejemplo: tabla con RLS por organización
CREATE TABLE invoices (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    organization_id UUID NOT NULL REFERENCES organizations(id),
    amount DECIMAL NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Habilitar RLS
ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;

-- Policy: usuarios solo ven facturas de su organización
CREATE POLICY "Users can view own org invoices" ON invoices
    FOR SELECT
    USING (
        organization_id IN (
            SELECT organization_id FROM user_organizations
            WHERE user_id = auth.uid()
        )
    );

-- Policy: usuarios solo crean facturas en su organización
CREATE POLICY "Users can create own org invoices" ON invoices
    FOR INSERT
    WITH CHECK (
        organization_id IN (
            SELECT organization_id FROM user_organizations
            WHERE user_id = auth.uid()
        )
    );
```

---

## Repository Pattern con Supabase

### Base Repository

```python
# app/infrastructure/supabase/repositories/base_repository.py
from typing import Generic, TypeVar
from pydantic import BaseModel
from supabase import AsyncClient

T = TypeVar("T", bound=BaseModel)
CreateT = TypeVar("CreateT", bound=BaseModel)
UpdateT = TypeVar("UpdateT", bound=BaseModel)


class BaseRepository(Generic[T, CreateT, UpdateT]):
    def __init__(self, client: AsyncClient, table_name: str, model_class: type[T]):
        self._client = client
        self._table = table_name
        self._model = model_class

    async def get_by_id(self, record_id: str) -> T | None:
        response = await (
            self._client.table(self._table)
            .select("*")
            .eq("id", record_id)
            .maybe_single()
            .execute()
        )
        return self._model.model_validate(response.data) if response.data else None

    async def create(self, data: CreateT) -> T:
        response = await (
            self._client.table(self._table)
            .insert(data.model_dump(exclude_none=True))
            .execute()
        )
        return self._model.model_validate(response.data[0])

    async def update(self, record_id: str, data: UpdateT) -> T:
        update_data = data.model_dump(exclude_none=True)
        response = await (
            self._client.table(self._table)
            .update(update_data)
            .eq("id", record_id)
            .execute()
        )
        return self._model.model_validate(response.data[0])

    async def delete(self, record_id: str) -> None:
        await (
            self._client.table(self._table)
            .delete()
            .eq("id", record_id)
            .execute()
        )

    async def list_all(
        self, limit: int = 100, offset: int = 0
    ) -> list[T]:
        response = await (
            self._client.table(self._table)
            .select("*")
            .range(offset, offset + limit - 1)
            .execute()
        )
        return [self._model.model_validate(item) for item in response.data]
```

---

## Error Handling con Supabase

```python
from postgrest.exceptions import APIError

try:
    result = await client.table("invoices").insert(data).execute()
except APIError as e:
    if "duplicate key" in str(e):
        raise ValidationException("Record already exists")
    elif "violates foreign key" in str(e):
        raise ValidationException("Referenced record not found")
    else:
        raise ExternalServiceException("Supabase", str(e))
```

---

## Testing con Supabase Mock

```python
# Para tests unitarios, mockear el repositorio completo
from unittest.mock import AsyncMock

@pytest.fixture
def mock_invoice_repo():
    repo = AsyncMock()
    repo.get_by_id.return_value = InvoiceResponse(
        id="test-id",
        amount=100.0,
        status="pending",
        created_at=datetime.now(),
        updated_at=datetime.now(),
    )
    return repo
```
