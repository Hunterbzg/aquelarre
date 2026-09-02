# Rutas de artefactos — Aquelarre (canónico)

Guía única para proyectos consumidores. **Fuente de verdad:** esta convención + `docs/AI_WORKFLOW_SKILLS_SPEC.md`.

## Principio

- **Un artefacto por archivo**, identificado por `ID-slug` (no versionado BMAD `-vN`).
- **Tasks centralizados** en `docs/workflow/tasks/` — no anidados dentro de carpetas de sprint.
- **Sprints** son planes que **referencian** tasks por ID; el task vive en una sola ruta.

## Árbol canónico

```
docs/
├── project-context.md              # Hub opcional de estado (PROJECT-CONTEXT.md)
├── discovery/
│   ├── DISCOVERY-<id>-<slug>.md
│   └── external-apis/<api>.md      # doc-crawler
├── product/briefs/
│   └── PRD-<id>-<slug>.md
├── ux/specs/
│   └── UX-<id>-<slug>.md
├── adr/
│   └── ####-<decision>.md
├── architecture/
│   └── api-contracts/<slug>.md
├── db/schema-changes/
│   └── DB-<id>-<slug>.md
├── supabase/
│   └── SUPA-<id>-<slug>.md
├── qa/test-plans/
│   └── TEST-<id>-<slug>.md
├── workflow/
│   ├── epics/EPIC-<id>-<slug>.md
│   ├── stories/STORY-<id>-<slug>.md
│   ├── tasks/TASK-<id>-<slug>.md    # ← única ubicación de tasks
│   └── sprints/SPRINT-<id>-<slug>.md
├── spikes/SPIKE-<id>-<slug>.md
└── tech-debt/refactor-plans/REF-<id>-<slug>.md
```

## Convenciones de ID

| Tipo | Formato | Ejemplo |
|------|---------|---------|
| Task | `TASK-<número>-<slug-kebab>` | `TASK-042-login-api` |
| Story | `STORY-<número>-<slug>` | `STORY-010-auth` |
| Epic | `EPIC-<número>-<slug>` | `EPIC-001-onboarding` |
| Sprint | `SPRINT-<número>-<slug>` | `SPRINT-003-mvp-auth` |
| Discovery | `DISCOVERY-<número>-<slug>` | `DISCOVERY-001-domain` |

El **slug** es kebab-case, descriptivo, estable (no cambia si el título del task cambia ligeramente).

## Sprint vs task — modelo Aquelarre

| Concepto | Dónde vive | Relación |
|----------|------------|----------|
| Sprint plan | `docs/workflow/sprints/SPRINT-<id>-<slug>.md` | Lista tasks por ID + progreso |
| Task | `docs/workflow/tasks/TASK-<id>-<slug>.md` | AC, TDD, evidencia, gates |
| Story / Epic | `docs/workflow/stories/`, `epics/` | Agrupan tasks; linkean por ID |

**Ejemplo en sprint plan:**

```markdown
### STORY-010: Autenticación
- [ ] TASK-042: Endpoint login — `feature` — `platform=backend`
- [x] TASK-043: Migración users — `chore` — `db_change=yes`
```

El agente abre `docs/workflow/tasks/TASK-042-login-api.md` para implementar; no busca tasks bajo el sprint.

## Migración desde mitaller-be (`docs/sprints/`)

Si el proyecto viene del harness Antigravity de mitaller-be:

| Legacy (mitaller-be) | Canónico (Aquelarre) | Notas |
|----------------------|----------------------|-------|
| `docs/sprints/sprint-NNN/sprint-plan.md` | `docs/workflow/sprints/SPRINT-NNN-<slug>.md` | Renombrar ID; conservar contenido |
| `docs/sprints/sprint-NNN/tasks/TASK-NNN.md` | `docs/workflow/tasks/TASK-NNN-<slug>.md` | **Mover** el archivo; actualizar links |
| `docs/discovery/discovery-notes-v1.md` | `docs/discovery/DISCOVERY-001-<slug>.md` | Unificar; no duplicar `-vN` |
| `docs/discovery/domain-analysis-v1.md` | Sección en DISCOVERY o ADR | Opcional: fusionar en discovery |
| `docs/project-context.md` | `docs/project-context.md` | Misma ruta (minúsculas) |
| `docs/product/prd-v1.md` | `docs/product/briefs/PRD-<id>-<slug>.md` | |
| `docs/architecture/adr-*.md` | `docs/adr/####-<decision>.md` | Numeración ADR estándar |
| `docs/backlog/` | `docs/workflow/epics/` + `stories/` | Desglosar según plantillas |

### Pasos de migración (brownfield)

1. Crear carpetas Aquelarre (`install` ya las scaffold).
2. Mover cada `TASK-*.md` a `docs/workflow/tasks/` con slug en el nombre.
3. Convertir `sprint-plan.md` a `SPRINT-<id>-<slug>.md` en `docs/workflow/sprints/`.
4. Actualizar links en sprint, epics y `docs/project-context.md`.
5. Buscar referencias rotas: `rg "docs/sprints/"` en el repo.
6. **No** mantener dos copias del mismo task.

## Qué no usar

| Patrón | Motivo |
|--------|--------|
| `docs/sprints/sprint-NNN/tasks/` | Duplica tasks; rompe routing del orquestador |
| `*-v1.md`, `*-v2.md` (BMAD) | Aquelarre usa git + PR para historial; ID estable |
| Tasks sin clasificación (`platform`, `type`, `risk`) | Bloquea Gate 0 (rule workflow-gate0) |

## Referencias

- Plantillas: `templates/README.md`
- Gates y routing: `docs/AI_WORKFLOW_SKILLS_SPEC.md`
- Inventario mitaller-be: `docs/MITALLER_BE_INVENTORY.md` §10–11
