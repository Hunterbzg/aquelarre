# Workflow — Onboarding backend (FastAPI)

Inicializa un proyecto consumidor con Aquelarre + stack Python/FastAPI.
Ejecutar cuando el proyecto es greenfield `platform: backend` y aún no tiene estructura.

## Prerrequisitos

- Aquelarre instalado (`install/install.ps1 -Dest <proyecto>`)
- Python 3.11+ disponible localmente o vía Docker

## Pasos

### 1) Identidad del proyecto

Preguntar al humano:

1. Nombre del proyecto
2. Descripción breve (1–2 frases)
3. Idioma de artefactos (español / inglés)
4. URL del repositorio (si existe)

### 2) Contexto existente

Leer si existen:

- `docs/project-context.md`
- `docs/discovery/` (cualquier DISCOVERY-*)
- `README.md` del repo

### 3) Estructura `docs/` (si falta)

El instalador Aquelarre ya crea scaffold. Verificar y completar:

- `docs/project-context.md` desde `templates/PROJECT-CONTEXT.md`
- `docs/architecture/api-contracts/` (carpeta vacía)

### 4) Scaffold Python (si no existe `app/`)

Crear mínimo:

```
app/
├── __init__.py
├── main.py
├── core/
│   ├── __init__.py
│   └── config.py
├── domain/
│   └── schemas/
├── services/
├── infrastructure/
└── api/
    └── v1/
        └── endpoints/
tests/
├── __init__.py
└── conftest.py
```

- `pyproject.toml` — ver `skills/aquelarre-dev-fastapi/code-standards.md`
- `.env.example` — variables APP_NAME, DEBUG, API_V1_PREFIX, SUPABASE_*
- `.gitignore` — Python estándar
- `tests/conftest.py` — fixture `async_client` (ver `tdd-workflow.md` del skill dev-fastapi)

### 5) Docker (si `ci=docker`)

- `Dockerfile` multi-stage — ver `skills/aquelarre-docker/reference.md`
- `docker-compose.yml` para desarrollo
- Endpoint `GET /health`

### 6) Actualizar project-context

Marcar:

- Stack confirmado: FastAPI + Supabase + Docker
- Gates: todos ⬜ salvo onboarding ✅
- Próximo paso: `aquelarre-discovery`

### 7) Cierre

Presentar resumen al humano y recomendar discovery (`aquelarre-discovery`) o primer EPIC/TASK.
