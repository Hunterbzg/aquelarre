# Ejemplos — QA React Native

## Humano + Maestro en paralelo

“Yo pruebo el checkout; cubre cupones, stock 0 y back.”

→ 3 YAML en `maestro/checkout-*.yaml`, `maestro test maestro/checkout-*.yaml`, tabla PASS/FAIL.

## Detox ya en el repo

No introducir Maestro en el mismo PR. Extender `e2e/` Detox con el caso del task.

## RN + Appium (equipo mixto)

Usar `aquelarre-qa-appium` y los mismos `testID` que usaría Maestro.
