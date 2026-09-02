# Code Standards — Python / FastAPI

Herramientas y convenciones por defecto. El proyecto consumidor puede override en `pyproject.toml`.

## Ruff (lint + format)

```toml
[tool.ruff]
target-version = "py311"
line-length = 88
src = ["app", "tests"]

[tool.ruff.lint]
select = ["E", "W", "F", "I", "N", "UP", "B", "SIM", "RET", "RUF"]
ignore = ["E501", "B008"]

[tool.ruff.lint.isort]
known-first-party = ["app"]
```

```bash
ruff check .
ruff check . --fix
ruff format .
ruff format --check .
```

## Mypy

```toml
[tool.mypy]
python_version = "3.11"
strict = true

[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false

[[tool.mypy.overrides]]
module = ["supabase.*", "postgrest.*", "respx.*"]
ignore_missing_imports = true
```

## Pytest

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
asyncio_mode = "auto"
addopts = "-v --tb=short"
markers = ["unit", "integration"]

[tool.coverage.run]
source = ["app"]
```

Umbrales de cobertura: ver `dod-checklist.md` (por `risk`, no fijo global).

## Naming

| Elemento | Convención |
|----------|------------|
| Archivos / funciones | `snake_case` |
| Clases | `PascalCase` |
| Constantes | `UPPER_SNAKE_CASE` |
| Tests | `test_<comportamiento>.py` |
| URL paths | `kebab-case` o `snake_case` |
| Router tags | plural minúsculas |

## pyproject.toml base

```toml
[project]
name = "my-api"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = [
    "fastapi>=0.110.0",
    "uvicorn[standard]>=0.27.0",
    "pydantic>=2.0.0",
    "pydantic-settings>=2.0.0",
    "httpx>=0.27.0",
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
```

## Imports (orden)

1. stdlib
2. third-party
3. `app.*`
