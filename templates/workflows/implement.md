# Workflow — Implementar task

Ejecuta el ciclo de desarrollo de un TASK en estado `ready`.

**Comando Antigravity:** `/implement`  
**Skills:** dev por `platform` · `aquelarre-testing` · `aquelarre-github`

## Prerrequisitos

- TASK en `docs/workflow/tasks/TASK-<id>-<slug>.md` con estado `ready`
- Gate 1 PASS
- Branch creada (`aquelarre-github`)

## Pasos

### 1) Identificar task activo

1. Leer `docs/project-context.md` §4 (task activo) o sprint plan en `docs/workflow/sprints/`
2. Elegir primer task `ready` sin PR abierto
3. Si ninguno → recomendar `/sprint-plan`

### 2) Validar DoR

Invocar `aquelarre-workflow-orchestration` (Supervisor Gate 1) si hay duda.

### 3) Routing por plataforma

| `platform` | Skill | Workflow detallado |
|------------|-------|-------------------|
| `backend` (Python/FastAPI) | `aquelarre-dev-fastapi` | `implement-backend.md` → rama FastAPI |
| `backend` (Node.js) | `aquelarre-dev-node` | `implement-node.md` |
| `mobile` / `tablet` | `aquelarre-dev-flutter` | skill TDD + `aquelarre-bitrise` si `ci=bitrise` |
| `web` | `aquelarre-dev-react` | skill + `aquelarre-docker` si `ci=docker` |
| `mixed` | Varios dev skills | Dividir por task o sub-task |

### 4) TDD + evidencia

- Implementar según skill dev
- Completar task §7 y §9
- Gate 2: tests, lint, CI según `ci` y `risk`

### 5) PR y Gate 3

`aquelarre-github` → merge tras aprobación humana.

### 6) Siguiente task

Repetir `/implement` o `/status`.

## Rutas

Task siempre en `docs/workflow/tasks/` — ver `docs/ARTIFACT_PATHS.md`.
