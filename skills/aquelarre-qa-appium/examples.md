# Ejemplos — Appium

## Explore (humano en paralelo)

Humano: “yo pruebo el alta de orden a mano; cubre el resto”.

```markdown
Modo: explore
Feature: alta de orden
Casos: 12 (vacío, SKU inválido, cantidad 0, red error, back a mitad, …)
PASS: 10  FAIL: 2 (cantidad 0 no muestra error; back pierde draft)
Evidencia: docs/testing/evidence/TASK-042/ (local)
```

## Debug

```markdown
Modo: debug
Pasos: Configuración > Perfil > Guardar sin nombre
Expected: "Nombre requerido"
Actual: pantalla en blanco (screenshot 03-blank.png)
Sesión: Android emulador, build local
```

## Registro opcional en task §9

```markdown
### Appium (opt-in, no gate)
- Modo: explore
- 10/12 PASS
- FAIL: ver evidence/TASK-042/notes.md
```
