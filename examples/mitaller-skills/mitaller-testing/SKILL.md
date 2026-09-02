---
name: mitaller-testing
description: Define y ejecuta estrategia de pruebas del workflow. Usa este skill para construir test plan, verificar evidencia de Gate 2 y cerrar cobertura minima segun riesgo del task.
---

# Testing

Fuentes:

- `docs/AI_WORKFLOW_SKILLS_SPEC.md` (Test plan + Gate 2)
- `docs/VALIDACIONES_Y_TESTS.md`

Referencia ampliada: `reference.md`

## Inputs

- Task y clasificacion de riesgo.
- Cambios realizados (codigo, DB, UX, auth).
- Alcance funcional y tecnico.

## Outputs

- Test plan (en task o TEST-*).
- Evidencia de ejecucion con resultado PASS/FAIL.
- Recomendaciones de cobertura adicional en riesgos altos.

## Instrucciones

1. Verificar que exista plan de pruebas antes de implementar (Gate 1).
2. Ejecutar o solicitar evidencia de:
   - unit
   - widget
   - integration/E2E si aplica
3. Si `risk=high`, reforzar con pruebas adicionales o justificar `N/A`.
4. Registrar comandos/resultados en task (Gate 2 blocker).
5. **Evidencia visual (smoke/Appium/MCP):** guardar solo en `docs/testing/evidence/` (gitignored). No `git add` de esa carpeta ni de PNG/JPG de smoke. En el TASK/TEST documentar PASS/FAIL + ruta local; ver `docs/testing/EVIDENCE_LOCAL.md`.

## Enfoque de pruebas para patrones del proyecto

- En sincronizacion de datos, validar:
  - lectura local cuando `shouldUseLocal` aplica
  - refresco remoto cuando `updated_at` remoto es mas reciente
- En escrituras, validar:
  - online-first (remoto primero)
  - cache local posterior y consistente
- En UX, validar estados `loading/error/empty/success` y acciones primarias de AppBar.
