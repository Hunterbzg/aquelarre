# Inventario y análisis — `examples/mitaller-be`

> Análisis del harness **AI SDLC Factory** usado en Antigravity para el backend Mi Taller (Python + FastAPI).
> El repo de referencia contiene **solo el harness de agentes** (`.agents/`), no código de aplicación ni el microservicio de facturación/Hacienda.
>
> Versión: 1.0 · Fecha: 2026-09-01 · **Solo diagnóstico** — sin cambios aplicados.

---

## 1. Resumen ejecutivo

`examples/mitaller-be` es un harness **orientado a Antigravity** (ruta `.agents/`) con un modelo de **4 skills compuestos**, **7 workflows por comando** (`/discovery`, `/implement`, …) y un **router global** en `AGENTS.md`. Está inspirado en **BMAD + Google Agent Factory** y optimizado para backends **FastAPI + Supabase + Docker**.

| Aspecto | mitaller-be (BE) | mitaller-skills (Flutter) | Aquelarre (actual) |
|---------|------------------|---------------------------|---------------------|
| IDE objetivo | Antigravity (`.agents/`) | Cursor (`.cursor/skills/`) | Dual Cursor + Antigravity |
| Granularidad skills | 4 roles compuestos | 11 skills especializados | 20 skills `aquelarre-*` |
| Spec maestro | Disperso (AGENTS.md + resources) | `AI_WORKFLOW_SKILLS_SPEC.md` | SPEC migrado + `VISION.md` |
| Workflows explícitos | 7 archivos `.md` con pasos | Routing en orquestador + SPEC | Routing en `aquelarre-workflow-orchestration` |
| Gates | 0, 1a, 1b, 2 (DoR), 3 (DoD) | 0, 1, 2, 3 | 0, 1, 2, 3 (alineado a Flutter) |
| Contexto persistente | `docs/project-context.md` | TASK + artefactos en `docs/` | TASK + discovery + templates |
| Versionado artefactos | BMAD (`-v1.md`, `-v2.md`) | IDs estables (`TASK-123`) | Templates con `<id>` |
| Código en el snapshot | **No** (solo harness) | Skills + SPEC (limpiado) | Skills + install |

### Hallazgos principales

1. **~85% del workflow es genérico** para cualquier backend FastAPI — gates, TDD, Clean Architecture, Docker, Supabase.
2. **El acoplamiento de dominio es bajo** en este snapshot: solo ejemplos en patterns (`facturas`, `kapix`, `invoice_service`).
3. **No hay código de producto** en la carpeta — útil como referencia de *cómo trabajar*, no de *qué construir*.
4. **Fortalezas únicas vs Aquelarre**: workflows por comando, `project-context.md`, DoR con spec TDD embebida en Task, `doc-crawler`, onboarding que scaffold el proyecto Python.
5. **Debilidades vs Aquelarre**: sin dual IDE, sin skills granulares (github, bitrise, qa-automation), sin SPEC único verificable (G*), sin instalador.

| Categoría | Cantidad | Acción sugerida para Aquelarre |
|-----------|----------|--------------------------------|
| Skills (`.agents/skills/`) | 4 | Absorber patrones; no copiar tal cual (demasiado monolíticos) |
| Workflows | 7 | Evaluar portar como `templates/workflows/` o fusionar en skills |
| `AGENTS.md` (router) | 1 | Equivalente parcial a `rules/` + `aquelarre-workflow-orchestration` |
| Resources (templates + patterns) | ~18 | Migrar selectivamente a `aquelarre-dev-fastapi`, `docker`, `supabase` |
| Scripts (`doc-crawler`) | 1 | Candidato a skill/tool separado en Aquelarre |
| Código app / Hacienda | 0 en snapshot | Fuera de alcance del harness |

---

## 2. Estructura actual del folder

```
examples/mitaller-be/
└── .agents/
    ├── AGENTS.md                          ← Router global + reglas de gobernanza
    ├── workflows/                         ← 7 procedimientos paso a paso
    │   ├── onboarding.md
    │   ├── discovery.md
    │   ├── prd.md
    │   ├── architecture.md
    │   ├── sprint-plan.md
    │   ├── implement.md
    │   └── review.md
    └── skills/
        ├── orchestrator/
        │   ├── SKILL.md
        │   └── resources/
        │       ├── workflow-map.md
        │       └── project-status-template.md
        ├── product-agent/
        │   ├── SKILL.md
        │   └── resources/                 ← 10 templates + checklists
        │       ├── adr-template.md
        │       ├── api-contracts-template.md
        │       ├── data-model-template.md
        │       ├── discovery-checklist.md
        │       ├── epic-template.md
        │       ├── prd-template.md
        │       ├── quality-gates.md
        │       ├── sprint-plan-template.md
        │       ├── story-template.md
        │       └── task-template.md
        ├── coding-agent/
        │   ├── SKILL.md
        │   └── resources/                 ← 6 guías técnicas
        │       ├── code-standards.md
        │       ├── dod-checklist.md
        │       ├── docker-patterns.md
        │       ├── fastapi-patterns.md
        │       ├── supabase-patterns.md
        │       └── tdd-workflow.md
        └── doc-crawler/
            ├── SKILL.md
            ├── requirements.txt
            ├── scripts/crawl_doc.py
            └── resources/extraction-patterns.md
```

**Total:** 33 archivos · 4 skills · 7 workflows · 1 router global · 0 archivos de código `app/`.

---

## 3. Modelo de agentes

### 3.1 Router (`AGENTS.md`)

Clasifica intención del usuario en 6 categorías:

| Categoría | Destino | Equivalente Aquelarre |
|-----------|---------|------------------------|
| `PRODUCT_WORK` | `product-agent` | `discovery` + `po-product` + `architecture-adr` + `scrum-master` |
| `CODING_WORK` | `coding-agent` | `dev-fastapi` + `testing` + `docker` + `supabase` |
| `ORCHESTRATION` | `orchestrator` | `workflow-orchestration` |
| `WORKFLOW_TRIGGER` | Leer `.agents/workflows/*.md` | No existe (routing implícito en skills) |
| `DIRECT_RESPONSE` | Bypass sin gates | No documentado explícitamente |
| `DOC_CRAWLER` | `doc-crawler` | **No existe en Aquelarre** |

**Reglas globales en AGENTS.md** (aplican a categorías 1–4):

- Gates secuenciales 0 → 1a → 1b → 2 → 3
- Versionado BMAD por carpeta (`docs/discovery/`, `docs/product/`, …)
- `docs/project-context.md` como memoria de sesión obligatoria
- Human-in-the-loop en cada gate
- No code without DoR (Task con spec TDD)
- Excepciones: bugfix, infra, config, refactor directo
- Stack fijado: Python 3.11+, FastAPI, Pydantic v2, Supabase, pytest, ruff, mypy, Docker

### 3.2 Skill `orchestrator`

| Aspecto | Contenido |
|---------|-----------|
| Rol | Dashboard, siguiente paso, detección violación de gates |
| Inputs | `project-context.md`, árbol `docs/` |
| Outputs | Recomendación de workflow (`/discovery`, `/implement`, …) |
| No hace | Implementar ni generar artefactos de producto |

**Solapamiento Aquelarre:** `aquelarre-workflow-orchestration` — más formal (YAML, reglas G*, PASS/FAIL). mitaller-be es más **guiado por comandos** y escaneo de carpetas.

### 3.3 Skill `product-agent`

Combina **BA + PM + Architect** en un solo skill:

| Sub-capacidad | Gate | Artefactos |
|---------------|------|------------|
| Discovery | 0 | `discovery-notes-vN.md`, `domain-analysis-vN.md` |
| PRD | 1a | `prd-vN.md`, `domain-model-vN.md` |
| Architecture | 1b | ADR, `data-model-vN.md`, `api-contracts-vN.md` |
| Story mapping | Pre-2 | `backlog.md`, `EPIC-*.md`, `STORY-*.md` |
| Sprint planning | 2 (DoR) | `sprint-plan.md`, `TASK-*.md` |
| Gate review | Transversal | Checklist `quality-gates.md` |

**Solapamiento Aquelarre:** reparte en `discovery`, `po-product`, `architecture-adr`, `scrum-master`, `database-postgres`, `supabase`.

### 3.4 Skill `coding-agent`

Combina **Developer + QA** para backend Python:

| Sub-capacidad | Contenido |
|---------------|-----------|
| Task intake | Validar DoR (Gate 2) |
| TDD | Red → Green → Refactor obligatorio |
| Clean Architecture | Estructura `app/` documentada |
| Supabase | Repos en `infrastructure/supabase/` |
| Docker | Multi-stage, compose |
| DoD | pytest, cov ≥85%, ruff, mypy |

**Tipos de task:** Feature/Bugfix (TDD) vs Infrastructure/Configuration (verificación adaptada).

**Solapamiento Aquelarre:** `dev-fastapi`, `docker`, `supabase`, `testing` — mitaller-be es **más prescriptivo** (umbrales numéricos, estructura de carpetas fija).

### 3.5 Skill `doc-crawler`

| Aspecto | Contenido |
|---------|-----------|
| Propósito | Descargar docs externas (APIs terceros) optimizadas para LLM |
| Herramienta | `crawl_doc.py` (Jina Reader + fallback Crawl4AI) |
| Salida | `docs/discovery/external-apis/[api]-v1.md` |

**Solapamiento Aquelarre:** **ninguno** — candidato a skill nuevo (`aquelarre-doc-crawler` o sección en `discovery`).

---

## 4. Workflows (procedimientos)

Los workflows **no tienen frontmatter**; el agente debe leer el archivo cuando detecta `WORKFLOW_TRIGGER` o el orquestador recomienda el comando.

| Comando | Archivo | Agente | Gate al cerrar |
|---------|---------|--------|----------------|
| `/onboarding` | `onboarding.md` | product-agent | — (setup inicial) |
| `/discovery` | `discovery.md` | product-agent | Gate 0 |
| `/prd` | `prd.md` | product-agent | Gate 1a |
| `/architecture` | `architecture.md` | product-agent | Gate 1b |
| `/sprint-plan` | `sprint-plan.md` | product-agent | Gate 2 por Task |
| `/implement` | `implement.md` | coding-agent | Gate 3 por Task |
| `/review` | `review.md` | ambos | Sprint review |

### Valor diferencial de los workflows

- Pasos **numerados y verificables** (leer X, crear Y, ejecutar pytest).
- Enlaces explícitos a `resources/` del skill correcto.
- Estados de Task con emojis (⬜ Ready → 🔴 Red → 🟢 Green → ♻️ Refactor → ✅ Done).

**Solapamiento Aquelarre:** el SPEC + skills cubren lo mismo pero **menos procedural**; no hay comandos `/implement` ni onboarding que cree `pyproject.toml`.

---

## 5. Sistema de gates — comparación

### 5.1 mitaller-be

```
Gate 0   Discovery     → aprobación humana
Gate 1a  PRD           → aprobación humana
Gate 1b  ADR + modelo  → aprobación humana
Gate 2   DoR por Task  → checklist automático (spec TDD en Task)
Gate 3   DoD por Task  → tests + linter + aprobación humana antes de siguiente Task
```

### 5.2 Aquelarre (Flutter harness)

```
Gate 0   Task válido (clasificación)
Gate 1   Ready for Dev (PO, UX, ADR, TEST condicionales)
Gate 2   Ready for PR (evidencia tests/CI)
Gate 3   Done (merge + humano)
```

### 5.3 Mapeo conceptual

| mitaller-be | Aquelarre | Notas |
|-------------|-----------|-------|
| Gate 0 (discovery) | Discovery + Gate 0 proyecto nuevo | BE separa discovery de Task; Aquelarre usa TASK como unidad |
| Gate 1a (PRD) | Gate 1 + `po-product` | Equivalente |
| Gate 1b (ADR + API + data model) | Gate 1 + `architecture-adr` + `database-postgres` | BE exige **api-contracts** y **data-model** explícitos |
| Gate 2 (DoR) | Gate 1 (test plan + plan técnico) | BE es **más estricto**: test cases en el Task antes de codear |
| Gate 3 (DoD + humano por Task) | Gate 2 + Gate 3 | BE bloquea **siguiente Task** sin aprobación; Aquelarre bloquea merge |

---

## 6. Artefactos y convenciones de `docs/`

### 6.1 Estructura esperada (creada en onboarding)

| Ruta | Propósito | Equivalente Aquelarre `templates/` |
|------|-----------|--------------------------------------|
| `docs/project-context.md` | Estado gates, sprint activo, idioma | **No hay equivalente único** |
| `docs/discovery/` | Notas + domain analysis | `DISCOVERY.md` |
| `docs/product/` | PRD, domain model | `PRD.md` |
| `docs/architecture/adr/` | ADRs | `ADR.md` |
| `docs/architecture/data-model-vN.md` | Esquema DB detallado | Parcial en `DB.md` |
| `docs/architecture/api-contracts-vN.md` | OpenAPI/schemas | **No hay template** |
| `docs/backlog/` | Epics, stories | `EPIC.md`, `STORY.md` |
| `docs/sprints/sprint-NNN/` | Sprint plan + tasks | `TASK.md` en `docs/workflow/tasks/` |
| `docs/discovery/external-apis/` | Docs crawleadas | **No hay** |

### 6.2 Versionado BMAD vs Aquelarre

| mitaller-be | Aquelarre |
|-------------|-----------|
| `prd-v1.md`, `prd-v2.md` | `PRD-<id>-<slug>.md` estable |
| Historial por archivo nuevo | Historial por git + secciones en TASK |
| “Última versión = activa” | ID en frontmatter del TASK |

**Evaluación:** BMAD es claro para humanos en Antigravity; Aquelarre prioriza **trazabilidad TASK ↔ PR** sin proliferar `-vN`.

### 6.3 Task template (DoR) — fortaleza del BE harness

El `task-template.md` del product-agent exige secciones que Aquelarre solo sugiere en Gate 1:

- Archivos a crear/modificar (tabla)
- **Especificación TDD con código Python** en el Task
- Schemas JSON de ejemplo (input/output)
- Tipo: Feature / Infrastructure / Configuration / Bugfix
- Estados TDD con emojis en el propio Task

→ Candidato a enriquecer `templates/TASK.md` para `platform=backend`.

---

## 7. Recursos técnicos (coding-agent)

| Resource | Líneas aprox. | Genérico | Acoplamiento dominio |
|----------|---------------|----------|---------------------|
| `fastapi-patterns.md` | ~387 | ✅ Alto | Ejemplo `kapix/` como cliente externo |
| `supabase-patterns.md` | ~245 | ✅ Alto | Ejemplos RLS con “facturas” / organización |
| `docker-patterns.md` | Medio | ✅ Alto | Ninguno relevante |
| `tdd-workflow.md` | ~190 | ✅ Alto | Paths `invoice_*` como ejemplo |
| `code-standards.md` | Medio | ✅ Alto | pyproject, ruff, mypy |
| `dod-checklist.md` | Corto | ✅ Alto | Umbral cobertura 85% fijo |

**Stack prescrito:** pytest-asyncio, httpx ASGITransport, respx, pydantic-settings, Clean Architecture estricta.

**Solapamiento Aquelarre:** `aquelarre-dev-fastapi/reference.md` es **mucho más ligero** — mitaller-be aporta profundidad lista para copiar/adaptar.

---

## 8. Qué es específico vs genérico

### 8.1 Genérico (reutilizable en Aquelarre) ✅

- Router de intención y bypass `DIRECT_RESPONSE`
- Pipeline discovery → PRD → architecture → sprint → implement → review
- Quality gates con aprobación humana secuencial
- TDD Red-Green-Refactor con verificación de tests que fallan primero
- Clean Architecture / capas para FastAPI
- DoD con ruff + mypy + pytest-cov
- Docker multi-stage + compose dev
- Patrones Supabase (anon vs service role, repos)
- Sprint plan con checkboxes
- Workflow `implement.md` como checklist ejecutable
- `doc-crawler` como utilidad de discovery de APIs externas
- Onboarding que scaffold estructura `docs/` + Python base

### 8.2 Semi-genérico (adaptar al consumir) ⚠️

- Versionado BMAD (`-vN`) — choca con convención TASK-ID de Aquelarre
- Rutas `docs/sprints/sprint-NNN/tasks/` vs `docs/workflow/tasks/`
- `project-context.md` como hub — útil pero hay que alinear con orquestador Aquelarre
- Cobertura mínima 85% — Aquelarre usa matriz por `risk`
- Gates 1a/1b split — Aquelarre usa Gate 1 unificado condicional
- Comandos `/workflow` — Antigravity-specific UX

### 8.3 Específico de dominio / proyecto (no llevar al harness) ❌

- Referencias a **Kapix** (proveedor facturación electrónica / Hacienda)
- Ejemplos RLS “facturas de su organización” en supabase-patterns
- `invoice_service`, endpoints `invoices` en ejemplos TDD
- Mención explícita de integración Hacienda en doc-crawler (ejemplo Supabase/Kapix)

### 8.4 Ausente en el snapshot (no inventariar como harness)

- Código `app/`, tests, `Dockerfile`, `docker-compose.yml` del microservicio real
- `docs/business_context.md`, `technical_and_workflow_spec.md` (referenciados en workflows pero no incluidos)
- CI/CD (GitHub Actions, etc.) — Aquelarre usaría `docker` + futuro pipeline
- Rules de Cursor — solo modelo Antigravity

---

## 9. Matriz de solapamiento con Aquelarre

| Capacidad mitaller-be | Aquelarre hoy | Gap / acción |
|----------------------|---------------|--------------|
| Router intención (`AGENTS.md`) | `workflow-orchestration` + `rules/gate0` | Portar modo bypass y comandos workflow |
| Orchestrator dashboard | Parcial en orchestration | Añadir template status + `project-context` opcional |
| Discovery interactivo | `aquelarre-discovery` | BE tiene checklist más largo → fusionar en reference |
| PRD + MoSCoW | `aquelarre-po-product` | Templates similares; BE más detallado |
| ADR + data model + API contracts | `architecture-adr` + `database-postgres` | **Falta template API contracts** en Aquelarre |
| Epics / stories / backlog | `scrum-master` | Rutas distintas; contenido equivalente |
| Sprint planning | `scrum-master` | BE tiene `sprint-plan-template.md` dedicado |
| Task con DoR + TDD spec | `templates/TASK.md` | **Enriquecer** con sección TDD backend |
| Implement TDD procedural | `dev-fastapi` + `testing` | Portar `implement.md` como reference o workflow |
| FastAPI clean arch | `dev-fastapi/reference.md` | **Migrar** `fastapi-patterns.md` (limpio) |
| Supabase backend | `supabase` (orientado DB/RLS) | **Migrar** `supabase-patterns.md` a dev-fastapi o supabase |
| Docker | `docker` | Migrar `docker-patterns.md` |
| DoD checklist | `testing` Gate 2 | Migrar umbrales como defaults `risk=high` |
| Doc crawl APIs | — | **Nuevo skill** candidato |
| Onboarding scaffold Python | — | **Nuevo workflow** o extensión install |
| `/review` sprint | Parcial en scrum | Documentar ceremonia review |
| Dual IDE | ✅ Aquelarre | mitaller-be solo Antigravity |
| Bitrise / mobile | N/A en BE | Solo en Aquelarre |
| SPEC G* verificable | ✅ Aquelarre | mitaller-be no tiene reglas G1-PO-001 style |
| `install.ps1` | ✅ Aquelarre | mitaller-be sin instalador |

---

## 10. Inventario de templates (product-agent)

| Template | Uso | ¿En Aquelarre? |
|----------|-----|----------------|
| `discovery-checklist.md` | Sesión Gate 0 | Parcial en `DISCOVERY.md` |
| `prd-template.md` | Gate 1a | `PRD.md` |
| `adr-template.md` | Gate 1b | `ADR.md` |
| `data-model-template.md` | Esquema DB | `DB.md` (menos detalle) |
| `api-contracts-template.md` | Contratos REST | **Falta** |
| `epic-template.md` | Backlog | `EPIC.md` |
| `story-template.md` | Backlog | `STORY.md` |
| `task-template.md` | DoR + TDD spec | `TASK.md` (menos estricto para BE) |
| `sprint-plan-template.md` | Planificación | **Falta** |
| `quality-gates.md` | Definición gates | `AI_WORKFLOW_SKILLS_SPEC.md` |

---

## 11. Recomendaciones (siguiente fase)

Prioridad sugerida para integrar en Aquelarre **sin** duplicar el modelo monolítico de 4 skills:

| Prioridad | Acción | Estado |
|-----------|--------|--------|
| **P1** | Enriquecer `aquelarre-dev-fastapi` con guías de patterns, TDD, standards y DoD | ✅ Integrado |
| **P1** | Añadir `templates/API-CONTRACTS.md` | ✅ |
| **P1** | Extender `templates/TASK.md` con §6b y §8a (TDD backend) | ✅ |
| **P2** | Crear `aquelarre-doc-crawler` (skill + script) | ✅ |
| **P2** | Añadir `templates/PROJECT-CONTEXT.md` | ✅ |
| **P2** | Workflows en `templates/workflows/` | ✅ |
| **P2** | Enriquecer `aquelarre-docker/reference.md` | ✅ |
| **P3** | Evaluar comandos `/discovery` Antigravity vs routing YAML | ✅ `docs/WORKFLOW_COMMANDS.md` + workflows en `.agents/` |
| **P3** | Unificar rutas `docs/sprints/` vs `docs/workflow/` | ✅ `docs/ARTIFACT_PATHS.md` |

**No recomendado:**

- Reemplazar los 23 skills de Aquelarre por 4 monolitos (pierde routing granular y paridad mobile/web).
- Copiar versionado BMAD como está (confunde con TASK-ID y PR traceability).
- Incluir dominio Kapix/Hacienda en el harness genérico.

---

## 12. Referencias cruzadas

| Documento | Relación |
|-----------|----------|
| [MITALLER_SKILLS_INVENTORY.md](MITALLER_SKILLS_INVENTORY.md) | Inventario harness Flutter (mitaller-skills) |
| [VISION.md](VISION.md) | Visión Aquelarre — stack backend FastAPI + Docker |
| [AI_WORKFLOW_SKILLS_SPEC.md](AI_WORKFLOW_SKILLS_SPEC.md) | Gates y routing canónico Aquelarre |
| [ARTIFACT_PATHS.md](ARTIFACT_PATHS.md) | Rutas canónicas y migración desde mitaller-be |
| [WORKFLOW_COMMANDS.md](WORKFLOW_COMMANDS.md) | Comandos `/discovery` vs routing YAML |
| [skills/README.md](../skills/README.md) | Catálogo `aquelarre-*` actual |
| [examples/mitaller-be/README.md](../examples/mitaller-be/README.md) | Punto de entrada del snapshot BE |

---

## Apéndice A — Conteo de archivos por tipo

| Tipo | Archivos |
|------|----------|
| Skills (`SKILL.md`) | 4 |
| Workflows | 7 |
| Router global | 1 |
| Resources (templates/patterns) | 18 |
| Scripts Python | 1 |
| Config (`requirements.txt`) | 1 |
| **Total** | **33** |
