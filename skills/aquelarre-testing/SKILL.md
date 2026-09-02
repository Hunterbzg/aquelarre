---
name: aquelarre-testing
description: Define y ejecuta estrategia de pruebas del workflow Aquelarre. Usa este skill para construir test plan, verificar evidencia de Gate 2 y cerrar cobertura minima segun riesgo y plataforma del task.
---

# Testing

Fuentes:

- `docs/AI_WORKFLOW_SKILLS_SPEC.md` (Test plan + Gate 2)
- `reference.md` (cobertura, evidencia local, criterios por plataforma)

## Objetivo

Hacer verificable el trabajo antes del PR/merge: plan antes de implementar, evidencia despues.

## Inputs

- Task y clasificacion (`type`, `surface`, `platform`, `risk`, `tdd`).
- Cambios realizados (codigo, DB, UX, auth, CI).
- Convenciones de testing del proyecto (si existen en `docs/` del consumidor).

## Outputs

- Test plan en seccion 8 del task o `docs/qa/test-plans/TEST-<id>-<slug>.md`.
- Evidencia de ejecucion con resultado **PASS/FAIL** (seccion 9 del task).
- Recomendaciones de cobertura adicional cuando `risk=high`.

## Gates que aplica

- **Gate 1 (G1-TEST-001):** test plan definido antes de implementar (unit/widget/integration/E2E con `N/A` explicito).
- **Gate 2 (G2-EVID-001):** comandos ejecutados y/o link CI + PASS/FAIL sin ambiguedad.

## Instrucciones

1. **Antes de implementar (Gate 1):** definir test plan con niveles aplicables y `N/A` justificado donde no aplique.
2. **Durante/despues de implementar:** ejecutar o solicitar evidencia segun `platform`:
   - **mobile / tablet (Flutter):** unit, widget, integration; E2E/smoke si `risk=high` o flujo critico
   - **web (React):** unit, component, integration; E2E si aplica
   - **backend (FastAPI/Node):** unit, integration API; contract tests si hay consumidores
3. Si `risk=high`, reforzar cobertura o documentar por que `N/A` es aceptable.
4. Registrar en task seccion 9:
   - comandos ejecutados
   - resultado PASS/FAIL
   - link a CI (Bitrise, GitHub Actions, etc.) si existe
5. **Evidencia visual** (smoke, Appium, Mobile MCP, capturas): solo en `docs/testing/evidence/` (gitignored). Ver `reference.md` y `docs/testing/EVIDENCE_LOCAL.md` del proyecto.
6. Para `type=refactor`, incluir pruebas de regresion y tests de arquitectura si cambio de estructura.

## Cobertura minima por riesgo

| Riesgo | Minimo esperado |
|--------|-----------------|
| `low` | unit + lint/formato |
| `medium` | unit + pruebas en modulos tocados |
| `high` | unit + integration (+ E2E o smoke documentado) |

## Artefactos

| Artefacto | Ruta |
|-----------|------|
| Test plan (grande) | `docs/qa/test-plans/TEST-<id>-<slug>.md` |
| Evidencia local | `docs/testing/evidence/` (no versionar) |
| Template | Apéndice E del `AI_WORKFLOW_SKILLS_SPEC.md` |
