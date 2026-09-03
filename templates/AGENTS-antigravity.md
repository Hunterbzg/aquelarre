# Aquelarre — Reglas globales (Antigravity)

> Copiar este archivo a `.agents/AGENTS.md` en el proyecto consumidor (el instalador lo hace si no existe).
> Complementa los skills en `.agents/skills/aquelarre-*` — no los reemplaza.

## Router de intención

| Intención | Acción |
|-----------|--------|
| Comando `/onboarding`, `/discovery`, `/prd`, … | Leer `.agents/workflows/<nombre>.md` y ejecutar |
| “¿Qué sigue?” / estado del proyecto | `/status` → `aquelarre-workflow-orchestration` |
| Editar o implementar un TASK | Skills según `platform` + routing en SPEC |
| Pregunta directa / sin workflow | Responder libremente; sin gates ni artefactos |

## Workflows disponibles

`onboarding.md` · `discovery.md` · `prd.md` · `architecture.md` · `sprint-plan.md` · `implement.md` · `status.md` · `qa-device.md` · `onboarding-backend.md` · `onboarding-node.md` · `implement-backend.md` · `implement-node.md`

Al invocar un workflow, **leer el archivo completo** y delegar en el skill Aquelarre indicado.

## Gates (resumen)

| Gate | Cuándo |
|------|--------|
| 0 | Task clasificado; discovery si proyecto/dominio nuevo |
| 1 | Ready for dev — artefactos linkeados |
| 2 | Tests + evidencia en task §9 |
| 3 | PR mergeado + aprobación humana |

Detalle: `docs/AI_WORKFLOW_SKILLS_SPEC.md`

## Rutas canónicas

- Tasks: `docs/workflow/tasks/TASK-<id>-<slug>.md` (única ubicación)
- Sprints: `docs/workflow/sprints/SPRINT-<id>-<slug>.md`
- **No** usar `docs/sprints/sprint-NNN/tasks/`

Guía completa: `docs/ARTIFACT_PATHS.md`

## Idioma

- Artefactos de workflow: español (salvo preferencia en `project-context.md`)
- Código e identificadores técnicos: inglés

## Inicio de sesión

Si el usuario no tiene petición concreta, leer `docs/project-context.md` y sugerir `/status`.
