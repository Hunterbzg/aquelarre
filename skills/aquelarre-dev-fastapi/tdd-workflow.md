# TDD Workflow — FastAPI (Aquelarre)

Ciclo **obligatorio** cuando `tdd=on` y `platform=backend` (salvo infrastructure/configuration con N/A justificado).

## Red → Green → Refactor

### 1) RED — tests que fallan

1. Leer especificación TDD del TASK (§8a)
2. Crear `tests/<ruta>/test_<modulo>.py` (espejo de `app/`)
3. Escribir **todos** los casos del task
4. `pytest tests/<ruta> -v` → deben **fallar**
5. Si pasan sin implementación, corregir tests (demasiado triviales)

### 2) GREEN — implementación mínima

1. Código mínimo en `app/` para pasar tests
2. Seguir `fastapi-patterns.md`
3. `pytest tests/<ruta> -v` → **PASS**
4. No añadir features fuera del scope del task

### 3) REFACTOR — calidad

1. Limpiar duplicación y naming
2. `ruff format .` → `ruff check . --fix`
3. `mypy app/<modulo>`
4. `pytest` en verde
5. Cobertura según `dod-checklist.md`

## Fixture base (`tests/conftest.py`)

```python
import pytest
from httpx import ASGITransport, AsyncClient

from app.main import app


@pytest.fixture
async def async_client():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as client:
        yield client
```

## Test de endpoint (ejemplo)

```python
async def test_create_entity_success(async_client):
    payload = {"name": "Test", "description": "A test"}
    response = await async_client.post("/api/v1/entities/", json=payload)
    assert response.status_code == 201
    data = response.json()
    assert data["name"] == "Test"
    assert "id" in data
```

## Mock HTTP externo (respx)

```python
import respx
from httpx import Response


@respx.mock
async def test_external_call():
    respx.post("https://api.example.com/v1/action").mock(
        return_value=Response(200, json={"status": "ok"})
    )
    # ... act & assert
```

## Mock repositorio (unit)

```python
from unittest.mock import AsyncMock

@pytest.fixture
def mock_repo():
    repo = AsyncMock()
    repo.get_by_id.return_value = {"id": "x", "name": "Test"}
    return repo
```

## Tipos de task

| Tipo | TDD |
|------|-----|
| feature, bugfix | Obligatorio |
| infrastructure, configuration | N/A — verificar build/`docker compose up` |
