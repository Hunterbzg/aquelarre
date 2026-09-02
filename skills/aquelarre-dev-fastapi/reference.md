# Referencia — FastAPI (Aquelarre)

Índice de guías del skill. Stack: Python 3.11+, FastAPI, Pydantic v2, pytest, ruff, mypy, Supabase opcional.

| Guía | Contenido |
|------|-----------|
| `fastapi-patterns.md` | Clean Architecture, capas, errores, endpoints |
| `tdd-workflow.md` | Red → Green → Refactor, fixtures, mocks |
| `code-standards.md` | ruff, mypy, pytest, naming, pyproject |
| `dod-checklist.md` | DoD Gate 2 por riesgo del task |

## Estructura de capas (Clean Architecture)

```
app/
├── core/           # config, exceptions, security, logging
├── domain/         # models internos, schemas Pydantic (sin imports externos)
├── infrastructure/ # supabase/, clientes HTTP externos
├── services/       # casos de uso
├── api/v1/         # routers, dependencies, middleware
└── main.py
```

**Reglas de dependencia:**

- `domain/` no importa otras capas
- `services/` → `domain/`, `infrastructure/`
- `api/` → `services/`, `domain/schemas/`
- `infrastructure/` → `domain/`

## Comandos evidencia Gate 2

```bash
pytest tests/ -v
ruff check .
ruff format --check .
mypy app/
pytest --cov=app --cov-report=term-missing
docker compose run --rm api pytest   # si ci=docker
```

## Artefactos relacionados

| Necesidad | Dónde |
|-----------|-------|
| Contratos API | `templates/API-CONTRACTS.md` → `docs/architecture/api-contracts/` |
| Implementación paso a paso | `templates/workflows/implement-backend.md` |
| Docker | skill `aquelarre-docker` |
| Supabase / RLS | skill `aquelarre-supabase` |
| Crawl docs API externa | skill `aquelarre-doc-crawler` |

## Anti-patrones

- Lógica de negocio en routers
- SQL o cliente Supabase directo en endpoints
- Secretos en código
- Romper contratos OpenAPI sin ADR
- Saltar RED (tests que pasan antes de implementar)
