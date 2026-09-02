# Tasks del workflow

Esta carpeta contiene las unidades de trabajo canónicas del workflow AI-Driven.

## Convenciones

- Formato de archivo: `TASK-<id>-<slug>.md`
- Ruta canónica: `docs/workflow/tasks/TASK-<id>-<slug>.md`
- Fuente de verdad del template: `docs/AI_WORKFLOW_SKILLS_SPEC.md` (sección "Template: Task (unidad base)")

## Estados permitidos

- `intake`
- `ready`
- `in_progress`
- `in_review`
- `blocked`
- `done`
- `cancelled`

## Reglas mínimas antes de código

- Debe existir un `TASK-*` completo.
- El task debe incluir AC y clasificación inicial.
- Si el task no está en `ready`, no iniciar implementación.

## Trazabilidad

Cada task debe linkear, cuando aplique:

- PRD / PO brief
- UX spec
- ADR
- Test plan
- Cambios DB / Supabase
- Branch y PR
