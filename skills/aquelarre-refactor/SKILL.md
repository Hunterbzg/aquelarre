---
name: aquelarre-refactor
description: Gestiona refactors opt-in del workflow Aquelarre con foco en seguridad de cambio. Usa este skill cuando type=refactor o haya deuda tecnica explicitada, para planificar, ejecutar y validar regresion.
---

# Refactor (opt-in)

Fuente: `docs/AI_WORKFLOW_SKILLS_SPEC.md` (matriz refactor + gates).

## Objetivo

Planificar y ejecutar refactors de forma controlada, sin cambiar comportamiento observable salvo lo acordado en el task.

## Inputs

- Task con `type=refactor` o deuda tecnica explicitada en el task.
- Modulos o limites arquitectonicos afectados.
- Riesgo tecnico y funcional (`risk`).

## Outputs

- Plan de refactor (`REF-<id>-<slug>.md` en `docs/tech-debt/refactor-plans/` o seccion en el task).
- Definicion de comportamiento que **no** debe cambiar (AC no-funcionales).
- Evidencia de regresion y estabilidad para Gate 2.

## Gates que aplica

- **Gate 1:** plan de refactor + AC no-funcionales + test plan reforzado; ADR si hay cambio de boundaries.
- **Gate 2:** evidencia de regresion (unit/integration/arch tests segun alcance).

## Instrucciones

1. **No ejecutar** refactor sin plan explicito (skill opt-in; el orquestador solo invoca si `type=refactor`).
2. Documentar que comportamiento visible debe permanecer igual.
3. Coordinar con skill de arquitectura cuando haya cambio de boundaries o decisiones estructurales.
4. Si `risk=high`, definir estrategia de rollback y mitigacion en el plan.
5. Exigir pruebas de regresion antes de Gate 2; justificar `N/A` con motivo si no aplica.
6. Registrar en el task: fases completadas, decisiones y evidencia de tests.

## Artefactos

- Produce o consume: `docs/tech-debt/refactor-plans/REF-*` (opcional)
- Actualiza: secciones de plan y evidencia en `TASK-*`
