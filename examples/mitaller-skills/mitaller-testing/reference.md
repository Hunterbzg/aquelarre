# Referencia interna de testing

## Cobertura minima por task

- Unit para logica de negocio/validaciones.
- Widget para UI con estados y acciones.
- Integration/E2E en flujos criticos o riesgo alto.

## Criterio Gate 2

- Reportar comandos ejecutados.
- Reportar resultado PASS/FAIL sin ambiguedad.
- Declarar `N/A` con motivo cuando no aplique.

## Evidencia visual local (smoke / Appium / Mobile MCP)

- Carpeta canónica: `docs/testing/evidence/` (completa, incluida en `.gitignore`).
- Subcarpetas sugeridas: `TASK-YYYY-NNN/` o prefijos `e1-NNN-*.png`.
- Guardar screenshots ahí al automatizar; **nunca** versionar binarios de evidencia.
- En task: resultado + referencia de ruta local (“no commitear”), no frontmatter `links.evidence` a archivos del repo.
- Doc: `docs/testing/EVIDENCE_LOCAL.md`.

## Fuentes internas

- `docs/VALIDACIONES_Y_TESTS.md`
- `docs/testing/EVIDENCE_LOCAL.md`
- `docs/AI_WORKFLOW_SKILLS_SPEC.md` (Gate 2)

## Trazabilidad de inspiracion externa

- Basado parcialmente en:
  - `.cursor/FlutterArmy/skills-main/skills/flutter-testing-apps/SKILL.md`
