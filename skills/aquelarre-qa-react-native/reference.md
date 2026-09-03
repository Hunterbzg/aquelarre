# Frameworks E2E — React Native (2026)

Aquelarre elige **Maestro como default** para agentes y humanos que necesitan muchos casos rápido. Detox y Appium siguen siendo válidos.

## Comparación

| | Maestro | Detox | Appium |
|--|---------|-------|--------|
| Enfoque | Black-box, capa de accesibilidad | Gray-box RN (sync JS/animaciones) | Black-box WebDriver |
| Autoría | YAML | JS/TS + Jest | JS/Python/Java |
| Setup | CLI, sin hooks nativos | Build nativo + config | Servidor + drivers + sesión |
| Expo | Bueno | Limitado / más fricción | Posible, más pesado |
| Flakiness | Auto-wait | Muy baja (sync interno) | Waits explícitos |
| Velocidad de escribir casos (agente) | Alta | Media | Media (MCP ayuda en vivo) |
| Device farms | Crece | Moderado | Maduro (BrowserStack, etc.) |
| Flutter / nativo en el mismo equipo | Sí | No | Sí |

## Por qué Maestro es el default Aquelarre

1. El agente puede generar **docenas de casos YAML** alineados a AC sin instrumentar la app.
2. Encaja en `explore` (humano + máquina en paralelo) y `debug` (flow de 15 líneas).
3. Expo managed no obliga a ejectar.
4. Los YAML se leen como script de QA; el humano los corrige fácil.

## Cuándo Detox

- Suite CI que debe ser **determinista** en el bridge RN.
- El equipo ya escribe tests en Jest y quiere E2E en el mismo runner.
- Flujos con animaciones/red donde Appium/Maestro se adelantan.

## Cuándo Appium en RN

- Un solo harness con Flutter (Mi Taller) + RN futuro.
- MCP Appium ya en el IDE y se quiere ver la UI **en el chat** paso a paso.
- Matriz grande de dispositivos reales en la nube.

En ese caso invocar `aquelarre-qa-appium` y poner `testID` / accessibility label en RN.

## Convenciones RN para cualquier runner

```tsx
<Pressable testID="login.submit" accessibilityLabel="Iniciar sesión">
```

Sin `testID`, los flows se atan a texto visible y se rompen con i18n.
