# Referencia — Testing (Aquelarre)

## Cobertura por plataforma

### Flutter (mobile / tablet)

| Nivel | Cuando |
|-------|--------|
| Unit | Logica de dominio, validaciones, parsers |
| Widget | Pantallas con estados UI y acciones |
| Integration | Flujos multi-pantalla, navegacion |
| E2E / smoke (opt-in) | Si el humano pide Appium/dispositivo — skill `aquelarre-qa-appium`; no bloquea Gate 2 |

### Web (React)

| Nivel | Cuando |
|-------|--------|
| Unit | Funciones puras, hooks, utilidades |
| Component | Componentes con interaccion y estados |
| Integration | Paginas con router y data fetching |
| E2E | Flujos criticos (Playwright, Cypress, etc.) |

### Backend (FastAPI / Node)

| Nivel | Cuando |
|-------|--------|
| Unit | Servicios, validaciones, mappers |
| Integration API | Endpoints con DB/testcontainers o mocks |
| Contract | Si hay clientes moviles/web dependientes |

## Criterio Gate 2

- Reportar **comandos ejecutados** o link a pipeline CI.
- Resultado **PASS/FAIL** explicito (no "parece ok").
- Declarar **N/A** con motivo cuando un nivel no aplique.
- Para mobile/tablet con Bitrise: linkear build PASS en el task cuando exista.

## Evidencia visual local (smoke / Appium / MCP)

- Carpeta canonica: `docs/testing/evidence/` (gitignored en el proyecto consumidor).
- Subcarpetas sugeridas: `TASK-<id>/` o `TASK-YYYY-NNN-<slug>/`.
- **Nunca** versionar PNG, JPG, videos de smoke.
- En el task: PASS/FAIL + ruta local con nota "no commitear".
- Plantilla de politica: `docs/testing/EVIDENCE_LOCAL.md` (en harness o copiar al proyecto).

## UX en pruebas

Cuando `surface` incluye `ui` y `user_visible=yes`, verificar al menos:

- estados `loading`, `empty`, `error`, `success` / `loaded`
- acciones primarias visibles y accesibles
- mensajes de error comprensibles

## Tests de arquitectura

Aplica cuando `type=refactor` o cambio estructural de capas:

- reglas de dependencia entre capas (si el proyecto las define)
- lint custom o arch tests en CI
- declarar evidencia o `N/A` con motivo en el task

## Convenciones del proyecto consumidor

Si el repo tiene documentacion propia de tests (ej. `docs/VALIDACIONES_Y_TESTS.md`, estandares de naming, fixtures), **priorizarla** sobre esta referencia generica.

## Fuentes del harness

- `docs/AI_WORKFLOW_SKILLS_SPEC.md` — Gate 2, Apéndice E (template TEST)
- `docs/testing/EVIDENCE_LOCAL.md` — politica evidencia local
