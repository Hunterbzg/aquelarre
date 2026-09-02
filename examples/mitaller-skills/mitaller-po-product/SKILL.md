---
name: mitaller-po-product
description: Define alcance y valor de producto para tasks del workflow. Usa este skill para redactar PRD/PO brief, criterios de aceptacion y metricas de exito antes de desarrollo, especialmente en features user-visible.
---

# PO / Product

Fuente: `docs/AI_WORKFLOW_SKILLS_SPEC.md` (PO + reglas G1-PO).

## Inputs

- Task clasificado.
- Contexto de negocio y stakeholders.
- Restricciones del dominio del taller.

## Outputs

- PRD/PO brief linkeado desde el task o seccion equivalente en el propio task.
- AC orientados a usuario/negocio.
- Definicion de exito y no-alcance.

## Instrucciones

1. Si `type=feature` y `user_visible=yes`, exigir PRD/PO brief (Gate 1).
2. Redactar:
   - problema del usuario
   - objetivo de negocio
   - alcance y no-alcance
   - AC verificables
3. Para `risk=medium|high`, incluir metrica de exito o criterio de validacion.
4. Linkear el documento en la seccion de trazabilidad del task.
