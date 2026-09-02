# Workflow — Onboarding (proyecto nuevo)

Inicializa un proyecto consumidor con Aquelarre. Aplica a cualquier stack (`platform`).

**Comando Antigravity:** `/onboarding`  
**Skills:** `aquelarre-discovery` (fase inicial) · ver `onboarding-backend.md` si solo backend

## Prerrequisitos

- Aquelarre instalado: `install/install.ps1 -Dest <proyecto>`

## Pasos

### 1) Identidad

Preguntar al humano: nombre, descripción, idioma de artefactos (es/en), repo URL, plataformas objetivo.

### 2) Verificar scaffold

- `docs/project-context.md` (desde plantilla si falta)
- Carpetas en `docs/workflow/`, `docs/discovery/`, etc.
- Skills en `.cursor/skills/` y/o `.agents/skills/`

### 3) Stack específico

| Plataforma | Acción adicional |
|------------|------------------|
| `backend` (Python) | `onboarding-backend.md` |
| `backend` (Node) | `onboarding-node.md` |
| `mobile` / `tablet` | Scaffold Flutter + `aquelarre-bitrise` |
| `web` | Scaffold React + `aquelarre-docker` |
| `mixed` | Combinar según ADR posterior |

### 4) Actualizar contexto

Completar `docs/project-context.md` §1 y §5.

### 5) Siguiente paso

Recomendar **`/discovery`** o skill `aquelarre-discovery`.
