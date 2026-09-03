# Workflow — QA dispositivo (opt-in)

Pruebas Appium / Maestro **cuando el humano las pide**. No hay comando obligatorio ni gate.

**Skills:** `aquelarre-qa-automation` → `aquelarre-qa-appium` o `aquelarre-qa-react-native`

## Prerrequisitos

Ninguno de workflow. Sí hace falta: app instalable + dispositivo/emulador (o MCP Appium).

## Pasos

1. Confirmar modo: `explore` | `ux-loop` | `debug`.
2. Flutter / nativo → Appium. React Native → Maestro (salvo Detox/Appium ya en el repo).
3. Ejecutar casos. Evidencia en `docs/testing/evidence/` (no git).
4. Reportar tabla PASS/FAIL/BLOCKED. No cambiar `status` del task por esto.

## Relación con gates

Gate 2 = `aquelarre-testing`. Este workflow no aprueba ni bloquea Done.
