# Workflow — Sprint plan

Planifica iteración: stories, tasks y Definition of Ready.

**Comando Antigravity:** `/sprint-plan`  
**Skill:** `aquelarre-scrum-master`  
**Gate:** 1 → 2 (DoR por task)

## Prerrequisitos

- EPICs/stories o backlog acordado
- ADR/contratos si el sprint toca arquitectura

## Pasos

### 1) Crear sprint plan

`docs/workflow/sprints/SPRINT-<id>-<slug>.md` desde `templates/SPRINT-PLAN.md`.

### 2) Crear tasks (ruta canónica)

Cada task en **`docs/workflow/tasks/TASK-<id>-<slug>.md`** — **no** bajo `docs/sprints/`.

Completar clasificación Gate 0:

- `type`, `platform`, `risk`, `user_visible`, `db_change`, `tdd`, `ci`

### 3) Backend TDD

Si `platform=backend` y `tdd=on`: completar task §6b y §8a antes de `ready`.

### 4) Artefactos Gate 1

Por routing del orquestador: PO, UX, TEST, ADR según aplique. Linkear en el task.

### 5) Marcar `ready`

Solo tasks con Gate 1 PASS pasan a implementación.

### 6) Siguiente paso

`/implement` en el primer task `ready`.

## Rutas

Ver `docs/ARTIFACT_PATHS.md`.
