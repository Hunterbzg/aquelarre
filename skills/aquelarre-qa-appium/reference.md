# Referencia — Appium (Aquelarre)

## Sesión MCP (orden correcto)

1. Preguntar Android vs iOS si no está claro.
2. `select_device` (solo servidor **local**).
3. iOS simulator: `prepare_ios_simulator` y pasar `capabilitiesHint` a `create`.
4. `appium_session_management` action=`create`.
5. Interactuar: `appium_find_element`, `appium_gesture`, `appium_set_value`, `appium_screenshot`.
6. No inventar nombres de tools. Si el MCP no está, decirlo y pedir Appium CLI/sesión del humano.

Mobile MCP (`user-Mobile MCP`) es respaldo de taps por coordenadas cuando Appium no está; es más frágil.

## Locators (prioridad)

| Orden | Estrategia | Flutter |
|-------|------------|---------|
| 1 | accessibility id | `Semantics(identifier: 'login.submit')` |
| 2 | id | Android `resource-id` |
| 3 | nativo | `-android uiautomator` / `-ios predicate` |
| 4 | xpath | Solo si nada más funciona |

Pedir al dev (o aplicar en `ux-loop`) identificadores **estables** en acciones primarias. Textos visibles cambian con i18n.

## Modo explore — generar casos

Derivar de AC + UX, no solo happy path:

- Validación vacía / inválida / límite
- Permisos denegados
- Offline / error de red (si el feature lo contempla)
- Segundo tap, back, rotación
- Rol o dato distinto (si hay test users)
- Lista vacía vs con ítems

Ejecutar en lote; el humano no tiene que mirar cada uno. Reportar solo FAIL + 2–3 PASS representativos.

## Modo ux-loop

1. Instalar build de debug del feature.
2. Recorrer estados UX: loading, empty, error, loaded.
3. Capturar y contrastar con `UX-*` (jerarquía, CTA, mensajes).
4. Si la interacción es mala: proponer cambio concreto al skill `aquelarre-dev-flutter` (no reescribir UX spec entero).

## Modo debug

1. Reproducir **los mismos pasos** del humano o del ticket.
2. Screenshot / page source en el punto de fallo.
3. Expected vs actual en 3–5 líneas.
4. Ofrecer dejar un caso Appium de regresión; no crearlo si el humano no lo pide.

## Límites

- Staging/test only, salvo autorización explícita de prod.
- No flaky sleeps fijos; esperar elemento o estado.
- Un FAIL de Appium no bloquea merge. Es señal para el humano.
