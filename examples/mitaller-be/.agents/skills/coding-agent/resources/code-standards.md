# Code Standards — AI SDLC Factory

> **Propósito**: Estándares de calidad de código para backends Python/FastAPI.

---

## Herramientas de Calidad

### Ruff — Linter + Formatter

Configuración en `pyproject.toml`:

```toml
[tool.ruff]
target-version = "py311"
line-length = 88
src = ["app", "tests"]

[tool.ruff.lint]
select = [
    "E",    # pycodestyle errors
    "W",    # pycodestyle warnings
    "F",    # pyflakes
    "I",    # isort
    "N",    # pep8-naming
    "UP",   # pyupgrade
    "B",    # bugbear
    "A",    # builtins
    "C4",   # comprehensions
    "DTZ",  # datetime timezone
    "T20",  # print statements
    "SIM",  # simplify
    "RET",  # return statements
    "ARG",  # unused arguments
    "PTH",  # pathlib
    "ERA",  # commented-out code
    "RUF",  # ruff-specific
]
ignore = [
    "E501",   # line too long (handled by formatter)
    "B008",   # do not perform function calls in argument defaults (needed for Depends())
]

[tool.ruff.lint.isort]
known-first-party = ["app"]

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
```

**Comandos**:
```bash
ruff check .              # Verificar issues
ruff check . --fix        # Auto-fix issues
ruff format .             # Formatear código
ruff format --check .     # Verificar formato sin cambiar
```

---

### Mypy — Type Checking

Configuración en `pyproject.toml`:

```toml
[tool.mypy]
python_version = "3.11"
strict = true
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
check_untyped_defs = true

[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false

[[tool.mypy.overrides]]
module = [
    "supabase.*",
    "postgrest.*",
    "gotrue.*",
    "respx.*",
]
ignore_missing_imports = true
```

**Comando**:
```bash
mypy app/
```

---

### Pytest — Testing

Configuración en `pyproject.toml`:

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_functions = ["test_*"]
asyncio_mode = "auto"
addopts = "-v --tb=short"
markers = [
    "unit: Unit tests",
    "integration: Integration tests",
    "e2e: End-to-end tests",
]

[tool.coverage.run]
source = ["app"]
omit = ["app/main.py"]

[tool.coverage.report]
fail_under = 85
show_missing = true
exclude_lines = [
    "pragma: no cover",
    "if TYPE_CHECKING:",
    "if __name__",
]
```

---

## Naming Conventions

### Archivos y Directorios
- `snake_case` para archivos Python: `invoice_service.py`
- `snake_case` para directorios: `api/v1/endpoints/`
- Prefijo `test_` para archivos de test: `test_invoice_service.py`

### Python Code
| Elemento | Convención | Ejemplo |
|:---|:---|:---|
| Variables | `snake_case` | `invoice_total` |
| Funciones | `snake_case` | `calculate_tax()` |
| Clases | `PascalCase` | `InvoiceService` |
| Constantes | `UPPER_SNAKE_CASE` | `MAX_RETRY_COUNT` |
| Métodos privados | `_snake_case` | `_validate_input()` |
| Type aliases | `PascalCase` | `InvoiceId = str` |
| Módulos | `snake_case` | `invoice_service` |

### FastAPI Specific
| Elemento | Convención | Ejemplo |
|:---|:---|:---|
| Endpoints | `snake_case` | `get_invoice()` |
| URL paths | `kebab-case` o `snake_case` | `/api/v1/invoices/{invoice_id}` |
| Query params | `snake_case` | `?page_size=10` |
| Router tags | `lowercase plural` | `tags=["invoices"]` |
| Schemas | `PascalCase + Suffix` | `InvoiceCreate`, `InvoiceResponse` |

### Pydantic Schemas
| Tipo | Sufijo | Uso |
|:---|:---|:---|
| `*Base` | Base | Campos compartidos |
| `*Create` | Create | Request body para creación |
| `*Update` | Update | Request body para actualización (campos opcionales) |
| `*Response` | Response | Response body (incluye campos de DB) |
| `*InDB` | InDB | Representación interna de DB (si necesario) |

---

## Docstrings

```python
def calculate_tax(amount: float, rate: float) -> float:
    """Calculate tax amount.

    Args:
        amount: Base amount before tax.
        rate: Tax rate as decimal (e.g., 0.13 for 13%).

    Returns:
        Calculated tax amount.

    Raises:
        ValueError: If amount is negative or rate is not between 0 and 1.
    """
    if amount < 0:
        raise ValueError("Amount cannot be negative")
    if not 0 <= rate <= 1:
        raise ValueError("Rate must be between 0 and 1")
    return amount * rate
```

---

## pyproject.toml Base

```toml
[project]
name = "my-fastapi-backend"
version = "0.1.0"
description = "Backend API built with FastAPI"
requires-python = ">=3.11"
dependencies = [
    "fastapi>=0.110.0",
    "uvicorn[standard]>=0.27.0",
    "pydantic>=2.0.0",
    "pydantic-settings>=2.0.0",
    "httpx>=0.27.0",
    "supabase>=2.0.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=8.0.0",
    "pytest-asyncio>=0.23.0",
    "pytest-cov>=4.0.0",
    "respx>=0.21.0",
    "ruff>=0.4.0",
    "mypy>=1.9.0",
]

[build-system]
requires = ["setuptools>=68.0"]
build-backend = "setuptools.backends._legacy:_Backend"
```

---

## Import Order (enforced by ruff isort)

```python
# 1. Standard library
from datetime import datetime
from typing import Any

# 2. Third-party packages
from fastapi import APIRouter, Depends
from pydantic import BaseModel

# 3. Local application imports
from app.core.config import settings
from app.domain.schemas.invoice import InvoiceResponse
```
