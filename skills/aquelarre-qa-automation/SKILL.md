---
name: aquelarre-qa-automation
description: Ejecuta pruebas realistas, smoke visual, E2E y reproduccion de bugs. Usa este skill cuando el usuario pida probar como usuario real, risk=high, bugs user-visible, o validacion post-implementacion mas alla de unit tests.
---

# QA Automation

Fuentes:

- `aquelarre-testing` — plan y evidencia Gate 2 (complementario)
- `docs/testing/EVIDENCE_LOCAL.md` — politica de capturas locales
- `reference.md` — herramientas por plataforma
- MCP: Appium, Mobile MCP, Chrome DevTools (cuando disponibles)

## Objetivo

Validar comportamiento en condiciones cercanas al usuario real y reproducir bugs con evidencia trazable.

## Inputs

- Task con AC, UX spec, pasos de reproducción (bugs).
- `risk=high` o solicitud explícita del humano.
- App desplegada, build Bitrise, o entorno local levantado.

## Outputs

- Escenarios ejecutados con resultado PASS/FAIL.
- Evidencia en `docs/testing/evidence/<TASK-id>/` (gitignored).
- Registro en task §9 con rutas locales y resumen (sin commitear binarios).

## Gates que aplica

- Refuerza **Gate 2** cuando E2E/smoke es requerido por riesgo o UX crítica.
- **Gate 3:** smoke post-merge bajo demanda del humano.

## Instrucciones

1. Derivar escenarios desde AC y UX spec (happy path + casos borde).
2. Para **bugs**: reproducir pasos exactos; documentar expected vs actual.
3. Elegir herramienta según `platform`:
   - **mobile/tablet:** Appium MCP, Mobile MCP, integration tests Flutter
   - **web:** Playwright/Cypress, Chrome DevTools MCP
   - **backend:** requests de integración, contract tests
4. Guardar capturas/video en `docs/testing/evidence/`; **no** versionar en git.
5. En task §9: PASS/FAIL, herramienta usada, ruta local de evidencia.
6. Si no se puede automatizar: smoke manual documentado paso a paso con capturas locales.
7. Coordinar con `aquelarre-bitrise` para validar build verde antes de smoke en dispositivo.

## Cuándo invocar

| Trigger | Acción |
|---------|--------|
| `risk=high` + UI | E2E o smoke obligatorio o N/A justificado |
| Bug user-visible | Repro + regresión |
| Usuario: "prueba como usuario" | Smoke guiado |
| Post-implementación crítica | Regresión del flujo |

## Coordinación

| Skill | Rol |
|-------|-----|
| `aquelarre-testing` | Test plan y evidencia unit/integration |
| `aquelarre-bitrise` | Build instalable para mobile |
| `aquelarre-docker` | Entorno web/API para E2E |

## Artefactos

| Artefacto | Ruta |
|-----------|------|
| Evidencia local | `docs/testing/evidence/<TASK-id>/` (gitignored) |
| Política | `docs/testing/EVIDENCE_LOCAL.md` |
