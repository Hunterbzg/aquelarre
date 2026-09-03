---
name: aquelarre-qa-appium
description: Automatiza la app movil con Appium (MCP o scripts) de forma opcional. Usa este skill cuando el usuario pida probar un feature con muchos casos, validar UX en dispositivo, o reproducir un bug en vivo. No es gate. Aplica a Flutter, nativo y RN si el proyecto ya usa Appium.
---

# QA Appium (móvil)

Fuentes:

- `aquelarre-qa-automation` — router (cuándo invocar)
- `docs/testing/EVIDENCE_LOCAL.md` — capturas locales
- MCP `user-appium-mcp` (si está conectado)
- `reference.md` — sesión, locators, modos

## Objetivo

Ser una **herramienta opcional** para explorar, cubrir casos y depurar en dispositivo o emulador. El humano sigue siendo quien aprueba Done.

**No es gate.** Un task puede llegar a Gate 2/3 sin una sola corrida Appium. Si el humano no lo pide, no lanzarlo.

## Cuándo usarlo (cualquier fase)

| Modo | Momento | Qué hace el agente |
|------|---------|---------------------|
| `explore` | Humano prueba el feature a mano y pide cobertura extra | Genera y ejecuta muchos casos (borde, error, roles, rotación) que el humano no va a hacer |
| `ux-loop` | Durante implementación Flutter | Interactúa con la UI real, captura, compara vs UX spec, sugiere ajustes |
| `debug` | Bug o comportamiento raro | Reproduce el caso en vivo, captura expected vs actual, deja script de regresión **si el humano lo quiere** |

Frases típicas: “pon Appium a probar X”, “reproduce esto”, “mira cómo se siente el flujo”, “cubre los casos que yo no hago”.

## Inputs

- App instalable (debug local, emulador, o build Bitrise).
- AC, UX spec, o pasos del bug (aunque sea un mensaje informal).
- Plataforma: Android / iOS (preguntar si hay varias).
- Credenciales de **staging/test** — nunca producción sin autorización explícita.

## Outputs

- Resultado por escenario: PASS / FAIL / BLOCKED (dispositivo, sesión, dato).
- Evidencia en `docs/testing/evidence/<TASK-id o bug>/` (gitignored).
- Opcional: casos reutilizables en `docs/qa/appium/` o suite del proyecto (solo si el humano pide dejarlos).
- Nota breve en task §9 **solo si** se ejecutó (no inventar N/A de Appium en cada task).

## Gates

Ninguno. No bloquear PR, merge ni Done por falta de Appium.

`aquelarre-testing` sigue cubriendo Gate 1/2 (unit/widget/integration). Este skill es **adicional**.

## Instrucciones

1. Confirmar **modo** (`explore` / `ux-loop` / `debug`) y dispositivo.
2. Abrir sesión Appium:
   - Preferir MCP: `select_device` → (iOS sim: `prepare_ios_simulator`) → `appium_session_management` action=`create`.
   - Remoto: no usar `select_device`; capabilities en `create`.
3. Locators: **accessibility id** (Flutter: `Semantics` identifier / `ValueKey` estable) → `id` → nativo → xpath **último**.
4. Off-screen: `appium_gesture` `scroll_to_element`, no spamear find.
5. Cada caso: acción → assert visible/texto/estado → `appium_screenshot` si FAIL o si el humano quiere ver.
6. Al terminar: resumen tabla (caso, resultado, nota). Cerrar o dejar sesión si el humano sigue debuggeando.
7. No commitear capturas ni credenciales.

## Coordinación

| Skill | Rol |
|-------|-----|
| `aquelarre-qa-automation` | Router si el pedido es genérico (“prueba esto”) |
| `aquelarre-qa-react-native` | RN greenfield → Maestro, no Appium (salvo que el repo ya use Appium) |
| `aquelarre-dev-flutter` | `ux-loop` durante TDD de UI |
| `aquelarre-ux-mobile` / `ux-tablet` | Comparar pantallas vs spec |
| `aquelarre-bitrise` | APK/IPA instalable |
| `aquelarre-testing` | Plan Gate 2 (independiente) |

## Artefactos

| Artefacto | Ruta |
|-----------|------|
| Evidencia | `docs/testing/evidence/<id>/` |
| Casos opcionales | `docs/qa/appium/` o suite del consumidor |
