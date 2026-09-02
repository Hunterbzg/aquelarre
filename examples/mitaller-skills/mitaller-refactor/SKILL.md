---
name: mitaller-refactor
description: Gestiona refactors opt-in del workflow con foco en seguridad de cambio. Usa este skill cuando type=refactor o haya deuda tecnica explicitada, para planificar, ejecutar y validar regresion.
---

# Refactor (opt-in)

Fuente: `docs/AI_WORKFLOW_SKILLS_SPEC.md` (matriz refactor + gates).

## Inputs

- Task `type=refactor` o deuda tecnica explicita.
- Modulos/limites afectados.
- Riesgo tecnico y funcional.

## Outputs

- Plan de refactor (REF-* o seccion en task).
- Definicion de comportamiento que no debe cambiar.
- Evidencia de regresion y estabilidad.

## Instrucciones

1. No ejecutar refactor sin plan explicito.
2. Coordinar con Arquitectura cuando haya cambio de boundaries.
3. Definir estrategia de rollback y mitigacion si `risk=high`.
4. Exigir pruebas de regresion antes de Gate 2.
