---
name: aquelarre-qa-automation
description: Enruta pruebas realistas opcionales (Appium, Maestro/RN, Playwright). Usa este skill cuando el usuario pida probar como usuario, cubrir muchos casos, validar UX en dispositivo, o reproducir un bug. No es gate ni bloquea Done. Para planes Gate 2 usa aquelarre-testing.
---

# QA Automation (router)

Fuentes:

- `aquelarre-qa-appium` — Flutter / nativo / Appium MCP
- `aquelarre-qa-react-native` — RN (Maestro default)
- `reference.md` — mapa de herramientas
- `docs/testing/EVIDENCE_LOCAL.md`

## Objetivo

Punto de entrada cuando el humano pide **probar de verdad**, no sustituir unit tests.

Es una **herramienta**. Se puede usar en discovery tardío, desarrollo, QA o debug. **No forma parte de ningún gate.**

| Qué | Skill |
|-----|--------|
| Test plan + evidencia unit/widget/API (Gate 1/2) | `aquelarre-testing` |
| App Flutter / dispositivo / “pon Appium” | `aquelarre-qa-appium` |
| App React Native | `aquelarre-qa-react-native` |
| Web | Playwright / Cypress / Chrome DevTools MCP (este skill, sección web) |
| API | requests del skill backend, no este |

## No es gate

- No exigir E2E Appium/Maestro para `ready`, PR o Done.
- `G2-TEST-002` (E2E si `risk=high`) sigue siendo **warning** del skill testing, no un FAIL de Supervisor por falta de Appium.
- Si el usuario no lo pide, no inventar una suite E2E.

## Modos (delegar)

| Pedido del humano | Modo | Skill |
|-------------------|------|--------|
| “yo pruebo X; cubre el resto” | `explore` | appium o RN |
| “mira si el flujo se siente bien” | `ux-loop` | appium o RN + UX spec |
| “reproduce este bug” | `debug` | appium o RN |
| “smoke web del checkout” | smoke | Playwright (abajo) |

## Web (breve)

- Playwright preferido en greenfield web; Cypress si el repo ya lo usa.
- MCP Chrome DevTools para inspección puntual.
- Evidencia igual: `docs/testing/evidence/` gitignored.

## Instrucciones

1. Identificar plataforma (`package` Flutter vs `react-native` vs web).
2. Invocar el skill especializado y **seguirlo**.
3. Guardar capturas solo locales.
4. Si no hay dispositivo/MCP: BLOCKED + qué necesita el humano — no fingir PASS.

## Coordinación

| Skill | Rol |
|-------|-----|
| `aquelarre-testing` | Gates 1–2 de tests de código |
| `aquelarre-qa-appium` | Móvil Appium |
| `aquelarre-qa-react-native` | Móvil RN |
| `aquelarre-bitrise` | Binario instalable |
| `aquelarre-docker` | Web/API local para E2E |
