---
name: mitaller-github
description: Aplica convenciones de rama, commits y PR del workflow. Usa este skill para preparar branch por task, mantener trazabilidad con TASK-ID y cerrar Gate 2/3 con PR y merge.
---

# GitHub / Flujo de entrega

Fuente: `docs/AI_WORKFLOW_SKILLS_SPEC.md` (GitHub + gates 2/3).

## Inputs

- Task en estado adecuado.
- Cambios implementados y evidencias de testing.
- Convenciones de branch/commit del equipo.

## Outputs

- Branch y PR alineados al task.
- Commits con trazabilidad (`TASK-<id>` cuando aplique).
- Estado final actualizado en task tras merge.

## Instrucciones

1. Crear/usar branch corta por task antes de codear.
2. Mantener PR enfocado al alcance del task.
3. Confirmar que task tenga links a branch/PR/commits.
4. Antes de merge, verificar Gate 2; despues de merge, Gate 3.
