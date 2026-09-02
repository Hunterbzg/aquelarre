---
name: aquelarre-workflow-orchestration
description: Orquesta el workflow AI-Driven de Aquelarre. Usa este skill cuando haya que enrutar un TASK, decidir skills a invocar, o validar gates (Gate 0/1/2/3) con reporte PASS/FAIL y reglas G*.
---

# Orquestacion del workflow (Routing + Supervisor)

Fuente principal: `docs/AI_WORKFLOW_SKILLS_SPEC.md`.

Referencias:

- `docs/WORKFLOW_COMMANDS.md` — comandos `/discovery` (Antigravity) vs routing YAML
- `docs/ARTIFACT_PATHS.md` — rutas canónicas de artefactos (`docs/workflow/` vs legacy `docs/sprints/`)

## Objetivo

Clasificar el trabajo, construir un plan de skills ordenado y validar gates con evidencia verificable.

## Inputs

- Task en `docs/workflow/tasks/TASK-<id>-<slug>.md`.
- Etiquetas del task: `type`, `surface`, `platform`, `risk`, `user_visible`, `db_change`, `tdd`, `ci`.
- Opcional: `changed_paths` o cambios detectados en codigo/docs.

## Outputs

- `skills_plan`: cadena ordenada de skills a ejecutar.
- `gate_1_requirements`: artefactos requeridos antes de desarrollo.
- `overrides`: excepciones permitidas con justificacion.
- Reporte de validacion por gate (Supervisor): `pass` | `fail` + violaciones.

## Gates que aplica

Supervisor para Gate 0, 1, 2 y 3 segun reglas G* del SPEC.

## Routing

1. Leer el task y verificar clasificacion minima (Gate 0).
2. Aplicar matriz del SPEC (`bug` / `feature` / `chore` / `refactor` / `spike`).
3. Construir `skills_plan` respetando:
   - no code before task
   - branch antes de codear (skill github)
   - testing como gate de cierre
   - refactor solo opt-in (`type=refactor`)
4. Generar `gate_1_requirements` segun condiciones (PO / UX / ADR / DB / SUPA / TEST).
5. Incluir skills de plataforma cuando aplique:
   - `aquelarre-bitrise` si `platform` es mobile o tablet, o `ci=bitrise`
   - `aquelarre-docker` si `platform` es web o backend, o `ci=docker`
6. Registrar justificacion corta por cada decision importante.

## Comandos Antigravity (opcional)

Si el usuario invoca `/discovery`, `/implement`, etc., leer `.agents/workflows/<comando>.md` y ejecutar el skill mapeado. Tabla completa: `docs/WORKFLOW_COMMANDS.md`. El routing YAML del SPEC sigue siendo canónico.

## Rutas de artefactos

Tasks siempre en `docs/workflow/tasks/TASK-<id>-<slug>.md`. Sprints en `docs/workflow/sprints/`. No usar `docs/sprints/sprint-NNN/tasks/`. Ver `docs/ARTIFACT_PATHS.md`.

## Supervisor

Validar gates usando reglas G* del SPEC:

| Gate | Objetivo |
|------|----------|
| **0** | Task existe y tiene AC + clasificacion minima |
| **1** | Plan tecnico, test plan, artefactos condicionales (PO/UX/ADR/DB/SUPA) |
| **2** | Implementacion + evidencia verificable (tests, CI si aplica) |
| **3** | PR mergeado + aprobacion humana + trazabilidad completa |

Regla: declarar `N/A` con motivo cuando un artefacto no aplica; el silencio se interpreta como faltante.

## Formato de salida recomendado

```yaml
gate: "Gate 1 — Ready for Dev"
task_id: "TASK-042-login-screen"
result: pass
violations: []
notes:
  - "No aplica UX: feature no user-visible."
```

Si hay fallas:

```yaml
gate: "Gate 1 — Ready for Dev"
task_id: "TASK-042-login-screen"
result: fail
violations:
  - severity: blocker
    rule_id: G1-PO-001
    message: "Falta PRD/PO brief para feature user-visible."
    evidence:
      - "task.type=feature"
      - "task.user_visible=yes"
notes:
  - "Invocar aquelarre-po-product antes de pasar a ready."
```

## Skills del catalogo Aquelarre

Referencia rapida para `skills_plan` (detalle en SPEC):

`aquelarre-scrum-master` · `aquelarre-po-product` · `aquelarre-ux-mobile` · `aquelarre-ux-tablet` · `aquelarre-ux-web` · `aquelarre-architecture-adr` · `aquelarre-database-postgres` · `aquelarre-supabase` · `aquelarre-dev-flutter` · `aquelarre-dev-fastapi` · `aquelarre-dev-node` · `aquelarre-dev-react` · `aquelarre-testing` · `aquelarre-qa-automation` · `aquelarre-github` · `aquelarre-refactor` · `aquelarre-bitrise` · `aquelarre-docker` · `aquelarre-discovery` · `aquelarre-doc-crawler`
