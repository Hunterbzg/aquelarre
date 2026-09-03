# Plantillas — Aquelarre

Copias listas para usar en proyectos consumidores. La spec completa y apéndices viven en [`docs/AI_WORKFLOW_SKILLS_SPEC.md`](../docs/AI_WORKFLOW_SKILLS_SPEC.md).

## Uso

1. Copiar la plantilla al path sugerido en el proyecto.
2. Reemplazar `<id>`, `<slug>` y placeholders.
3. Linkear desde el `TASK-*` correspondiente.

## Catálogo

| Plantilla | Archivo | Destino en proyecto |
|-----------|---------|---------------------|
| Discovery | `DISCOVERY.md` | `docs/discovery/DISCOVERY-<id>-<slug>.md` |
| Task | `TASK.md` | `docs/workflow/tasks/TASK-<id>-<slug>.md` |
| EPIC | `EPIC.md` | `docs/workflow/epics/EPIC-<id>-<slug>.md` |
| STORY | `STORY.md` | `docs/workflow/stories/STORY-<id>-<slug>.md` |
| PRD / PO brief | `PRD.md` | `docs/product/briefs/PRD-<id>-<slug>.md` |
| UX spec | `UX.md` | `docs/ux/specs/UX-<id>-<slug>.md` |
| ADR | `ADR.md` | `docs/adr/####-<decision>.md` |
| Test plan | `TEST.md` | `docs/qa/test-plans/TEST-<id>-<slug>.md` |
| SPIKE | `SPIKE.md` | `docs/spikes/SPIKE-<id>-<slug>.md` |
| Refactor plan | `REF.md` | `docs/tech-debt/refactor-plans/REF-<id>-<slug>.md` |
| DB change | `DB.md` | `docs/db/schema-changes/DB-<id>-<slug>.md` |
| Supabase change | `SUPA.md` | `docs/supabase/SUPA-<id>-<slug>.md` |
| PR body | `PR.md` | Cuerpo del Pull Request (no versionar en docs/) |
| API contracts | `API-CONTRACTS.md` | `docs/architecture/api-contracts/<slug>.md` |
| Project context | `PROJECT-CONTEXT.md` | `docs/PROJECT-CONTEXT.md` (hub opcional de estado) |
| Sprint plan | `SPRINT-PLAN.md` | `docs/workflow/sprints/SPRINT-<id>-<slug>.md` |

## Workflows (procedimientos)

Guías paso a paso para el agente; no sustituyen skills ni el SPEC.

| Workflow | Archivo | Cuándo |
|----------|---------|--------|
| Onboarding backend (FastAPI) | `workflows/onboarding-backend.md` | Proyecto greenfield Python/FastAPI |
| Onboarding backend (Node) | `workflows/onboarding-node.md` | Proyecto greenfield Node/TypeScript |
| Implementar backend (router) | `workflows/implement-backend.md` | Elige FastAPI vs Node |
| Implementar Node | `workflows/implement-node.md` | Task `ready`, stack Node |
| QA dispositivo (opt-in) | `workflows/qa-device.md` | Appium / Maestro a demanda; no es gate |

Comandos Antigravity (`/discovery`, `/prd`, …): ver `workflows/` y `docs/WORKFLOW_COMMANDS.md`. El instalador copia estos archivos a `.agents/workflows/`.

## Routing YAML

La matriz de routing declarativa permanece en el **Apéndice A** del SPEC (`docs/AI_WORKFLOW_SKILLS_SPEC.md`).
