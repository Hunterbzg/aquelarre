---
name: aquelarre-po-product
description: Define alcance y valor de producto para tasks del workflow Aquelarre. Usa este skill para redactar PRD/PO brief, criterios de aceptacion y metricas de exito antes de desarrollo, especialmente en features user-visible.
---

# PO / Product

Fuente: `docs/AI_WORKFLOW_SKILLS_SPEC.md` (PO + reglas G1-PO).

## Objetivo

Traducir necesidades de negocio en requisitos verificables antes de implementacion, sin que el agente de desarrollo invente alcance.

## Inputs

- Task clasificado (`type`, `user_visible`, `risk`).
- Contexto de negocio y stakeholders.
- Restricciones del dominio del **proyecto** (regulacion, plataformas, integraciones).

## Outputs

- PRD/PO brief en `docs/product/briefs/PRD-<id>-<slug>.md` o seccion equivalente en el task.
- AC orientados a usuario y negocio (verificables).
- Definicion de exito, no-alcance y metricas cuando aplique.

## Gates que aplica

- **Gate 1 (G1-PO-001):** si `type=feature` y `user_visible=yes` → PRD linkeado o PO brief en el task.
- **Gate 1 (G1-PO-002, warning):** si `risk=medium|high` → metrica de exito o criterio de validacion.

## Instrucciones

1. Determinar si aplica PO completo o PO light:
   - **PO completo:** `type=feature` + `user_visible=yes`
   - **PO light:** `type=feature` + `user_visible=no` → alcance + AC minimos en el task
   - **N/A:** bugs/chores/docs → declarar motivo en el task
2. Redactar como minimo:
   - problema del usuario o stakeholder
   - objetivo de negocio
   - alcance y no-alcance
   - AC verificables (checklist)
3. Para `risk=medium|high`, incluir metrica de exito o como se validara el valor entregado.
4. Linkear PRD desde la seccion de trazabilidad del task (frontmatter `links` o seccion 11).
5. No duplicar log operativo en el PRD; el task conserva la bitacora de implementacion.

## Artefactos

| Artefacto | Ruta |
|-----------|------|
| PRD / PO brief | `docs/product/briefs/PRD-<id>-<slug>.md` |
| Template | Apéndice B del `AI_WORKFLOW_SKILLS_SPEC.md` |

## PO light (features internas)

Cuando `user_visible=no`, basta con seccion en el task:

- Problema / objetivo (2–4 bullets)
- AC tecnicos o de integracion
- No-alcance explicito
