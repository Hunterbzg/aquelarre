---
name: aquelarre-github
description: Aplica convenciones de rama, commits y PR del workflow Aquelarre. Usa este skill para preparar branch por task, mantener trazabilidad con TASK-ID y cerrar Gate 2/3 con PR y merge.
---

# GitHub / Flujo de entrega

Fuente: `docs/AI_WORKFLOW_SKILLS_SPEC.md` (GitHub + gates 2/3).

## Objetivo

Mantener trazabilidad Git alineada al TASK y cumplir gates de entrega antes y despues del merge.

## Inputs

- Task en estado adecuado (`in_progress` o `in_review`).
- Cambios implementados y evidencias de testing (Gate 2).
- Convenciones de branch/commit del proyecto.

## Outputs

- Branch y PR alineados al task.
- Commits con trazabilidad (`TASK-<id>` cuando aplique).
- Estado del task actualizado tras merge (`done`).

## Gates que aplica

- **Gate 2:** branch linkeada; PR abierto con `TASK-<id>` en titulo o cuerpo.
- **Gate 3:** PR mergeado; link en task; `status=done`.

## Instrucciones

1. Crear o usar branch por task **antes de codear** (convencion: `task/TASK-<id>-<slug>`).
2. Mantener PR enfocado al alcance del task (1 task ≈ 1 PR).
3. Incluir `TASK-<id>` en titulo de PR y mensajes de commit cuando aplique.
4. Confirmar que el task tenga links a branch, PR y commits en la seccion de trazabilidad.
5. Antes de solicitar merge: verificar Gate 2 (evidencia de tests).
6. Tras merge y aprobacion humana: actualizar task a `done` (Gate 3).

## Artefactos

- Consume: `docs/workflow/tasks/TASK-<id>-<slug>.md`
- Actualiza: links `branch`, `pr`, `commits` en frontmatter del task
