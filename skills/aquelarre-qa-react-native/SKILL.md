---
name: aquelarre-qa-react-native
description: Automatiza apps React Native de forma opcional. Default Maestro (YAML, rapido de generar). Detox si el repo ya lo usa o pide gray-box Jest. Appium solo si el proyecto ya tiene sesion Appium. No es gate. Usalo para cubrir casos, UX en dispositivo o reproducir bugs.
---

# QA React Native (Maestro)

Fuentes:

- `reference.md` — por qué Maestro, vs Detox/Appium
- `maestro-patterns.md` — flows YAML, testID, CI
- `docs/testing/EVIDENCE_LOCAL.md`

## Recomendación de framework

Para un proyecto RN **nuevo** (y para el agente IA generando muchos casos):

| Prioridad | Herramienta | Cuándo |
|-----------|-------------|--------|
| **1 — default** | **Maestro** | Greenfield, Expo, flujos de usuario, debug rápido, YAML que el agente escribe en minutos |
| 2 | **Detox** | El repo ya tiene Detox, o se necesita gray-box (sync con JS bridge) y suite Jest en CI |
| 3 | **Appium** | Mismo stack que Flutter/nativo del equipo, farms WebDriver, MCP Appium ya configurado |

No mezclar tres runners en un feature. Brownfield: usar **el que ya está**.

## Objetivo

Misma filosofía que Appium en Flutter: herramienta **opt-in** en cualquier fase. El humano aprueba Done.

**No es gate.** Gate 2 de RN (cuando exista skill dev) sigue siendo Jest/RTL/unit. Maestro no bloquea PR.

## Modos

| Modo | Uso |
|------|-----|
| `explore` | Humano prueba el happy path; Maestro corre el resto de casos |
| `ux-loop` | Durante desarrollo: flow corto + screenshots vs UX spec |
| `debug` | Replicar bug con un flow mínimo y ver el fallo en el momento |

## Inputs

- App en simulador/emulador o dispositivo (Maestro no exige instrumentation nativa).
- AC / UX / pasos del bug.
- `testID` en controles clave (pedirlos al dev si faltan).

## Outputs

- Flows `.yaml` en `maestro/` o `docs/qa/maestro/` (versionar YAML; **no** capturas).
- PASS/FAIL por flow.
- Evidencia visual en `docs/testing/evidence/` (gitignored).

## Instrucciones

1. Confirmar RN (no Flutter). Si es Flutter → `aquelarre-qa-appium` (o Maestro Flutter si el repo ya lo usa).
2. Si hay `e2e/` Detox o `maestro/` existente → seguirlo.
3. Si greenfield y el humano pide automatizar → Maestro.
4. Escribir flows cortos (un flujo de usuario por archivo).
5. `maestro test <flow.yaml>` (o CLI del proyecto).
6. FAIL: screenshot + paso; no reescribir la app entero sin skill dev.
7. No bloquear merge por flows rotos de entorno (emulador caído = BLOCKED, no FAIL de producto).

## Coordinación

| Skill | Rol |
|-------|-----|
| `aquelarre-qa-automation` | Router |
| `aquelarre-qa-appium` | Flutter / Appium ya instalado |
| `aquelarre-dev-react` | Solo web React; RN nativo no es este skill |
| `aquelarre-ux-mobile` | Contraste UX |

## Artefactos

| Artefacto | Ruta |
|-----------|------|
| Flows Maestro | `maestro/<slug>.yaml` |
| Evidencia | `docs/testing/evidence/<id>/` |
