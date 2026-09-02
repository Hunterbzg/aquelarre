# Comandos de workflow vs routing YAML — Evaluación P3

Comparación entre el modelo **mitaller-be** (comandos `/discovery`, workflows en `.agents/workflows/`) y **Aquelarre** (skills granulares + routing YAML en el SPEC).

## Resumen ejecutivo

| Aspecto | mitaller-be | Aquelarre (decisión) |
|---------|-------------|----------------------|
| Entrada al pipeline | Comandos `/onboarding`, `/discovery`, … | Skill por intención + routing YAML (Apéndice A) |
| Agentes | 4 monolitos (product, coding, orchestrator, doc-crawler) | 21 skills `aquelarre-*` |
| Procedimientos | `.agents/workflows/*.md` (7 archivos) | `templates/workflows/` + skills |
| Routing | Implícito en AGENTS.md + secuencia fija | Explícito: etiquetas → `skills_plan` |
| Artefactos | `docs/sprints/sprint-NNN/tasks/` | `docs/workflow/tasks/` (centralizado) |

**Decisión:** mantener el **routing YAML del SPEC como canónico**. Los comandos `/…` son **atajos opcionales** en Antigravity: archivos finos en `.agents/workflows/` que delegan en skills Aquelarre. No reintroducir monolitos.

## Por qué no copiar el modelo mitaller-be tal cual

1. **Pierde paridad mobile/web/backend** — un solo `coding-agent` no distingue Flutter, React, FastAPI.
2. **Secuencia rígida** — `/prd` → `/architecture` no cubre spikes, chores, refactors opt-in.
3. **4 skills vs 21** — el routing granular del SPEC ya resuelve “qué skill invocar” por `type`, `platform`, `risk`, etc.
4. **Versionado BMAD** — incompatible con trazabilidad TASK-ID + PR.

## Mapeo comando → skill Aquelarre

| Comando (Antigravity) | Skill(s) principal(es) | Gate | Workflow Aquelarre |
|----------------------|------------------------|------|-------------------|
| `/onboarding` | `aquelarre-discovery` + scaffold | — | `templates/workflows/onboarding.md` |
| `/discovery` | `aquelarre-discovery` | 0 (condicional) | `templates/workflows/discovery.md` |
| `/prd` | `aquelarre-po-product` | 1 | `templates/workflows/prd.md` |
| `/architecture` | `aquelarre-architecture-adr` (+ DB/SUPA si aplica) | 1 | `templates/workflows/architecture.md` |
| `/sprint-plan` | `aquelarre-scrum-master` | 1→2 | `templates/workflows/sprint-plan.md` |
| `/implement` | Dev skill por `platform` + `aquelarre-testing` | 2→3 | `templates/workflows/implement.md` |
| `/status` | `aquelarre-workflow-orchestration` | — | `templates/workflows/status.md` |
| (crawl docs) | `aquelarre-doc-crawler` | — | skill directo |

### `/implement` por plataforma

| `platform` | Skill dev | Workflow detallado |
|------------|-----------|-------------------|
| `backend` (Python) | `aquelarre-dev-fastapi` | `implement-backend.md` |
| `backend` (Node) | `aquelarre-dev-node` | `implement-node.md` |
| `mobile` / `tablet` | `aquelarre-dev-flutter` | skill + `aquelarre-bitrise` |
| `web` | `aquelarre-dev-react` | skill + `aquelarre-docker` |

## Routing YAML (canónico)

El orquestador (`aquelarre-workflow-orchestration`) y el **Apéndice A** del SPEC definen:

1. Clasificación del task (`type`, `surface`, `platform`, `risk`, …)
2. `skills_plan` ordenado
3. `gate_1_requirements` condicionales
4. Validación Supervisor (reglas G*)

Los comandos `/…` **no reemplazan** esta matriz: son atajos que llevan al mismo resultado (skill correcto + artefactos en rutas canónicas).

## Uso por IDE

### Cursor

- **Sin** carpeta `.agents/workflows/` por defecto.
- Invocar skills por nombre o lenguaje natural (“ejecuta discovery”, “valida Gate 1 del TASK-042”).
- Rule `workflow-gate0-task-ready.mdc` aplica Gate 0 en edición de tasks.
- Routing: skill `aquelarre-workflow-orchestration`.

### Antigravity

- El instalador copia workflows a `.agents/workflows/` (opcional, finos).
- `templates/AGENTS-antigravity.md` → copiar a `.agents/AGENTS.md` si no existe.
- El usuario puede escribir `/discovery` o equivalente; el agente lee el workflow y activa el skill mapeado.

## Frases del usuario → acción

| Usuario dice | Acción Aquelarre |
|--------------|------------------|
| “Empecemos el proyecto” | `/onboarding` o `aquelarre-discovery` |
| “¿Qué sigue?” | `aquelarre-workflow-orchestration` + `docs/project-context.md` |
| “Trabaja en la siguiente tarea” | Leer sprint plan → task `ready` → dev skill |
| “Planifiquemos el sprint” | `aquelarre-scrum-master` + `SPRINT-PLAN.md` |
| “Sin workflow, pregunta directa” | Respuesta libre; sin gates ni artefactos |

## Instalación de workflows (Antigravity)

```powershell
.\install\install.ps1 -Dest <proyecto> -Ide antigravity
# o -Ide all
```

Copia `templates/workflows/*.md` → `.agents/workflows/`.

## Referencias

- Rutas canónicas: [ARTIFACT_PATHS.md](ARTIFACT_PATHS.md)
- SPEC routing: [AI_WORKFLOW_SKILLS_SPEC.md](AI_WORKFLOW_SKILLS_SPEC.md) — Apéndice A
- Origen mitaller-be: [MITALLER_BE_INVENTORY.md](MITALLER_BE_INVENTORY.md)
