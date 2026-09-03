# Referencia — QA Automation (router)

## Mapa

| Stack | Herramienta Aquelarre | Default industria |
|-------|----------------------|-------------------|
| Flutter mobile/tablet | `aquelarre-qa-appium` | Appium (+ MCP) |
| React Native | `aquelarre-qa-react-native` | **Maestro**; Detox si ya está |
| React web | Playwright | Playwright |
| API | skill `dev-*` | pytest / vitest / supertest |

Flutter + Maestro es válido si el repo consumidor lo eligió; el default Aquelarre para Flutter sigue siendo Appium (MCP en el IDE, debug en vivo).

## Evidencia

Ver `docs/testing/EVIDENCE_LOCAL.md`. Nunca versionar PNG/video.

## Límites

- No producción sin autorización.
- No credenciales en flows commiteados.
- Entorno caído = BLOCKED, no FAIL de producto.
