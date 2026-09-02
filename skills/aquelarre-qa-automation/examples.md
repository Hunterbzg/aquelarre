# Ejemplos — QA Automation

## Escenario smoke mobile

```markdown
1. Abrir app en build Bitrise #1234
2. Tap "Iniciar sesión"
3. Ingresar credenciales test
4. Verificar pantalla Home — PASS
Evidencia: docs/testing/evidence/TASK-010/smoke-home.png
```

## Bug repro

```markdown
## Reproducción
1. Ir a Configuración > Perfil
2. Tap Guardar sin nombre
**Expected:** mensaje "Nombre requerido"
**Actual:** pantalla en blanco
**Evidencia:** TASK-088/repro-blank.png
```

## N/A justificado

```markdown
E2E: N/A — chore interno en script CI; sin superficie UI; unit tests cubren el cambio.
```
