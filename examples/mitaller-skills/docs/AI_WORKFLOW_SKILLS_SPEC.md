# Workflow AI-Driven Development (Skills + Router/Supervisor)

Este documento es la **fuente de verdad** para diseñar e implementar un workflow de trabajo más **dinámico, rápido y con mayor calidad**, soportado por:

- **Skills** (roles especializados reutilizables).
- **MCPs** (herramientas operables desde los modelos, p. ej. Supabase, mobile testing).
- **Artefactos persistentes en el repo** (Markdown) para mantener contexto entre chats (*context windows*).
- **Orquestación** con patrones **Router** y **Supervisor**, usando **gates** (puntos de control).

El objetivo es que:

1) Humanos (devs/PM/UX) entiendan el flujo y sus responsabilidades.
2) Modelos (en distintos chats) puedan retomar el estado **sin depender del historial** del chat anterior.
3) La trazabilidad sea completa: *por qué* se decidió, *qué* se hizo, *cómo* se verificó.

## Índice

Los enlaces usan anclas HTML (`<a id="idx-..."></a>`) para que funcionen de forma estable en GitHub, Cursor y la mayoría de visores Markdown.

### Marco general
- [Problema que resolvemos](#idx-problema)
- [Principios de diseño (agnóstico de IDE)](#idx-principios)
- [Teoría: Skills, Router y Supervisor](#idx-teoria)
- [Artefactos del workflow (qué existe en el repo)](#idx-artefactos-workflow)
- [Convenciones oficiales (naming, rutas, estados y trazabilidad)](#idx-convenciones)
- [Gates (definición)](#idx-gates)
- [Skills que construiremos (visión general)](#idx-skills-lista)
- [Tabla de contratos por Skill (inputs, outputs, gates)](#idx-tabla-skills)
- [Skill 1: Orquestación (especificación técnica)](#idx-orquestacion)
- [Template: Task (unidad base)](#idx-template-task)
- [Routing: Matriz (reglas determinísticas)](#idx-routing-matriz)
- [Gate Validation Rules (Supervisor) — reglas verificables](#idx-gate-validation)

### Apéndices (plantillas y configuración YAML)
- [Apéndice A — Routing matrix (Router/Supervisor) en YAML](#idx-app-a)
- [Apéndice A.1 — Diccionario de heurísticas (Router) en YAML](#idx-app-a1)
- [Apéndice B — Template: PO brief / PRD](#idx-app-b)
- [Apéndice C — Template: UX spec (Flutter + Material 3)](#idx-app-c)
- [Apéndice D — Template: ADR](#idx-app-d)
- [Apéndice E — Template: Test Plan](#idx-app-e)
- [Apéndice F — Template: PR](#idx-app-f)
- [Apéndice G — Template: EPIC](#idx-app-g)
- [Apéndice H — Template: STORY](#idx-app-h)
- [Apéndice I — Template: SPIKE](#idx-app-i)
- [Apéndice J — Template: Plan de refactor (REF)](#idx-app-j)
- [Apéndice K — Template: Cambios Postgres (DB)](#idx-app-k)
- [Apéndice L — Template: Cambios Supabase (SUPA)](#idx-app-l)
- [Apéndice M — Supervisor: Gate 2 y Gate 3 en YAML](#idx-app-m)

### Cierre
- [Notas y próximos pasos](#idx-notas)

---

<a id="idx-problema"></a>
## Problema que resolvemos

### 1) Pérdida de contexto en AI-driven development
El desarrollo asistido por IA sufre cuando:

- El contexto vive en chats y se pierde al cambiar de ventana o modelo.
- Se empieza a escribir código sin una unidad de trabajo bien definida.
- No hay “evidencia” estructurada: decisiones, verificaciones, trade-offs.

### 2) Falta de trazabilidad del ciclo de desarrollo
Aunque se use Scrum (o flujos cíclicos), en AI-driven dev se necesita más rigor en:

- *Qué fase estamos* (intake → ready → dev → PR → done).
- *Qué artefactos existen* (task, PRD, UX spec, ADR, test plan).
- *Qué gates se pasaron* (con checklist y evidencia).

---

<a id="idx-principios"></a>
## Principios de diseño (agnóstico de IDE)

### 1) El repo como memoria externa
El **estado** del trabajo debe vivir en archivos del repo. Los modelos leen/escriben esos artefactos; el chat solo es el “canal” de interacción.

### 2) Separar decisión de ejecución
- **Decidir** qué roles/skills aplicar (Router) debe ser determinístico y auditable.
- **Ejecutar** pasos especializados (PO/UX/Arquitectura/Dev/DB/Supabase/Testing/GitHub) debe seguir contratos claros.

### 3) Gates (controles) en vez de burocracia
El workflow no es rígido “en todo”, sino firme en los **puntos de control**:

- Gate 0: no code before task.
- Gate 1: ready for dev.
- Gate 2: ready for PR.
- Gate 3: done.

### 4) “Full detail” sin duplicar
La bitácora detallada vive a nivel **Task**. Historias/Epics pueden existir pero deben ser **resumen + links**, no log duplicado.

---

<a id="idx-teoria"></a>
## Teoría: Skills, Router y Supervisor

### Skills (qué son en este workflow)
Un Skill es un **módulo de comportamiento** (rol) que:

- **consume** artefactos del repo
- **produce/actualiza** artefactos del repo
- **cumple un contrato** (inputs/outputs) con checklists verificables

El “poder” del workflow no viene de prompts largos, sino de **contratos repetibles**.

### Patrón Router (clasificador/enrutador)
Responsabilidad: **clasificar** un Task y decidir qué skills aplicar.

- Input: texto del task + señales del prompt + (opcional) paths cambiados.
- Output: etiquetas (type/surface/risk/…) + plan de skills + artefactos requeridos.
- Requisito: debe producir **justificación** (“evidence”) para depurar decisiones.

### Patrón Supervisor (gobernanza/validación)
Responsabilidad: **hacer cumplir gates** y exigir evidencia.

- Verifica que existan artefactos mínimos antes de avanzar.
- Detecta faltantes (AC, test plan, ADR) y bloquea el avance si es necesario.
- Mantiene trazabilidad de estado: `status=intake|ready|in_progress|…`.

> Importante: el Supervisor no debe convertirse en un “mega-skill” que hace todo.
> Su trabajo es gobernar el proceso, no reemplazar a los especialistas.

---

<a id="idx-artefactos-workflow"></a>
## Artefactos del workflow (qué existe en el repo)

<a id="idx-convenciones"></a>
## Convenciones oficiales (naming, rutas, estados y trazabilidad)

Esta sección define convenciones **cerradas** (enumeraciones y formatos) para evitar variantes (“inprogress”, “in_progress”, “progress”, etc.) y para que Router/Supervisor/Scrum Master produzcan artefactos consistentemente en cualquier IDE o chat.

### 1) IDs (formatos)

**Regla**: el ID debe ser estable, único y usado en nombres de archivo, branch, PR, commits y links internos.

- **Tasks**: `TASK-<n>` (ej. `TASK-123`)
- **PRD / PO brief**: `PRD-<n>`
- **UX specs**: `UX-<n>`
- **Test plans**: `TEST-<n>`
- **Stories**: `STORY-<n>` (si se usan)
- **Epics**: `EPIC-<n>` (si se usan)
- **Spikes**: `SPIKE-<n>`
- **Planes de refactor**: `REF-<n>`
- **DB (documento de cambio)**: `DB-<n>`
- **Supabase (documento de cambio)**: `SUPA-<n>`
- **ADRs**: `ADR ####` (4 dígitos, incremental; ej. `ADR 0007`)

> Nota: los números pueden provenir de una secuencia simple en el repo (por ejemplo, el siguiente número disponible) o de un tracker externo. Lo importante es que el formato sea constante.

### 2) Slugs (normalización)

**Regla**: slugs en `kebab-case`, sin acentos, cortos y específicos (3–7 palabras máximo).

Ejemplos:
- `TASK-123-fix-appbar-contrast`
- `PRD-45-inventory-photo-flow`
- `UX-12-onboarding-copy-update`

### 3) Rutas canónicas (source of truth)

Estas rutas son la “API” del workflow. Si se cambian, debe registrarse en un ADR o en una sección de migración de workflow.

- **Task (unidad base)**: `docs/workflow/tasks/TASK-<id>-<slug>.md`
- **Producto (PRD/brief)**: `docs/product/briefs/PRD-<id>-<slug>.md`
- **UX spec**: `docs/ux/specs/UX-<id>-<slug>.md`
- **Reglas UX estables**: `docs/ux/rules/flutter-ux-rules.md`
- **ADRs**: `docs/adr/####-<decision>.md`
- **DB changes**: `docs/db/schema-changes/DB-<id>-<slug>.md` (si se usa)
- **Supabase changes**: `docs/supabase/SUPA-<id>-<slug>.md` (si se usa)
- **Test plans (grandes)**: `docs/qa/test-plans/TEST-<id>-<slug>.md`
- **Épica**: `docs/workflow/epics/EPIC-<id>-<slug>.md`
- **Historia (resumen)**: `docs/workflow/stories/STORY-<id>-<slug>.md`
- **Spike**: `docs/spikes/SPIKE-<id>-<slug>.md`
- **Plan de refactor**: `docs/tech-debt/refactor-plans/REF-<id>-<slug>.md`

**Regla de oro**: el `TASK-*` debe contener links a todos los artefactos relacionados (PRD/UX/ADR/TEST/DB/Supabase/EPIC/STORY/SPIKE/REF cuando apliquen).

### 4) Estados oficiales (enumeraciones)

#### 4.1) Estado de Task
`status` en el frontmatter de Task debe ser uno de:

- `intake` (existe, pero aún falta info para empezar)
- `ready` (Gate 1 cumplido)
- `in_progress` (implementación activa)
- `in_review` (PR abierto / en revisión)
- `blocked` (bloqueado por dependencia/gate)
- `done` (mergeado y cerrado)
- `cancelled` (se descarta; debe explicar por qué)

#### 4.2) Estado de PRD / UX / TEST
Estos artefactos pueden usar estados simples, cerrados:

- **PRD**: `draft | approved | superseded`
- **UX**: `draft | approved | superseded`
- **TEST**: `draft | executed | automated`
- **ADR (Status)**: `Proposed | Accepted | Rejected | Deprecated | Superseded by ADR ####`

### 5) Branching y trazabilidad GitHub (trunk-based)

Default recomendado: **trunk-based** con branches cortas por Task y `main` siempre shippable.

- **Branch name**: `task/TASK-<id>-<slug>` (ej. `task/TASK-123-fix-appbar-contrast`)
- **PR title**: incluir `TASK-<id>` al inicio (ej. `TASK-123: Fix AppBar contrast`)
- **Commits**: idealmente referenciar `TASK-<id>` (ej. `TASK-123: ...`)

### 6) Reglas de “source of truth” (para evitar duplicación)

- **Task**: bitácora operativa (sección 7 “Implementación”) + evidencia (sección 9).
- **PRD/UX**: especificación/decisiones de producto y UI; no deben llevar el log diario.
- **ADR**: por qué se tomó una decisión; no se usa como log de ejecución.
- **Test plan**: qué se prueba y evidencia; no reemplaza la evidencia final del Task.

### 7) Checklist mínimo de trazabilidad (para Gate 2/3)

Antes de cerrar un Task como `done`, debe existir:
- Branch y PR link en el Task.
- Evidencia de tests (comandos y/o link CI).
- Links a PRD/UX/ADR/DB/Supabase/TEST cuando apliquen (o `N/A` explícito).

### 8) Linking rules (reglas de enlace obligatorias)

Estas reglas convierten los artefactos en un “grafo” navegable. El objetivo es que cualquier humano o modelo pueda reconstruir el contexto desde **cualquier nodo**.

#### 8.1) Reglas mínimas (siempre)
- **Task → PR**: todo Task que cambie código debe tener link a PR (cuando exista).
- **PR → Task**: todo PR debe referenciar `TASK-<id>` en el título o en el cuerpo (idealmente ambos).
- **Commits → Task**: commits en la branch deberían incluir `TASK-<id>` en el mensaje.
- **Task → Evidencia**: el Task debe registrar evidencia de verificación (tests/lint/format) o link a CI.

#### 8.2) Reglas por tipo de artefacto (condicionales)
- **Task ↔ PRD**:
  - Si `type=feature` y `user_visible=yes`, el Task debe linkear a un `PRD-*` (o contener sección PO brief equivalente).
  - Un PRD debe linkear a Epic/Stories/Tasks (al menos al conjunto principal de Tasks).
- **Task ↔ UX**:
  - Si `surface` incluye `ui` y `user_visible=yes`, el Task debe linkear a `UX-*` (o contener sección UX equivalente).
  - Un UX spec debe linkear a PRD y Tasks relevantes.
- **Task ↔ ADR**:
  - Si existe decisión arquitectónica/seguridad/DB irreversible, el Task debe linkear al/los `ADR ####`.
  - Un ADR debe linkear a los Tasks que lo motivan (y/o PRD/UX si aplica).
- **Task ↔ TEST**:
  - Si existe `TEST-*` como documento separado, el Task debe linkearlo.
  - El TEST debe linkear a Tasks y PR (cuando exista).
- **Task ↔ DB/Supabase**:
  - Si hay cambios DB/Supabase documentados en `DB-*` o `SUPA-*`, el Task debe linkearlos.

#### 8.3) Regla de no-duplicación
Los links reemplazan duplicación de contenido:
- El Task referencia PRD/UX/ADR/TEST/DB/SUPA y solo guarda el log operativo/evidencia.
- PRD/UX/ADR/TEST guardan especificación/decisión/plan; no llevan log diario.

### Artefacto base: Task (unidad mínima)
La unidad base es **Task**. Idealmente:

- **1 Task ≈ 1 PR** (si crece, se divide).
- Contiene el log operativo completo y la evidencia de verificación.

Propuesta de ubicación:

- `docs/workflow/tasks/TASK-<id>-<slug>.md`

### Artefactos “adjuntos” (condicionales)
Dependiendo del routing, un Task puede requerir:

- `docs/product/briefs/PRD-<id>.md` (PO)
- `docs/ux/specs/UX-<id>.md` y/o `docs/ux/rules/flutter-ux-rules.md` (UX)
- `docs/adr/####-<decision>.md` (Arquitectura / decisiones)
- `docs/db/schema-changes/DB-<id>.md` (DB/Postgres)
- `docs/supabase/SUPA-<id>.md` (Supabase)
- `docs/qa/test-plans/TEST-<id>.md` (Testing, cuando sea grande)
- `docs/workflow/epics/EPIC-<id>-<slug>.md` (Scrum Master)
- `docs/workflow/stories/STORY-<id>-<slug>.md` (Scrum Master)
- `docs/spikes/SPIKE-<id>-<slug>.md` (spike / investigación)
- `docs/tech-debt/refactor-plans/REF-<id>-<slug>.md` (Refactor)

---

<a id="idx-gates"></a>
## Gates (definición)

### Gate 0 — Intake / “No code before task”
Requiere: Task creado con problema/objetivo y AC (aunque sean provisionales).

### Gate 1 — Ready for Dev
Requiere (según routing): PRD/UX/ADR/Test plan listo y linkeado desde el Task.

### Gate 2 — Ready for PR
Requiere: implementación completa + evidencia de pruebas/lint/format + artefactos actualizados.

### Gate 3 — Done / Merged
Requiere: PR mergeado + post-checks + estado final documentado en Task.

---

<a id="idx-skills-lista"></a>
## Skills que construiremos (visión general)

1) **Orquestación (Router + Supervisor)**: decide y gobierna gates/artefactos.
2) **PO (Product)**: valor, alcance, AC orientados a usuario/negocio.
3) **UX (Flutter/M3)**: reglas UX del proyecto + specs por UI change.
4) **Arquitectura**: estructura, boundaries, ADRs y decisiones.
5) **Scrum Master**: epics/stories/tasks; divide trabajo; mantiene board/estado.
6) **Desarrollo Flutter**: implementación (TDD default, opcional off) + registro en Task.
7) **Database (Postgres)**: cambios DB, performance, migraciones/rollback.
8) **Supabase**: auth/RLS/storage/migraciones; uso de MCP cuando aplique.
9) **Testing (Integración/E2E + tests de arquitectura)**: estrategia, ejecución, evidencia.
10) **GitHub**: branching (trunk-based recomendado), commits, PR, convenciones.
11) **Refactor (opt-in)**: análisis y plan de deuda técnica; coordinación con Arquitectura/Scrum.

---

<a id="idx-tabla-skills"></a>
## Tabla de contratos por Skill (inputs, outputs, gates)

Referencia única para humanos y modelos: qué consume cada skill, qué produce/actualiza y en qué gates interviene habitualmente.

| Skill | Inputs típicos | Outputs / artefactos que toca | Gates donde actúa |
|------|----------------|--------------------------------|-------------------|
| **Orquestación (Router)** | Texto del Task/prompt; `changed_paths` (opcional); Apéndice A + A.1 | Etiquetas; `skills_plan`; `gate_1_requirements`; evidencia de clasificación | **0→1** (enruta); no sustituye validación del Supervisor |
| **Orquestación (Supervisor)** | Task; reglas “Gate Validation”; routing output | Reporte PASS/FAIL por gate; lista de violaciones | **0, 1, 2, 3** |
| **PO** | Stakeholders/valor; PRD existente o borrador; Task linkeado | `PRD-*` o sección PO en Task; AC de producto | **1** (artefactos); actualiza Task |
| **UX** | PRD/Task; reglas M3 del repo | `UX-*`; actualización opcional de `docs/ux/rules/` | **1** (spec); soporte **2** (evidencia visual si aplica) |
| **Arquitectura** | Task; código/módulos afectados; riesgo/DB/auth | `docs/adr/`; notas de arquitectura en Task; overview si aplica | **1** (ADR/decisiones); **2** (si cambia diseño durante implementación) |
| **Scrum Master** | Epics/stories/Tasks; capacidad y dependencias | `EPIC-*`, `STORY-*`; creación/división de `TASK-*`; board opcional | **0** (crear Task); **1** (desglose); seguimiento **2–3** |
| **Dev Flutter** | Task en `ready`; branch; specs linkeadas | Código; log en Task secciones 6–7; tests si TDD | **2** (implementación + evidencia hacia PR) |
| **Database** | Task; esquema/cambios Postgres; performance | `DB-*` (o sección DB en Task); alineado migraciones | **1** (plan); **2** (evidencia); **3** post-migración |
| **Supabase** | Task; auth/RLS/storage; MCP (en implementación) | `SUPA-*` (o sección); políticas pasos reproducibles | **1** (diseño); **2** (verificación); **3** |
| **Testing** | Task; test plan; código tocado | Evidencia en Task §9; `TEST-*` si es grande; arch-tests evidencia | **2** (principalmente); apoyo **1** (plan); **3** |
| **GitHub** | Task; convenciones trunk-based | Branch `task/...`; PR; commits con `TASK-<id>` | **2** (branch/PR); **3** (merge) |
| **Refactor (opt-in)** | Código/módulo; Task o REF; Arquitectura si aplica | `REF-*` o plan en Task; backlog técnico | **1** (plan); **2** (ejecución + regresión) |

---

<a id="idx-orquestacion"></a>
## Skill 1: Orquestación (especificación técnica)

### Objetivo
Convertir una solicitud (o un Task) en:

- etiquetas consistentes: `type`, `surface`, `risk`, `db_change`, `user_visible`, `tdd`
- un **plan de skills** (cadena) y **artefactos requeridos** para Gate 1
- evidencia (“por qué clasifiqué esto así”)

### Best practice: “Orquestación por reglas + plantillas”
Dentro de Cursor se puede reforzar con Rules y plantillas, pero el diseño debe ser portable:

- Router/Supervisor definidos en este documento + artefactos en repo
- adapters por IDE (Cursor, otros agentes, scripts CI)

### Matriz de routing (resumen)
La matriz completa vive en la sección “Routing” (ver más abajo), pero las reglas globales son:

- **No code before task**
- **Branch antes de codear** (GitHub skill)
- **Test plan mínimo siempre**
- UX/PO/ADR se exigen por condición (surface/risk/user_visible/db_change)

---

<a id="idx-template-task"></a>
## Template: Task (unidad base)

> Convención: `docs/workflow/tasks/TASK-<id>-<slug>.md`

```markdown
---
id: TASK-<id>
title: <título corto y específico>
type: bug | feature | chore | refactor | spike
surface: ui | domain | data | db | auth | infra | ci | docs
risk: low | medium | high
size: xs | s | m | l | xl
status: intake | ready | in_progress | in_review | blocked | done | cancelled
owner: <persona/rol>
created_at: <YYYY-MM-DD>
updated_at: <YYYY-MM-DD>
parent:
  epic: EPIC-<id> | null
  story: STORY-<id> | null
links:
  branch: <branch-name> | null
  pr: <url> | null
  commits: []
  designs: []
  adr: []
  supabase: []
---

## 1) Resumen
- **Problema**: ...
- **Objetivo**: ...
- **No-alcance**: ...

## 2) Contexto
- **Antecedentes**: ...
- **Stakeholders** (si aplica): ...
- **Estado actual**: ... (con referencias)

## 3) Definición de éxito
### Criterios de aceptación (AC)
- [ ] AC1: ...
- [ ] AC2: ...

### Definition of Done (DoD)
- [ ] Código formateado y lint OK
- [ ] Tests requeridos ejecutados y pasando
- [ ] Documentación/artefactos actualizados (links abajo)
- [ ] PR revisado y mergeado (si aplica)

## 4) Clasificación (para Router)
- **Tipo**: `<type>`
- **Superficie**: `<surface>` (puede ser múltiple)
- **Riesgo**: `<risk>`
- **Requiere PO**: sí/no
- **Requiere UX**: sí/no
- **Requiere ADR**: sí/no
- **TDD**: on/off (default: on)

## 5) Artefactos requeridos por workflow (gates)
### Gate 0 — Intake
- [ ] Task completo hasta sección 4
- [ ] AC definidos

### Gate 1 — Ready for Dev (condicional)
- [ ] PO brief/PRD link: `...` o `N/A`
- [ ] UX spec link: `...` o `N/A`
- [ ] ADR link(s): `...` o `N/A`
- [ ] Test plan definido (sección 8 o link)

### Gate 2 — Ready for PR
- [ ] Implementación completada (sección 7)
- [ ] Evidencia de tests (sección 9)
- [ ] Artefactos actualizados y linkeados

### Gate 3 — Done
- [ ] PR mergeado y link agregado
- [ ] Post-checks completados (sección 10)

## 6) Plan técnico (antes de codear)
- **Approach**: ...
- **Cambios esperados**: ...
- **Riesgos técnicos**: ...
- **Rollback plan** (si aplica): ...

## 7) Implementación (registro operativo)
### Cambios realizados
- <YYYY-MM-DD> - ...

### Notas / Decisiones
- ...

## 8) Test plan (antes)
- Unit:
- Widget:
- Integration/E2E (si aplica):
- Arquitectura (si aplica):

## 9) Evidencia de verificación (después)
- **Comandos ejecutados**:
  - `...`
- **Resultado**: PASS/FAIL + link a CI si existe

## 10) Release / Post-checks (si aplica)
- Migraciones:
- Flags:
- Notas de release:

## 11) Trazabilidad
- **Branch**: ...
- **PR**: ...
- **Artefactos relacionados**: PO/UX/ADR/DB/Supabase/Testing
```

---

<a id="idx-routing-matriz"></a>
## Routing: Matriz (reglas determinísticas)

Esta sección aterriza el comportamiento del Router/Supervisor: con las etiquetas del Task, el sistema debe devolver:

- Un **routing plan** (cadena de skills).
- Un **Gate 1 checklist** (artefactos requeridos para poder empezar implementación).
- **Overrides** (justificación para saltos como `TDD off` o para omitir PO/UX/ADR cuando aplique).

### Entradas del Router (etiquetas del Task)
- `type`: `bug | feature | chore | refactor | spike`
- `surface` (multi): `ui | domain | data | db | auth | infra | ci | docs`
- `risk`: `low | medium | high`
- `user_visible`: `yes | no`
- `db_change`: `none | query | schema | rls_policy | storage`
- `tdd`: `on | off` (default `on`)

### Reglas globales (siempre aplican)
- R0 — **No code before Task**: si no existe `TASK-*` o está incompleto ⇒ invocar **Scrum Master** para crear/llenar el Task (Gate 0).
- R1 — **Branch antes de codear**: **GitHub** crea la branch justo antes de cambiar código (no antes de specs/documentos).
- R2 — **Testing como gate/cierre**: el skill de **Testing** ejecuta/verifica lo que el Task exige; los “tests de arquitectura” pertenecen a Testing (no a Arquitectura).
- R3 — **Opt-in refactor**: el skill **Refactor** se invoca solo si `type=refactor` (o si `technical_debt=true` en el Task).
- R4 — **UX/PO/ADR por condición**: no se invocan “siempre”; se invocan si las etiquetas/riesgo lo ameritan.

### Salida estándar del Router por Task
- **Routing plan**: lista ordenada de skills a invocar, respetando la regla “antes de codear” y “antes del PR”.
- **Gate 1 checklist**: lista de artefactos requeridos.
- **Overrides**: justificación y supuestos.

### Convención de cadena (para compactar la matriz)
`ScrumMaster -> (PO?) -> (UX?) -> (Arquitectura?) -> GitHub(branch) -> Dev -> Testing -> GitHub(PR)`

### Matriz principal (condición → cadena de skills → Gate 1 artefactos)

#### A) BUG

| Caso | Condición | Routing plan | Gate 1: artefactos requeridos |
|---|---|---|---|
| A1 | `type=bug` AND NO `ui` AND `db_change=none` AND `risk=low` | `ScrumMaster -> GitHub -> Dev -> Testing -> GitHub(PR)` | AC definidos (o “Definition of Fixed”), evidencia/steps si aplica, y **Test plan mínimo** (qué cubre la regresión). |
| A2 | `type=bug` AND (incluye `ui` OR `user_visible=yes`) AND `db_change=none` | `ScrumMaster -> (UX) -> GitHub -> Dev -> Testing -> GitHub(PR)` | Evidencia UX: spec/checklist UI o sección UX en el Task; reproducibilidad; **Test plan widget**. |
| A3 | `type=bug` AND (incluye `auth` OR `db_change in {schema, rls_policy, storage}` OR `risk=high`) | `ScrumMaster -> Arquitectura -> (Database?/Supabase) -> GitHub -> Dev -> Testing -> GitHub(PR)` | Impacto + rollback, ADR si aplica (seguridad/estructural) y **Test plan reforzado** (mínimo unit/integration; E2E si flujo crítico). |

#### B) FEATURE

| Caso | Condición | Routing plan | Gate 1: artefactos requeridos |
|---|---|---|---|
| B1 | `type=feature` AND `user_visible=yes` | `ScrumMaster -> PO -> (UX) -> (Arquitectura?) -> GitHub -> Dev -> Testing -> GitHub(PR)` | PO brief/PRD, UX spec (flujo/estados/validaciones) y **Test plan**. Arquitectura obligatoria si `db_change!=none` o hay decisiones estructurales. |
| B2 | `type=feature` AND `user_visible=no` | `ScrumMaster -> PO(light) -> (Arquitectura?) -> GitHub -> Dev -> Testing -> GitHub(PR)` | AC + plan técnico; PO puede ser corto. UX normalmente `N/A` salvo UI indirecta. |
| B3 | `type=feature` AND `db_change!=none` | `ScrumMaster -> (PO/UX según user_visible) -> Arquitectura -> (Database?/Supabase) -> GitHub -> Dev -> Testing -> GitHub(PR)` | ADR/decisiones con rollback, artefactos DB/Supabase linkeados y **Test plan** (incluye offline/online si aplica). |

#### C) CHORE

| Caso | Condición | Routing plan | Gate 1: artefactos requeridos |
|---|---|---|---|
| C1 | `type=chore` AND `ci/infra` AND `risk=low` | `ScrumMaster -> GitHub -> (Testing si afecta pipeline) -> GitHub(PR)` | Objetivo verificable y evidencia esperada (CI/link). |
| C2 | `type=chore` AND `ui` (ej. theming M3) | `ScrumMaster -> UX -> GitHub -> Dev -> Testing(widget) -> GitHub(PR)` | Checklist UX/M3 o spec actualizado y evidencias visuales esperadas (estados relevantes). |
| C3 | `type=chore` AND `docs` (sin cambio runtime) | `ScrumMaster -> GitHub -> GitHub(PR)` | Resumen + links; Testing `N/A`. |

#### D) REFACTOR (opt-in)

| Caso | Condición | Routing plan | Gate 1: artefactos requeridos |
|---|---|---|---|
| D1 | `type=refactor` | `Refactor -> Arquitectura -> GitHub -> Dev -> Testing(arquitectura+regresión) -> GitHub(PR)` | Plan de refactor y “NO funcional”: qué no debe cambiar; ADR si toca boundaries/decisiones; **Test plan reforzado**. |
| D2 | `type=refactor` AND `risk=high` | `Refactor -> Arquitectura -> GitHub -> Dev -> Testing -> GitHub(PR)` | Estrategia de seguridad (feature flags/strangler si existe) y rollback plan. |

#### E) SPIKE

| Caso | Condición | Routing plan | Gate 1: artefactos requeridos |
|---|---|---|---|
| E1 | `type=spike` | `ScrumMaster -> (PO?) -> (Arquitectura?) -> (GitHub opcional) -> Testing opcional -> (GitHub opcional)` | Preguntas a responder + criterio de salida; entregable final en docs (hallazgos/decisión). |

### Invocación DB y Supabase (reglas auxiliares)
- Si `db_change in {schema, query, storage}` ⇒ invocar **Database** (Postgres) para cambios DB.
- Si `db_change in {rls_policy}` OR `surface` incluye `auth` ⇒ invocar **Supabase**.
- Si hay combinaciones (ej. `schema + rls_policy`) ⇒ **Supabase** principal y **Database** como apoyo si aplica.

### Recomendación de branch/flow
El default operativo es **trunk-based** con branches cortas por Task; el “Gitflow” puede usarse como referencia histórica, pero el workflow debe mantener `main` estable y shippable.

---

<a id="idx-gate-validation"></a>
## Gate Validation Rules (Supervisor) — reglas verificables

Esta sección define reglas **objetivas** para que el Supervisor pueda decidir si un Task puede pasar de:

- Gate 0 → Gate 1 → Gate 2 → Gate 3

El objetivo es que estas reglas sean:

- **Portables** (aplican en Cursor u otro IDE).
- **Verificables** (pueden validarse por un modelo, un script, o CI).
- **Condicionales** (dependen de `type/surface/risk/user_visible/db_change/tdd`).

### 1) Conceptos

#### 1.1) Severidad de regla
- **blocker**: no se puede avanzar de gate.
- **warning**: se puede avanzar, pero se deja nota explícita (deuda/risgo aceptado).
- **info**: recomendación (no afecta el gate).

#### 1.2) Formato de salida del Supervisor (recomendado)
Para cada gate, el Supervisor debe producir un reporte mínimo:

```yaml
gate: "Gate 1 — Ready for Dev"
result: pass | fail
violations:
  - severity: blocker | warning | info
    rule_id: G1-PO-001
    message: "Falta PRD link para feature user-visible."
    evidence: ["task.frontmatter.type=feature", "task.user_visible=yes"]
notes:
  - "Se marcó TDD=off con justificación X."
```

> Nota: esto es un **marco teórico** para estandarizar la validación. No es la implementación final del skill.

### 2) Reglas por Gate

#### Gate 0 — Intake (“No code before task”)
**Objetivo**: asegurar que existe una unidad de trabajo trazable antes de cualquier cambio.

Reglas (mínimas):
- **G0-CORE-001 (blocker)**: existe archivo `TASK-*` y su frontmatter incluye: `id`, `title`, `type`, `surface`, `risk`, `status`, `created_at`, `updated_at`.
- **G0-CORE-002 (blocker)**: el Task tiene secciones completas de **Problema**, **Objetivo**, **No-alcance**.
- **G0-AC-001 (blocker)**: existe al menos 1 criterio de aceptación (AC).
- **G0-TDD-001 (info)**: si `tdd=off`, existe justificación explícita (en Task o reporte del Supervisor).

Reglas condicionales:
- **G0-BUG-001 (warning)**: si `type=bug`, incluir pasos de reproducción + expected/actual (o declarar “N/A” con motivo).
- **G0-RISK-001 (warning)**: si `risk=high`, incluir “impacto” y “rollback plan” preliminar (aunque sea un borrador).

Salida esperada:
- Si Gate 0 falla, el routing plan debe detenerse antes de GitHub/Dev y solicitar completar el Task.

#### Gate 1 — Ready for Dev
**Objetivo**: asegurar claridad suficiente para iniciar implementación sin inventar requisitos.

Reglas (mínimas):
- **G1-PLAN-001 (blocker)**: existe “Plan técnico” (Approach + cambios esperados + riesgos).
- **G1-TEST-001 (blocker)**: existe “Test plan (antes)” (mínimo unit/widget/integration N/A explícitos).
- **G1-LINK-001 (blocker)**: el Task tiene links canónicos en “Trazabilidad” (branch puede ser `null` si aún no se creó; PR puede ser `null`).

Reglas de PO (condicional):
- **G1-PO-001 (blocker)**: si `type=feature` AND `user_visible=yes`, el Task linkea a `PRD-*` **o** contiene sección PO brief equivalente.
- **G1-PO-002 (warning)**: si `type=feature` AND `risk in {medium, high}`, PO debe incluir métricas de éxito o “cómo sabremos que funcionó”.

Reglas de UX (condicional):
- **G1-UX-001 (blocker)**: si `surface` incluye `ui` AND `user_visible=yes`, el Task linkea `UX-*` **o** contiene dentro del Task:
  - Estados (loading/empty/error/success)
  - Interacciones
  - Accesibilidad (a11y) mínima

Reglas de Arquitectura/ADR (condicional):
- **G1-ADR-001 (blocker)**: si `db_change in {schema, rls_policy}` OR `surface` incluye `auth`, existe `ADR ####` linkeado y contiene rollback/mitigaciones.
- **G1-ADR-002 (warning)**: si `type=refactor` AND `risk=high`, se requiere ADR o sección explícita de “boundaries afectados” y trade-offs.

Reglas DB/Supabase (condicional):
- **G1-DB-001 (blocker)**: si `db_change=schema`, definir impacto + plan de migración/rollback (aunque sea en Task si no existe `DB-*` aún).
- **G1-SUPA-001 (blocker)**: si `db_change=rls_policy` o `surface` incluye `auth`, definir roles/permisos esperados y evidencia a producir (queries, policies, pruebas).

#### Gate 2 — Ready for PR
**Objetivo**: asegurar calidad verificable antes de abrir/solicitar merge.

Reglas (mínimas):
- **G2-IMPL-001 (blocker)**: sección “Implementación (registro operativo)” actualizada con cambios y decisiones relevantes.
- **G2-EVID-001 (blocker)**: sección “Evidencia de verificación (después)” incluye:
  - comandos ejecutados **o** link a CI
  - resultado PASS/FAIL (no puede quedar ambiguo)
- **G2-LINK-001 (blocker)**: si ya existe PR, el Task lo linkea; si no existe aún, debe existir branch linkeada.

Reglas de linking (condicional):
- **G2-LINK-002 (warning)**: commits deberían incluir `TASK-<id>`; si no, justificar (squash/rebase, etc.).
- **G2-ART-001 (warning)**: si se generaron PRD/UX/ADR/TEST separados, todos deben estar linkeados desde el Task (o declarar `N/A`).

Reglas Testing (condicional):
- **G2-TEST-002 (warning)**: si `risk=high`, se recomienda evidencia adicional (integration/E2E o explicación del porqué no).
- **G2-ARCHTEST-001 (warning)**: si `type=refactor` o cambió estructura, incluir evidencia de “tests de arquitectura” (o declarar `N/A` y por qué).

#### Gate 3 — Done / Merged
**Objetivo**: cerrar el ciclo con trazabilidad completa y listo para retomar contexto en otro chat.

Reglas (mínimas):
- **G3-PR-001 (blocker)**: PR mergeado y link en Task.
- **G3-STATUS-001 (blocker)**: `status=done` y “updated_at” actualizado.
- **G3-POST-001 (warning)**: post-checks completados o `N/A` explícito (migraciones/flags/release notes).

### 3) Reglas de “N/A explícito”
Para evitar ambigüedad y permitir validación por máquina:

- Si algo no aplica (PO/UX/ADR/TEST/E2E/DB), debe declararse explícitamente como `N/A` con motivo.
- “Silencio” se interpreta como **faltante** (y puede disparar `blocker` según la regla).

---

<a id="idx-app-a"></a>
## Apéndice A — Routing matrix (Router/Supervisor) en YAML

Este YAML define el **enrutamiento declarativo** (reglas determinísticas) que traduce etiquetas del Task en:

- `skills_plan` (cadena ordenada de skills),
- `gate_1_requirements` (artefactos requeridos para empezar implementación),
- `notes/overrides` (justificación y excepciones permitidas).

El diccionario de heurísticas (Apéndice A.1) se encarga de **inferir** etiquetas desde texto/paths; este apéndice se encarga de **decidir** el plan de trabajo una vez que las etiquetas existen.

> Objetivo: portabilidad (no depende de Cursor) y facilidad de convertirlo luego en un skill o validador CI.

```yaml
version: 1
name: workflow-routing-matrix
language: es

inputs:
  # Etiquetas del Task (provenientes del Task frontmatter o inferidas por heurísticas)
  type: [bug, feature, chore, refactor, spike]
  surface: [ui, domain, data, db, auth, infra, ci, docs]   # multi
  risk: [low, medium, high]
  user_visible: [yes, no]
  db_change: [none, query, schema, rls_policy, storage]
  tdd: [on, off]

outputs:
  skills_plan: []           # lista ordenada
  gate_1_requirements: []   # lista estructurada de requisitos para Gate 1
  overrides_allowed: []     # lista de overrides permitidos (con justificación)
  notes: []                 # recomendaciones / warnings

artifacts_catalog:
  # Nota: estos "artifacts" pueden ser documentos separados o secciones equivalentes dentro del TASK.
  task_ac:
    description: "Task tiene AC (o Definition of Fixed)."
    satisfies: ["Gate 0", "Gate 1"]
    validate:
      mode: task_section
      hint: "TASK: sección 3 (AC)"
  task_plan_tecnico:
    description: "Task tiene Plan técnico (sección 6): approach + cambios esperados + riesgos + rollback si aplica."
    satisfies: ["Gate 1"]
    validate:
      mode: task_section
      hint: "TASK: sección 6"
  task_test_plan:
    description: "Task tiene Test plan (sección 8) con N/A explícitos."
    satisfies: ["Gate 1"]
    validate:
      mode: task_section
      hint: "TASK: sección 8"
  task_bug_repro:
    description: "Bug: pasos de reproducción + expected/actual (o N/A con motivo)."
    satisfies: ["Gate 0", "Gate 1"]
    validate:
      mode: task_section
      hint: "TASK: incluir pasos de reproducción + expected/actual (o N/A con motivo)"
  task_rollback:
    description: "Rollback plan explícito (obligatorio en risk high y/o cambios DB/auth)."
    satisfies: ["Gate 1", "Gate 2"]
    validate:
      mode: task_section
      hint: "TASK: sección 6 (Rollback plan)"

  prd:
    path_pattern: "docs/product/briefs/PRD-<id>-<slug>.md"
    description: "PO brief / PRD aprobado o equivalente dentro del Task."
    satisfies: ["Gate 1"]
    validate:
      mode: link_or_task_section
      hint: "Link PRD-* en TASK o PO brief equivalente en el TASK"
  ux_spec:
    path_pattern: "docs/ux/specs/UX-<id>-<slug>.md"
    description: "UX spec aprobado o equivalente dentro del Task (estados+interacciones+a11y)."
    satisfies: ["Gate 1"]
    validate:
      mode: link_or_task_section
      hint: "Link UX-* en TASK o sección UX equivalente (estados+interacciones+a11y)"
  adr:
    path_pattern: "docs/adr/####-<decision>.md"
    description: "ADR (Nygard) para decisiones irreversibles/estructurales/seguridad."
    satisfies: ["Gate 1"]
    validate:
      mode: link
      hint: "Link a ADR #### en TASK"
  test_doc:
    path_pattern: "docs/qa/test-plans/TEST-<id>-<slug>.md"
    description: "Test plan separado (cuando aplique)."
    satisfies: ["Gate 1", "Gate 2"]
    validate:
      mode: link
      hint: "Link TEST-* en TASK"
  db_doc:
    path_pattern: "docs/db/schema-changes/DB-<id>-<slug>.md"
    description: "Documento de cambios DB (si se usa)."
    satisfies: ["Gate 1", "Gate 2"]
    validate:
      mode: link
      hint: "Link DB-* en TASK"
  supa_doc:
    path_pattern: "docs/supabase/SUPA-<id>-<slug>.md"
    description: "Documento de cambios Supabase (si se usa)."
    satisfies: ["Gate 1", "Gate 2"]
    validate:
      mode: link
      hint: "Link SUPA-* en TASK"

skills_catalog:
  # Nota: esto NO es implementación, solo define semántica y contratos de entrada/salida.
  ScrumMaster:
    purpose: "Crear/ajustar Tasks (y opcionalmente Stories/Epics); asegurar que Gate 0 está completo."
    produces: ["TASK-*", "board updates (opcional)"]
  PO:
    purpose: "Definir valor, alcance, AC de producto, métricas de éxito."
    produces: ["PRD-* or PO section in Task"]
  "PO(light)":
    purpose: "Versión ligera: alcance + AC mínimos (sin PRD largo)."
    produces: ["PO section in Task or short PRD"]
  UX:
    purpose: "Definir UX/UI verificable (estados, interacciones, a11y) alineado a M3."
    produces: ["UX-* or UX section in Task", "ux rules updates (opcional)"]
  Arquitectura:
    purpose: "Definir boundaries, decisiones, trade-offs; crear ADR cuando aplique."
    produces: ["ADR ####", "architecture notes in Task"]
  Database:
    purpose: "Diseñar/validar cambios Postgres (schema/query) y plan de rollback."
    produces: ["DB-* (opcional)", "db notes in Task"]
  Supabase:
    purpose: "Cambios Supabase (auth/RLS/storage) y verificación de seguridad."
    produces: ["SUPA-* (opcional)", "supabase notes in Task"]
  "GitHub(branch)":
    purpose: "Crear branch corta por Task con convención trunk-based."
    produces: ["branch name in Task links"]
  Dev:
    purpose: "Implementación Flutter siguiendo gates, TDD default."
    produces: ["code changes", "implementation log in Task"]
  Testing:
    purpose: "Estrategia y evidencia de pruebas; incluye tests de arquitectura."
    produces: ["test evidence in Task", "TEST-* (opcional)", "arch-test evidence (opcional)"]
  Refactor:
    purpose: "Planificar refactor (opt-in) con seguridad y estrategia de regresión."
    produces: ["REF-* (opcional)", "refactor plan in Task"]

defaults:
  tdd: on
  skills_plan_base:
    # Base típica para trabajos de código (puede variar por regla)
    - ScrumMaster
    - GitHub(branch)
    - Dev
    - Testing
    - GitHub(PR)
  gate_1_base_requirements:
    - artifact: task_ac
      severity: blocker
      mode: task_section
    - artifact: task_plan_tecnico
      severity: blocker
      mode: task_section
    - artifact: task_test_plan
      severity: blocker
      mode: task_section

overrides_catalog:
  - key: tdd_off
    allowed_when: "tdd=off"
    requires: ["Justificación explícita en Task o reporte Supervisor"]
  - key: skip_po
    allowed_when: "type!=feature OR user_visible=no"
    requires: ["N/A explícito con motivo cuando aplique"]
  - key: skip_ux
    allowed_when: "surface no incluye ui OR user_visible=no"
    requires: ["N/A explícito con motivo cuando aplique"]
  - key: skip_adr
    allowed_when: "db_change=none AND surface no incluye auth AND no hay decisión irreversible"
    requires: ["N/A explícito con motivo cuando aplique"]

evaluation:
  # Regla-first y determinístico
  mode: ordered_rules
  merge_strategy:
    skills_plan: ordered_unique
    gate_1_requirements: ordered_unique
    notes: append

rules:
  # 1) Reglas globales (siempre)
  - id: R-GLOBAL-001
    description: "No code before Task (Gate 0 debe existir y estar completo)."
    match:
      always: true
    then:
      require:
        gate_1_requirements:
          - requirement: gate_0_complete
            severity: blocker
            mode: task_structure
            note: "Gate 0: Task existe y está completo hasta sección 4"
      notes:
        - "Si Gate 0 falla, detener ejecución antes de GitHub/Dev."

  - id: R-GLOBAL-002
    description: "Testing incluye arquitectura tests cuando aplique."
    match:
      always: true
    then:
      notes:
        - "Los tests de arquitectura pertenecen al skill Testing (no Arquitectura)."

  # 2) BUG cases
  - id: R-BUG-LOW-001
    description: "Bug low risk sin UI ni DB/auth."
    match:
      all:
        - type: bug
        - not_surface_any: [ui, auth, db]
        - db_change: none
        - risk: low
    then:
      set:
        skills_plan:
          - ScrumMaster
          - GitHub(branch)
          - Dev
          - Testing
          - GitHub(PR)
      require:
        gate_1_requirements:
          - artifact: task_ac
            severity: blocker
            mode: task_section
          - requirement: regression_test_plan
            severity: blocker
            mode: task_section
            note: "Task: Test plan mínimo (regresión)"

  - id: R-BUG-UI-001
    description: "Bug con UI o user-visible."
    match:
      all:
        - type: bug
        - any:
            - surface_any: [ui]
            - user_visible: yes
        - db_change: none
    then:
      set:
        skills_plan:
          - ScrumMaster
          - UX
          - GitHub(branch)
          - Dev
          - Testing
          - GitHub(PR)
      require:
        gate_1_requirements:
          - artifact: ux_spec
            severity: blocker
            mode: link_or_task_section
          - artifact: task_bug_repro
            severity: warning
            mode: task_section
          - requirement: widget_test_plan
            severity: blocker
            mode: task_section
            note: "Task: Test plan widget (mínimo)"

  - id: R-BUG-HIGH-001
    description: "Bug alto riesgo o con auth/db/supabase."
    match:
      all:
        - type: bug
        - any:
            - risk: high
            - surface_any: [auth, db]
            - db_change_in: [schema, rls_policy, storage]
    then:
      set:
        skills_plan:
          - ScrumMaster
          - Arquitectura
          - Database
          - Supabase
          - GitHub(branch)
          - Dev
          - Testing
          - GitHub(PR)
      require:
        gate_1_requirements:
          - artifact: adr
            severity: blocker
            mode: link
          - artifact: task_rollback
            severity: blocker
            mode: task_section
          - requirement: reinforced_test_plan
            severity: blocker
            mode: task_section
            note: "Task: Test plan reforzado (unit+integration; E2E si flujo crítico)"
      notes:
        - "Database/Supabase pueden ser N/A si no aplica, pero debe justificarse explícitamente."

  # 3) FEATURE cases
  - id: R-FEATURE-USER-001
    description: "Feature user-visible."
    match:
      all:
        - type: feature
        - user_visible: yes
    then:
      set:
        skills_plan:
          - ScrumMaster
          - PO
          - UX
          - Arquitectura
          - GitHub(branch)
          - Dev
          - Testing
          - GitHub(PR)
      require:
        gate_1_requirements:
          - artifact: prd
            severity: blocker
            mode: link_or_task_section
          - artifact: ux_spec
            severity: blocker
            mode: link_or_task_section
          - artifact: task_ac
            severity: blocker
            mode: task_section
          - requirement: test_plan_present
            severity: blocker
            mode: task_section
            note: "Task: Test plan"

  - id: R-FEATURE-INTERNAL-001
    description: "Feature interna (no user-visible)."
    match:
      all:
        - type: feature
        - user_visible: no
    then:
      set:
        skills_plan:
          - ScrumMaster
          - PO(light)
          - Arquitectura
          - GitHub(branch)
          - Dev
          - Testing
          - GitHub(PR)
      require:
        gate_1_requirements:
          - artifact: task_ac
            severity: blocker
            mode: task_section
            note: "PO(light): alcance/AC mínimos en Task o PRD corto linkeado"
          - requirement: test_plan_minimal
            severity: blocker
            mode: task_section
            note: "Task: Test plan mínimo"
      notes:
        - "UX suele ser N/A salvo UI indirecta; declarar N/A explícito."

  - id: R-FEATURE-DB-001
    description: "Feature con DB/Supabase."
    match:
      all:
        - type: feature
        - db_change_not: none
    then:
      add:
        skills_plan: [Database, Supabase]
      require:
        gate_1_requirements:
          - artifact: adr
            severity: blocker
            mode: link
          - requirement: migration_rollback_plan_if_schema
            severity: blocker
            mode: task_section
            note: "Task: Plan de migración/rollback (si schema)"
          - requirement: roles_permissions_if_auth_rls
            severity: blocker
            mode: task_section
            note: "Task: Roles/permisos esperados (si rls_policy/auth)"

  # 4) CHORE cases
  - id: R-CHORE-CI-001
    description: "Chore CI/infra low risk."
    match:
      all:
        - type: chore
        - surface_any: [ci, infra]
        - risk: low
    then:
      set:
        skills_plan: [ScrumMaster, GitHub(branch), Testing, GitHub(PR)]
      require:
        gate_1_requirements:
          - requirement: ci_verifiable_objective
            severity: blocker
            mode: task_section
            note: "Task: Objetivo verificable + evidencia esperada (CI/logs)"

  - id: R-CHORE-UI-001
    description: "Chore UI (theming/M3)."
    match:
      all:
        - type: chore
        - surface_any: [ui]
    then:
      set:
        skills_plan: [ScrumMaster, UX, GitHub(branch), Dev, Testing, GitHub(PR)]
      require:
        gate_1_requirements:
          - requirement: ux_m3_theme_checklist
            severity: blocker
            mode: link_or_task_section
            note: "UX: checklist M3 / reglas de tema (link a docs/ux/rules o sección en Task)"
          - requirement: visual_evidence_expected
            severity: warning
            mode: task_section
            note: "Task: Evidencia visual esperada (estados relevantes)"

  - id: R-CHORE-DOCS-001
    description: "Docs-only chore."
    match:
      all:
        - type: chore
        - surface_any: [docs]
        - not_surface_any: [ui, domain, data, db, auth, infra, ci]
    then:
      set:
        skills_plan: [ScrumMaster, GitHub(branch), GitHub(PR)]
      require:
        gate_1_requirements:
          - requirement: docs_summary_and_links
            severity: blocker
            mode: task_section
            note: "Task: Resumen + links (no requiere test plan técnico)"

  # 5) REFACTOR cases (opt-in)
  - id: R-REFACTOR-001
    description: "Refactor opt-in."
    match:
      all:
        - type: refactor
    then:
      set:
        skills_plan:
          - Refactor
          - Arquitectura
          - GitHub(branch)
          - Dev
          - Testing
          - GitHub(PR)
      require:
        gate_1_requirements:
          - requirement: refactor_plan_document
            severity: blocker
            mode: link_or_task_section
            note: "Refactor: plan REF-* (docs/tech-debt/refactor-plans/) o sección equivalente en Task"
          - requirement: non_functional_boundaries_ac
            severity: blocker
            mode: task_section
            note: "Task: AC no-funcionales (qué NO debe cambiar el comportamiento visible)"
          - requirement: refactor_reinforced_test_plan
            severity: blocker
            mode: task_section
            note: "Task: Test plan reforzado (regresión + arquitectura si aplica)"

  # 6) SPIKE cases
  - id: R-SPIKE-001
    description: "Spike (investigación)."
    match:
      all:
        - type: spike
    then:
      set:
        skills_plan: [ScrumMaster, PO, Arquitectura, Testing]
      require:
        gate_1_requirements:
          - requirement: spike_question_and_exit_criteria
            severity: blocker
            mode: task_section
            note: "Task: Pregunta a responder + criterio de salida"
          - requirement: spike_findings_deliverable
            severity: blocker
            mode: link_or_task_section
            note: "Entregable: doc de hallazgos/decisión (docs/spikes/ o sección en Task)"
      notes:
        - "GitHub/Dev son opcionales en spikes; si se crea POC, debe ser explícito."

  # 7) Ajustes por riesgo
  - id: R-RISK-HIGH-001
    description: "Si risk=high, reforzar evidencia."
    match:
      all:
        - risk: high
    then:
      add:
        gate_1_requirements:
          - artifact: task_rollback
            severity: blocker
            mode: task_section
            note: "Task: Rollback plan (obligatorio cuando risk=high)"
          - requirement: risk_high_reinforced_test_plan
            severity: blocker
            mode: task_section
            note: "Task: Test plan reforzado"
      notes:
        - "Considerar E2E si es flujo crítico."
```

**Notas de diseño**
- Cada elemento de `gate_1_requirements` usa una de dos formas:
  - **`artifact: <key>`**: referencia al catálogo `artifacts_catalog` (validar con `validate.mode`).
  - **`requirement: <snake_case_id>`**: regla ad-hoc sin artefacto nombrado; validar por `mode` + `note`.
  - Campos comunes: `severity` (`blocker` \| `warning` \| `info`), `mode` (`task_section` \| `link` \| `link_or_task_section` \| `task_structure`), `note` (texto humano).
- `GitHub(branch)` ocurre antes de `Dev` (pero después de PO/UX/ADR cuando existan).
- `Database` y `Supabase` pueden estar presentes como skills, pero se consideran “condicionales”: si el match los añadió y luego se declara `N/A`, debe existir justificación (ver “N/A explícito” en rules de gates).
- `PO(light)` significa que el artefacto puede ser corto, pero AC/alcance siguen siendo obligatorios.

---

<a id="idx-app-a1"></a>
## Apéndice A.1 — Diccionario de heurísticas (Router) en YAML

Este YAML permite inferir etiquetas y generar evidencia de clasificación.

```yaml
version: 1
name: workflow-router-heuristics
language: es

inputs:
  - task_text
  - changed_paths
  - changed_filenames
  - commit_message

outputs:
  labels:
    type: [bug, feature, chore, refactor, spike]
    surface: [ui, domain, data, db, auth, infra, ci, docs]
    db_change: [none, query, schema, rls_policy, storage]
    user_visible: [yes, no]
    risk: [low, medium, high]
    tdd: [on, off]
  evidence:
    - label: "<label>"
      reasons: ["..."]

normalization:
  case: lower
  strip_accents: true
  tokenization: simple

defaults:
  tdd: on
  db_change: none
  user_visible: no
  min_risk_for_surface:
    auth: medium
    db: medium

surface_heuristics:
  ui:
    keywords: [ui, pantalla, screen, widget, layout, tema, theme, colors, colorscheme, appbar, material 3, material3, navigationbar, responsive, adaptive, accesibilidad, a11y, semantics, localization, i18n, figma]
    paths:
      include:
        - "lib/**/presentation/**"
        - "lib/**/ui/**"
        - "lib/**/widgets/**"
        - "lib/**/pages/**"
        - "lib/**/screens/**"
        - "lib/**/theme/**"
    score: { keyword: 1, path: 2 }

  domain:
    keywords: [domain, usecase, interactor, entity, value object, regla de negocio, reglas de negocio, validacion, policy, workflow, cubit, bloc]
    paths:
      include:
        - "lib/**/domain/**"
        - "lib/**/usecases/**"
        - "lib/**/entities/**"
    score: { keyword: 1, path: 2 }

  data:
    keywords: [data layer, repository, repositorio, datasource, service, api client, dio, http, dto, mapping, serialization, cache, caching, offline, sync, retry, pagination]
    paths:
      include:
        - "lib/**/data/**"
        - "lib/**/repositories/**"
        - "lib/**/datasources/**"
        - "lib/**/services/**"
    score: { keyword: 1, path: 2 }

  db:
    keywords: [postgres, postgresql, sql, schema, migration, migracion, table, column, index, constraint, foreign key, trigger, view, explain]
    paths:
      include:
        - "supabase/migrations/**"
        - "db/**"
        - "sql/**"
    score: { keyword: 2, path: 3 }

  auth:
    keywords: [auth, login, signup, session, token, jwt, refresh, rls, policy, policies, roles, permissions, otp, magic link]
    paths:
      include:
        - "lib/**/auth/**"
        - "lib/**/security/**"
        - "supabase/**"
    score: { keyword: 2, path: 2 }

  infra:
    keywords: [docker, kubernetes, k8s, deployment, env, secrets, build pipeline, signing, release, fastlane]
    paths:
      include:
        - "infrastructure/**"
        - "infra/**"
        - "Dockerfile"
        - "docker/**"
        - "scripts/**"
    score: { keyword: 2, path: 2 }

  ci:
    keywords: [ci, pipeline, workflow, github actions, runner, cache step, lint step]
    paths:
      include:
        - ".github/workflows/**"
        - "bitrise.yml"
        - ".circleci/**"
    score: { keyword: 2, path: 3 }

  docs:
    keywords: [readme, documentacion, documentación, guia, adr, runbook]
    paths:
      include:
        - "docs/**"
    score: { keyword: 1, path: 3 }

surface_selection:
  mode: threshold
  include_if_score_gte: 2
  max_labels: 4

type_heuristics:
  bug:
    keywords: [bug, error, crash, regresion, regresión, no funciona, incorrecto, fix, hotfix, pasos de reproduccion, expected, actual]
    score: { keyword: 2 }
  feature:
    keywords: [agregar, nuevo, soportar, implementar, permitir, crear, como usuario, user story]
    score: { keyword: 2 }
  chore:
    keywords: [actualizar deps, bump, cleanup, formatear, lint, config, ci, docs, mantenimiento]
    score: { keyword: 2 }
  refactor:
    keywords: [refactor, reorganizar, renombrar, extraer, simplificar, mejorar estructura, deuda tecnica, technical debt, sin cambiar comportamiento]
    score: { keyword: 3 }
  spike:
    keywords: [investigar, evaluar, explorar, poc, prueba de concepto, spike]
    score: { keyword: 3 }

type_selection:
  mode: highest_score
  tie_breaker_order: [bug, feature, refactor, chore, spike]
  default: chore

db_change_heuristics:
  schema:
    keywords: [migration, migracion, create table, alter table, add column, drop column, index, constraint]
    paths:
      include:
        - "supabase/migrations/**"
        - "db/migrations/**"
    score: { keyword: 3, path: 5 }
  query:
    keywords: [query, sql, explain, analyze, slow, performance, indice, index]
    score: { keyword: 2 }
  rls_policy:
    keywords: [rls, policy, policies, row level security, permisos, roles]
    paths:
      include:
        - "supabase/**"
    score: { keyword: 4, path: 2 }
  storage:
    keywords: [storage, bucket, signed url, upload, download]
    score: { keyword: 3 }

db_change_selection:
  mode: highest_score
  default: none

user_visible_heuristics:
  yes:
    keywords: [pantalla, ui, visual, texto, flujo, onboarding, navegación, rendimiento, performance, tarda, lento, usuario, customers]
    score: { keyword: 1 }
    auto_yes_if_surface_includes: [ui]
  no:
    keywords: [refactor interno, solo ci, solo docs, tooling]
    score: { keyword: 2 }

user_visible_selection:
  mode: rule_then_score
  rules:
    - if_surface_includes_any: [ui]
      set: yes
  default: no

risk_scoring:
  base: 0
  add_if_surface_includes: { auth: 3, db: 3, infra: 2, ci: 1, ui: 1 }
  add_if: { db_change_not_none: 2, user_visible_yes: 1 }
  add_if_type: { refactor: 2, spike: 0, bug: 1, feature: 1, chore: 0 }
  min_risk_by_conditions:
    - if_surface_includes_any: [auth]
      min_risk: medium
    - if_db_change_in: [schema, rls_policy]
      min_risk: high

risk_thresholds:
  low_max: 1
  medium_max: 3
  high_min: 4

routing_hints:
  require_ux_if:
    - if_surface_includes_any: [ui]
      and_user_visible: yes
  require_po_if:
    - if_type_in: [feature]
      and_risk_in: [medium, high]
  require_adr_if:
    - if_db_change_in: [schema, rls_policy]
    - if_type_in: [refactor]
      and_risk_in: [high]
```

---

<a id="idx-app-b"></a>
## Apéndice B — Template: PO brief / PRD (artefacto de producto)

**Ubicación sugerida**: `docs/product/briefs/PRD-<id>-<slug>.md`

Propósito: capturar el **valor**, el **alcance**, los **criterios de aceptación** a nivel producto y las **restricciones**. Debe ser lo suficientemente claro para que:

- el Router decida si se requiere UX/Arquitectura/DB/Supabase,
- el Scrum Master pueda dividir en Tasks,
- el Dev pueda implementar sin “inventar” requisitos.

```markdown
---
id: PRD-<id>
title: <título del feature>
status: draft | approved | superseded
owner: <PO/PM>
created_at: <YYYY-MM-DD>
updated_at: <YYYY-MM-DD>
links:
  epic: EPIC-<id> | null
  stories: []   # STORY-<id>
  tasks: []     # TASK-<id>
---

## 1) Resumen ejecutivo
- **Qué**: 1–2 líneas.
- **Por qué**: valor principal.
- **Quién**: usuarios/stakeholders impactados.

## 2) Problema
- **Pain** actual (qué duele, cuándo, a quién).
- Evidencia (si existe): tickets, feedback, métricas.

## 3) Objetivos y métricas de éxito
- **Objetivo**: ...
- **Métrica(s)**: ...
- **No objetivos** (anti-goals): ...

## 4) Alcance
### En alcance
- ...

### Fuera de alcance
- ...

## 5) Requisitos (alto nivel)
- R1: ...
- R2: ...

## 6) Criterios de aceptación (producto)
- [ ] AC1: ...
- [ ] AC2: ...
- [ ] AC3: ...

## 7) Casos de uso (narrativos)
- Caso 1: ...
- Caso 2: ...

## 8) Dependencias / restricciones
- Integraciones: ...
- Plataformas: ...
- Datos/privacidad: ...
- Legal/compliance (si aplica): ...

## 9) Riesgos y mitigaciones
- Riesgo: ...
  - Mitigación: ...

## 10) Preguntas abiertas
- [ ] ...

## 11) Notas de lanzamiento (draft)
- ...
```

**Regla**: todo Task `type=feature` con `user_visible=yes` debe linkear a un PRD o incluir una sección equivalente “PO brief” dentro del Task.

---

<a id="idx-app-c"></a>
## Apéndice C — Template: UX spec (Flutter + Material 3)

**Ubicación sugerida**: `docs/ux/specs/UX-<id>-<slug>.md`

Propósito: definir comportamiento de UI/UX de forma verificable (estados, navegación, accesibilidad, textos), alineado con Material 3 y con reglas del proyecto.

```markdown
---
id: UX-<id>
title: <título corto>
status: draft | approved | superseded
owner: <UX/Dev>
created_at: <YYYY-MM-DD>
updated_at: <YYYY-MM-DD>
links:
  prd: PRD-<id> | null
  tasks: [] # TASK-<id>
---

## 1) Contexto
- Qué cambia y por qué.
- Screens/flows afectados.

## 2) Principios y reglas aplicables (M3 / proyecto)
- Material 3: sí/no (default sí).
- Tokens/ColorScheme: ...
- AppBar: `AppBarThemeData.backgroundColor` (evitar confusión con fondo).
- Componentes preferidos (NavigationBar, FilledButton, etc.).

## 3) Flujo de usuario (happy path)
1. ...
2. ...

## 4) Estados de UI (obligatorio)
- **Loading**: ...
- **Empty**: ...
- **Error**: mensaje + acción (retry, etc.)
- **Success**: ...

## 5) Layout y contenido
- Estructura general (secciones).
- Textos (copy): ...
- Formatos: moneda/fechas/unidades, etc.

## 6) Interacciones
- Tap/long press/swipe/hover (si aplica).
- Confirmaciones y orden de botones (Windows vs otros si aplica).

## 7) Accesibilidad (a11y)
- Semantics: labels/hints.
- Targets mínimos y contraste.
- Navegación por teclado (si aplica en desktop/web).

## 8) Navegación y routing
- Pantallas origen/destino.
- Deep links (si aplica).

## 9) Validación (UX → QA)
- Checklist visual (qué verificar).
- Casos borde: ...

## 10) Recursos
- Links a Figma / referencias.
- Capturas (si existen).
```

**Regla**: si `surface` incluye `ui` y `user_visible=yes`, se requiere `UX spec` o, como mínimo, completar dentro del Task las secciones: “Estados de UI” + “Interacciones” + “Accesibilidad”.

---

<a id="idx-app-d"></a>
## Apéndice D — Template: ADR (Architecture Decision Record)

**Ubicación sugerida**: `docs/adr/####-<decision>.md`

Formato recomendado (Nygard): captura el **por qué** de decisiones irreversibles o con trade-offs importantes.

```markdown
# ADR ####: <título de la decisión>

## Status
Proposed | Accepted | Rejected | Deprecated | Superseded by ADR ####

## Context
Qué problema/responsabilidad estamos resolviendo y por qué ahora.

## Decision
Qué decisión tomamos (qué vamos a hacer).

## Consequences
Qué mejora, qué empeora, qué riesgos introduce, qué deuda crea.

## Alternatives considered
- Opción A: pros/cons
- Opción B: pros/cons

## Related
- Tasks: TASK-...
- PRDs: PRD-...
- UX: UX-...
```

**Reglas sugeridas para exigir ADR**
- `db_change in {schema, rls_policy}`.
- Cambios en boundaries/capas/estructura (arquitectura).
- Decisiones de seguridad (auth/RLS/roles).
- Cambios que afecten offline-first/online-first/SSOT/UDF.

---

<a id="idx-app-e"></a>
## Apéndice E — Template: Test Plan (por Task o por feature)

**Ubicación sugerida (cuando sea grande)**: `docs/qa/test-plans/TEST-<id>-<slug>.md`  
**Ubicación mínima (default)**: dentro del `TASK-*` en secciones 8 y 9.

Propósito: hacer verificable el trabajo y convertir el “Done” en un checklist objetivo.

```markdown
---
id: TEST-<id>
title: <qué se testea>
scope: unit | widget | integration | e2e | architecture
status: draft | executed | automated
owner: <QA/Dev>
created_at: <YYYY-MM-DD>
updated_at: <YYYY-MM-DD>
links:
  tasks: [] # TASK-<id>
  pr: <url> | null
---

## 1) Alcance
- Qué cubre / qué no cubre.

## 2) Matriz de pruebas (mínimo)
### Unit
- Caso: ...
  - Resultado esperado: ...

### Widget
- Pantalla/componente: ...
  - Validaciones: ...

### Integration
- Flujo: ...
  - Setup: ...
  - Resultado: ...

### E2E (opcional / solicitado)
- Escenario: ...
  - Evidencia: capturas/video/logs

### Tests de arquitectura (cuando aplique)
- Regla: “presentation no importa data”, etc.
- Evidencia: test/lint/CI.

## 3) Datos y ambientes
- Fixtures / seeds.
- Usuarios/roles (si aplica auth/RLS).
- Offline/online (si aplica).

## 4) Ejecución
- Comandos:
  - `...`
- CI:
  - link/nota

## 5) Resultados
- PASS/FAIL
- Incidencias encontradas
```

---

<a id="idx-app-f"></a>
## Apéndice F — Template: PR (Pull Request) (opcional pero recomendado)

Este artefacto no tiene por qué vivir en `docs/`, pero documentarlo aquí ayuda a estandarizar el “Done”.

```markdown
## Summary
- ...

## Scope
- Incluye:
- No incluye:

## Test plan
- [ ] Unit
- [ ] Widget
- [ ] Integration
- [ ] E2E (si aplica)

## Evidence
- Capturas/logs (si aplica):

## Links
- Task: TASK-...
- PRD: PRD-... (si aplica)
- UX: UX-... (si aplica)
- ADR: ADR-... (si aplica)
```

---

<a id="idx-app-g"></a>
## Apéndice G — Template: EPIC (visión + agrupación)

**Ubicación sugerida**: `docs/workflow/epics/EPIC-<id>-<slug>.md`

Propósito: **agrupar** historias y tasks bajo un objetivo de negocio; **no** duplicar el log del Task (solo resumen y links).

```markdown
---
id: EPIC-<id>
title: <nombre corto del outcome>
status: draft | in_progress | done | cancelled
owner: <PM/PO>
created_at: <YYYY-MM-DD>
updated_at: <YYYY-MM-DD>
links:
  prds: []
  stories: []  # STORY-<id>
  tasks: []   # TASK-<id> (opcional)
---

## 1) Objetivo de negocio
- Qué resultado queremos (1–3 bullets).

## 2) Alcance / no-alcance
- En alcance:
- Fuera:

## 3) Métricas o definición de éxito (opcional)
- ...

## 4) Stories vinculadas
| STORY | Título | Estado |
|-------|--------|--------|
| ... | ... | ... |

## 5) Riesgos y dependencias
- ...

## 6) Notas
- (solo decisiones de época, no log diario)
```

---

<a id="idx-app-h"></a>
## Apéndice H — Template: STORY (resumen + links a Tasks)

**Ubicación sugerida**: `docs/workflow/stories/STORY-<id>-<slug>.md`

Propósito: narrativa de usuario y **trazabilidad** a Tasks; el detalle operativo vive en cada `TASK-*`.

```markdown
---
id: STORY-<id>
title: <Como ... quiero ... para ...>
status: draft | ready | in_progress | done | cancelled
owner: <PO/SM>
created_at: <YYYY-MM-DD>
updated_at: <YYYY-MM-DD>
links:
  epic: EPIC-<id> | null
  prd: PRD-<id> | null
  tasks: []  # TASK-<id> (orden sugerido)
---

## 1) Narrativa
- **Como** ...
- **Quiero** ...
- **Para** ...

## 2) Criterios de aceptación (alto nivel)
- [ ] ...
- [ ] ...

## 3) Tasks (fuente de verdad operativa)
| Task | Título | Estado | PR |
|------|--------|--------|-----|
| TASK-... | ... | ... | ... |

## 4) Diseño / UX (links)
- UX specs: ...
```

---

<a id="idx-app-i"></a>
## Apéndice I — Template: SPIKE (hallazgos / decisión)

**Ubicación sugerida**: `docs/spikes/SPIKE-<id>-<slug>.md`

Propósito: salida de investigación; puede **no** generar PR; debe cerrar con **decisión o recomendación**.

```markdown
---
id: SPIKE-<id>
title: <pregunta o hipótesis>
status: open | resolved | cancelled
owner: <rol>
created_at: <YYYY-MM-DD>
updated_at: <YYYY-MM-DD>
links:
  tasks: []
  related: []
---

## 1) Pregunta
- ¿Qué queremos saber/decidir?

## 2) Criterio de salida
- Qué debe existir para considerar el spike cerrado.

## 3) Enfoque
- Experimentos, lecturas, POC (si hay).

## 4) Hallazgos
- ...

## 5) Decisión / recomendación
- **Opción elegida**: ...
- **Siguiente paso**: crear Task(s) / PRD / ADR si aplica.

## 6) Referencias
- Links, docs, issues.
```

---

<a id="idx-app-j"></a>
## Apéndice J — Template: Plan de refactor (REF)

**Ubicación sugerida**: `docs/tech-debt/refactor-plans/REF-<id>-<slug>.md`

Propósito: plan **opt-in** con límites claros (qué no debe cambiar) y estrategia de pruebas/regresión.

```markdown
---
id: REF-<id>
title: <ámbito del refactor>
status: draft | approved | in_progress | done | cancelled
owner: <Dev/Arch>
created_at: <YYYY-MM-DD>
updated_at: <YYYY-MM-DD>
links:
  tasks: []
  adr: []
---

## 1) Contexto / olor detectado
- ...

## 2) Objetivo del refactor
- Qué mejora (legibilidad, boundaries, deuda, perf, etc.).

## 3) Límites (no-funcional)
- **Comportamiento que NO debe cambiar**: ...
- Superficies/APIs públicas a preservar: ...

## 4) Plan por fases (opcional)
1. ...
2. ...

## 5) Estrategia de pruebas
- Unit / widget / integration / arch tests / E2E si aplica.

## 6) Riesgos y rollback
- ...

## 7) Resultado
- Completado: sí/no; enlaces a PRs/Tasks.
```

---

<a id="idx-app-k"></a>
## Apéndice K — Template: Cambios Postgres (DB)

**Ubicación sugerida**: `docs/db/schema-changes/DB-<id>-<slug>.md`

Propósito: documentar cambio de esquema o consulta crítica **antes/después** de migraciones; alinear con Task y ADR si aplica.

```markdown
---
id: DB-<id>
title: <resumen del cambio>
status: draft | applied | rolled_back
owner: <Dev>
created_at: <YYYY-MM-DD>
links:
  tasks: []
  adr: []
  supabase: []
---

## 1) Resumen
- Qué tablas/columnas/índices/constraints.

## 2) Motivación
- Performance, integridad, nueva feature, etc.

## 3) Migración
- Nombre de migración / orden.
- SQL resumido o referencia a archivo en repo.

## 4) Datos existentes
- Backfill, valores por defecto, riesgo de locking.

## 5) Rollback
- Cómo revertir o mitigar.

## 6) Verificación
- Queries de smoke, `EXPLAIN` si aplica.
```

---

<a id="idx-app-l"></a>
## Apéndice L — Template: Cambios Supabase (SUPA)

**Ubicación sugerida**: `docs/supabase/SUPA-<id>-<slug>.md`

Propósito: auth, RLS, storage, triggers; pasos reproducibles y seguridad. En implementación puede complementarse con **MCP Supabase**.

```markdown
---
id: SUPA-<id>
title: <auth | rls | storage | función | ...>
status: draft | applied | verified
owner: <Dev>
created_at: <YYYY-MM-DD>
links:
  tasks: []
  adr: []
  db: []
---

## 1) Alcance
- Proyecto/entorno: ...
- Qué se cambia (tablas, buckets, policies).

## 2) Auth (si aplica)
- Flujos (login, refresh, providers).
- Consideraciones de sesión/token.

## 3) RLS / policies (si aplica)
- Roles esperados.
- Policies: resumen por tabla/operación.
- Matriz “quién puede qué”.

## 4) Storage (si aplica)
- Buckets, paths, reglas de acceso, signed URLs.

## 5) Pasos reproducibles
- Orden: migración → policy → verificación.
- Comandos o enlace a scripts.

## 6) Verificación de seguridad
- Casos: usuario anónimo, rol A, rol B, cross-tenant si aplica.

## 7) Rollback / mitigación
- ...
```

---

<a id="idx-app-m"></a>
## Apéndice M — Supervisor: Gate 2 y Gate 3 en YAML (portable)

Complementa la sección textual **“Gate Validation Rules”**: lista estructurada de requisitos típicos para **Ready for PR** y **Done**. Misma forma que `gate_1_requirements` del Apéndice A (objetos con `severity`, `mode`, `note`).

```yaml
version: 1
name: workflow-supervisor-gates-2-3
language: es

gate_2_requirements:
  # Ready for PR — alinear con G2-* del documento
  - requirement: implementation_log_updated
    severity: blocker
    mode: task_section
    note: "TASK sección 7 (Implementación / decisiones)"
  - requirement: verification_evidence
    severity: blocker
    mode: task_section
    note: "TASK sección 9: comandos y/o link CI + PASS/FAIL explícito"
  - requirement: branch_linked
    severity: blocker
    mode: task_structure
    note: "TASK links.branch (crear antes de code si aplica)"
  - requirement: pr_linked_when_exists
    severity: warning
    mode: task_structure
    note: "TASK links.pr cuando el PR exista"
  - requirement: linked_artifacts_or_na
    severity: warning
    mode: task_section
    note: "PRD/UX/ADR/TEST/DB/SUPA linkeados o N/A con motivo"

gate_3_requirements:
  # Done / Merged — alinear con G3-*
  - requirement: pr_merged
    severity: blocker
    mode: task_structure
    note: "TASK links.pr apunta a PR mergeado"
  - requirement: task_status_done
    severity: blocker
    mode: task_structure
    note: "TASK status=done y updated_at actualizado"
  - requirement: post_checks_or_na
    severity: warning
    mode: task_section
    note: "TASK sección 10 post-checks o N/A explícito"
```

---

<a id="idx-notas"></a>
## Notas y próximos pasos

Este documento se irá ampliando con:

- Implementación del validador (CI/skill) sobre Apéndice A + M y Gate Validation Rules.
- Spec explícita de **tests de arquitectura** (reglas por capa) como apéndice técnico.
- Integración operativa con MCPs (Supabase, mobile testing) y scripts.

