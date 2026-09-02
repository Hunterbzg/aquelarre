# TDD Workflow — AI SDLC Factory

> **Propósito**: Workflow estricto de Test-Driven Development (Red-Green-Refactor).
> Este workflow es OBLIGATORIO para toda implementación de código.

---

## Ciclo TDD — Red → Green → Refactor

### Fase 1: RED 🔴 — Escribir Tests que Fallan

**Objetivo**: Definir el comportamiento esperado a través de tests que aún no tienen implementación.

**Pasos**:
1. Leer la **Especificación de Pruebas TDD** del Task
2. Crear archivo(s) de test en `tests/` siguiendo la estructura espejo:
   - `app/services/invoice_service.py` → `tests/services/test_invoice_service.py`
   - `app/api/v1/endpoints/invoices.py` → `tests/api/v1/test_invoices.py`
3. Escribir TODOS los test cases especificados en el Task
4. Ejecutar tests: `pytest tests/[ruta] -v`
5. **VERIFICAR que los tests FALLAN** — Si pasan, los tests son incorrectos o triviales
6. Reportar resultado al usuario

**Estructura de test estándar**:
```python
import pytest
from httpx import AsyncClient


class TestEntityCreate:
    """Tests for entity creation."""

    async def test_create_entity_success(self, async_client: AsyncClient):
        """Given valid data, when creating entity, then return 201 with entity data."""
        # Arrange
        payload = {"name": "Test Entity", "description": "A test"}

        # Act
        response = await async_client.post("/api/v1/entities/", json=payload)

        # Assert
        assert response.status_code == 201
        data = response.json()
        assert data["name"] == "Test Entity"
        assert "id" in data

    async def test_create_entity_invalid_data(self, async_client: AsyncClient):
        """Given invalid data, when creating entity, then return 422."""
        # Arrange
        payload = {}  # Missing required fields

        # Act
        response = await async_client.post("/api/v1/entities/", json=payload)

        # Assert
        assert response.status_code == 422
```

---

### Fase 2: GREEN 🟢 — Implementación Mínima

**Objetivo**: Escribir el código MÍNIMO necesario para que todos los tests pasen.

**Pasos**:
1. Implementar el código siguiendo los patrones de `fastapi-patterns.md`
2. No sobre-ingeniería — solo lo necesario para los tests
3. Ejecutar tests: `pytest tests/[ruta] -v`
4. **VERIFICAR que TODOS los tests PASAN**
5. Si algún test falla, corregir la implementación (no el test, salvo que el test tenga un bug)
6. Reportar resultado al usuario

**Reglas de la fase Green**:
- ✅ Implementar exactamente lo que los tests piden
- ❌ No agregar funcionalidad extra no cubierta por tests
- ❌ No optimizar prematuramente
- ❌ No refactorizar todavía

---

### Fase 3: REFACTOR ♻️ — Limpiar y Optimizar

**Objetivo**: Mejorar la calidad del código manteniendo todos los tests en verde.

**Pasos**:
1. Revisar el código implementado para oportunidades de mejora:
   - Extraer funciones/métodos reutilizables
   - Mejorar naming
   - Eliminar duplicación
   - Aplicar patrones del ADR
2. Ejecutar `ruff format .` para formatear
3. Ejecutar `ruff check . --fix` para corregir issues de linting
4. Ejecutar `mypy app/[módulo]` para verificar tipos
5. Ejecutar tests: `pytest tests/[ruta] -v`
6. **VERIFICAR que TODOS los tests siguen pasando**
7. Ejecutar cobertura: `pytest --cov=app/[módulo] tests/[ruta]`
8. Reportar resultado completo al usuario

---

## Configuración de Testing

### conftest.py (raíz de tests)

```python
# tests/conftest.py
import pytest
from httpx import ASGITransport, AsyncClient

from app.main import app


@pytest.fixture
async def async_client():
    """Async HTTP client for integration tests."""
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as client:
        yield client
```

### Mocking de servicios externos

```python
# Para mockear llamadas HTTP externas, usar respx
import respx
from httpx import Response


@respx.mock
async def test_external_api_call():
    """Mock external API calls with respx."""
    respx.post("https://api.external.com/endpoint").mock(
        return_value=Response(200, json={"status": "ok"})
    )
    # ... rest of test
```

### Mocking de Supabase

```python
# Para mockear Supabase, usar fixtures con mock repositories
from unittest.mock import AsyncMock, MagicMock


@pytest.fixture
def mock_repository():
    """Mock repository for unit tests."""
    repo = AsyncMock()
    repo.get_by_id.return_value = {
        "id": "test-id",
        "name": "Test",
        "created_at": "2024-01-01T00:00:00Z",
    }
    return repo
```

---

## Comandos de Referencia

```bash
# Ejecutar todos los tests
pytest -v

# Ejecutar tests de un módulo específico
pytest tests/services/test_invoice_service.py -v

# Ejecutar con cobertura
pytest --cov=app --cov-report=term-missing

# Ejecutar solo tests marcados
pytest -m "unit" -v
pytest -m "integration" -v

# Ejecutar en modo watch (requiere pytest-watch)
ptw -- -v
```

---

## Anti-Patrones a Evitar

| Anti-Patrón | Por Qué Es Malo | Qué Hacer En Su Lugar |
|:---|:---|:---|
| Escribir código antes de tests | Viola TDD, tests se vuelven retroactivos | Siempre RED primero |
| Tests que nunca fallan | No validan nada realmente | Verificar que fallan en fase RED |
| Mockear todo | Tests frágiles, no validan integración | Usar mocks solo para servicios externos |
| Tests sin asserts | Dan falsa confianza | Cada test DEBE tener assertions claras |
| Un test por muchos comportamientos | Difícil de debuggear | Un test = un comportamiento |
