# Inventario y análisis — `examples/mitaller-skills`

> Análisis del harness battle-tested del proyecto **Mi Taller** (Flutter + Supabase, pre-lanzamiento).
> Objetivo: identificar qué es **genérico** (base de Aquelarre) y qué es **específico del proyecto** (debe modificarse o eliminarse).
>
> Versión: 1.1 · Fecha: 2026-09-01 · **Sin cambios aplicados** — solo diagnóstico.

---

## 1. Resumen ejecutivo

El folder `examples/mitaller-skills` contiene **11 skills**, el **SPEC completo del workflow**, **3 rules de Cursor**, y **~130 archivos en `docs/`** (artefactos reales de producción). La estructura general es sólida y reutilizable; el problema principal para Aquelarre no es el *workflow*, sino el **acoplamiento** a:

1. **Naming** (`mitaller-*`, “Mi Taller” en textos).
2. **Documentos de dominio** del taller (órdenes, inventario, workshop, estados de orden).
3. **Patrones de arquitectura elegidos** para Mi Taller (offline-first + SQLite + Supabase) tratados como obligatorios universales.
4. **Implementación concreta** en código (`SyncDateTimeMixin`, repositorios, widgets, módulo orders).
5. **Rutas personales** del desarrollador (`.cursor/FlutterArmy/...`).
6. **Credenciales, packages y ambientes** de Mi Taller en playbooks E2E/Appium.

| Categoría | Cantidad estimada | Acción futura |
|-----------|-------------------|---------------|
| **`AI_WORKFLOW_SKILLS_SPEC.md`** | ~95% genérico | **Migrar íntegro al harness** (prioridad #1) |
| Skills (`mitaller-*`) | ~40–50% genérico | Renombrar y limpiar acoplamiento |
| Rules (`rules/*.mdc`) | 1 genérica, 2 muy acopladas | Solo `workflow-gate0` al harness |
| `docs/` — proceso workflow | Templates + convenciones | Extraer a `templates/` Aquelarre |
| `docs/` — artefactos TASK/UX/TEST reales | 100% Mi Taller | Quedan como **ejemplos**, no en harness |
| `docs/` — patrones técnicos | Semi-genérico | Opcional por proyecto consumidor |

---

## 2. Estructura actual del folder

```
examples/mitaller-skills/
├── README.md
├── rules/                          ← NUEVO: rules de Cursor
│   ├── workflow-gate0-task-ready.mdc
│   ├── autorules.mdc               (contenido = flutter-pro del proyecto)
│   └── flutter-pro.mdc
├── docs/                           ← NUEVO: SPEC + artefactos reales
│   ├── AI_WORKFLOW_SKILLS_SPEC.md  ← fuente de verdad del workflow
│   ├── workflow/tasks|stories|epics/
│   ├── ux/specs/
│   ├── qa/test-plans/
│   ├── supabase/
│   ├── adr/ + architecture/
│   ├── testing/
│   └── ... (docs de dominio/setup)
├── mitaller-workflow-orchestration/
│   └── ...
└── ... (11 skills)
```

**Total ampliado:** ~131 archivos · 11 skills · 3 rules · 1 SPEC maestro · decenas de artefactos de workflow reales.

---

## 3. Mapa del workflow probado (genérico)

Este es el flujo que **sí** debe preservarse como núcleo de Aquelarre. Está distribuido entre skills pero es coherente y battle-tested.

```
Solicitud
    │
    ▼
[scrum-master] ──► TASK en docs/workflow/tasks/ (Gate 0)
    │
    ▼
[workflow-orchestration] ──► skills_plan + gate_1_requirements
    │
    ├── [po-product]        si feature + user_visible
    ├── [ux-flutter]        si surface=ui + user_visible
    ├── [architecture-adr]  si riesgo alto / auth / schema
    ├── [database-postgres] si db_change
    ├── [supabase]          si auth / RLS / storage
    └── [testing]           plan de pruebas (Gate 1)
    │
    ▼
Gate 1 PASS → TASK en `ready`
    │
    ▼
[dev-flutter] + TDD + branch por task
    │
    ▼
[testing] evidencia ──► Gate 2
    │
    ▼
[github] PR + trazabilidad TASK-ID
    │
    ▼
Aprobación humana ──► Gate 3 → `done`

Paralelo/opt-in:
  [refactor] solo si type=refactor
```

### 3.1 Convenciones de workflow (genéricas ✅)

| Convención | Dónde aparece | Estado |
|------------|---------------|--------|
| `no code before task` | orchestration, dev-flutter | ✅ Genérico |
| Gates 0 → 1 → 2 → 3 | orchestration | ✅ Genérico |
| Reporte PASS/FAIL con `rule_id` (G1-PO-001, etc.) | orchestration | ✅ Genérico |
| TASK en `docs/workflow/tasks/TASK-<id>-<slug>.md` | scrum-master, orchestration | ✅ Genérico |
| Estados: intake, ready, in_progress, in_review, blocked, done | scrum-master | ✅ Genérico |
| Clasificación: type, surface, risk, user_visible, db_change, tdd | orchestration | ✅ Genérico (falta `platform`, `ci` de VISION) |
| Branch antes de codear | orchestration, github | ✅ Genérico |
| TDD por defecto (`tdd=on`) | dev-flutter | ✅ Genérico |
| Refactor opt-in | orchestration, refactor | ✅ Genérico |
| Artefactos condicionales Gate 1: PO, UX, ADR, DB, SUPA, TEST | orchestration | ✅ Genérico |
| Evidencia testing en TASK para Gate 2 | testing, dev-flutter | ✅ Genérico |
| PR enfocado al task + TASK-ID en commits | github | ✅ Genérico |
| Evidencia visual gitignored en `docs/testing/evidence/` | testing | ✅ Genérico |

### 3.2 Fuente de verdad del workflow — `AI_WORKFLOW_SKILLS_SPEC.md`

| Hecho | Impacto |
|-------|---------|
| El SPEC **existe** en `examples/mitaller-skills/docs/` (~2000 líneas) | Debe migrarse a `aquelarre/docs/` como núcleo del harness |
| Los skills implementan *roles*; el SPEC define *reglas G* y routing* | Separación correcta — skills son delgados, SPEC es grueso |
| Incluye YAML de routing, heurísticas y 12 plantillas | Base para validador automático / CI futuro |

---

## 4. Inventario skill por skill

### 4.1 `mitaller-workflow-orchestration`

| Aspecto | Detalle |
|---------|---------|
| **Rol** | Routing de skills + supervisor de gates |
| **Archivos** | `SKILL.md` |
| **Genérico** | Toda la lógica de routing, gates, formato YAML PASS/FAIL, `skills_plan`, `gate_1_requirements` |
| **Específico Mi Taller** | Nombre `mitaller-*`; descripción dice *"workflow AI-Driven de Mi Taller"* |
| **Referencias externas** | `docs/AI_WORKFLOW_SKILLS_SPEC.md` (genérico, falta en Aquelarre) |
| **Acción sugerida** | Renombrar → `aquelarre-workflow-orchestration`; neutralizar descripción; enlazar SPEC del harness |

---

### 4.2 `mitaller-scrum-master`

| Aspecto | Detalle |
|---------|---------|
| **Rol** | EPIC/STORY/TASK, estados, Gate 0 |
| **Archivos** | `SKILL.md` |
| **Genérico** | ~95% — creación de tasks, clasificación mínima, split, trazabilidad |
| **Específico Mi Taller** | Solo naming |
| **Referencias externas** | `docs/AI_WORKFLOW_SKILLS_SPEC.md` |
| **Acción sugerida** | Renombrar; añadir campos `platform` y `ci` al checklist Gate 0 (alineado con VISION) |

---

### 4.3 `mitaller-po-product`

| Aspecto | Detalle |
|---------|---------|
| **Rol** | PRD/PO brief, AC, métricas de éxito |
| **Archivos** | `SKILL.md` |
| **Genérico** | Flujo PO, condiciones Gate 1 para features user-visible |
| **Específico Mi Taller** | Input *"Restricciones del dominio del **taller**"* — lenguaje de negocio del proyecto |
| **Acción sugerida** | Cambiar a *"Restricciones del dominio del **proyecto**"*; renombrar skill |

---

### 4.4 `mitaller-architecture-adr`

| Aspecto | Detalle |
|---------|---------|
| **Rol** | ADRs, trade-offs, rollback |
| **Archivos** | `SKILL.md`, `reference.md`, `examples.md` |
| **Genérico** | Proceso ADR, condiciones (schema, rls, auth), estructura contexto/decisión/rollback; capas presentation/domain/data |
| **Semi-genérico** | Offline-first lectura / online-first escritura — patrón válido pero **decisión de arquitectura del proyecto**, no del harness |
| **Específico Mi Taller** | Ver tabla abajo |
| **Acción sugerida** | Separar proceso ADR (harness) de patrones de datos (reference opcional del proyecto) |

**Contenido específico Mi Taller en architecture-adr:**

| Ubicación | Contenido | Veredicto |
|-----------|-----------|-----------|
| `SKILL.md` → fuentes | `docs/ORDERS_ARCHITECTURE_PATTERNS.md` | ❌ Dominio órdenes del taller |
| `SKILL.md` → fuentes | `docs/INVENTORY_SYSTEM.md` | ❌ Dominio inventario del taller |
| `SKILL.md` → fuentes | `docs/OFFLINE_FIRST_SYNC_PATTERN.md` | ⚠️ Patrón reutilizable; no obligatorio para todos los proyectos |
| `SKILL.md` → criterios | `SyncDateTimeMixin`, `updated_at`, offline/online-first como **obligatorio** | ⚠️ Implementación Mi Taller; parametrizar o bajar a reference del proyecto |
| `reference.md` | `SyncDateTimeMixin`, `shouldUseLocal(local, remote)` | ❌ Clases concretas del código Mi Taller |
| `reference.md` | Rutas `.cursor/FlutterArmy/skills-main/...` | ❌ Ruta personal no portable |
| `examples.md` | Casos sync y RLS | ✅ Ejemplos de *formato* ADR son genéricos |

---

### 4.5 `mitaller-ux-flutter`

| Aspecto | Detalle |
|---------|---------|
| **Rol** | UX spec antes de implementar UI |
| **Archivos** | `SKILL.md`, `reference.md`, `examples.md` |
| **Genérico** | Proceso UX Gate 1, estados loading/empty/error/success, accesibilidad, Material/theme tokens |
| **Semi-genérico** | Patrón AppBar (elevation 0, w600, fontSize 20) — convención del equipo/proyecto, no universal |
| **Específico Mi Taller** | Ver tabla abajo |
| **Acción sugerida** | Mantener proceso; mover patrones visuales concretos a `reference.md` del **proyecto consumidor** o plantilla temática |

**Contenido específico Mi Taller en ux-flutter:**

| Ubicación | Contenido | Veredicto |
|-----------|-----------|-----------|
| `SKILL.md` → fuentes | `docs/UI_UX_SUPABASE_CODING_PRACTICES.md` | ⚠️ Mezcla prácticas UI genéricas + convenciones Mi Taller |
| `SKILL.md` → fuentes | `docs/THEME_SYSTEM_UI_SETUP.md` | ❌ Sistema de tema específico del proyecto |
| `SKILL.md` | Patrones AppBar detallados (valores exactos) | ⚠️ Convención de proyecto; útil como ejemplo, no como estándar del harness |
| `reference.md` | `lib/common/widgets/custom_app_bar.dart` como anti-patrón | ❌ Path y widget del repo Mi Taller |
| `reference.md` | `.cursor/FlutterArmy/skills-main/...` | ❌ Ruta personal |
| `examples.md` | Estructura de estados | ✅ Genérico |

---

### 4.6 `mitaller-dev-flutter`

| Aspecto | Detalle |
|---------|---------|
| **Rol** | Implementación Flutter con TDD |
| **Archivos** | `SKILL.md`, `reference.md`, `examples.md` |
| **Genérico** | Reglas operativas workflow, TDD, checklist implementación, trazabilidad en TASK |
| **Semi-genérico** | Estados UI loading/error/empty/loaded |
| **Específico Mi Taller** | **Alto** — ver tabla |
| **Acción sugerida** | Skill harness = workflow + TDD + checklist; patrones de sync → reference opcional o skill de arquitectura del proyecto |

**Contenido específico Mi Taller en dev-flutter:**

| Ubicación | Contenido | Veredicto |
|-----------|-----------|-----------|
| `SKILL.md` → fuentes | `docs/ORDERS_ARCHITECTURE_PATTERNS.md` | ❌ Dominio taller |
| `SKILL.md` | Patrones obligatorios: offline-first, online-first, `SyncDateTimeMixin` | ❌ Arquitectura elegida para Mi Taller, no para todo Flutter |
| `SKILL.md` | Checklist: confirmar estrategia offline/online y `updated_at` | ❌ Solo aplica a apps con sync local/remoto |
| `reference.md` | SQLite + Supabase como stack de cache | ⚠️ Común en Mi Taller; no universal |
| `reference.md` | `SyncDateTimeMixin.shouldUseLocal(...)` | ❌ Implementación concreta |
| `reference.md` | *"Repositorio inventario: createItem, updateItem..."* | ❌ Código de dominio taller |
| `reference.md` | *"Repositorio ordenes: getOrderById..."* | ❌ Código de dominio taller |
| `reference.md` | `.cursor/FlutterArmy/...` | ❌ Ruta personal |
| `examples.md` | Flujos sync con SQLite/Supabase | ⚠️ Buenos ejemplos; deben vivir en doc de patrón del proyecto, no en harness genérico |

---

### 4.7 `mitaller-database-postgres`

| Aspecto | Detalle |
|---------|---------|
| **Rol** | Cambios de esquema, migración, rollback |
| **Archivos** | `SKILL.md` |
| **Genérico** | ~90% — proceso DB en workflow, Gate 1 para schema |
| **Específico Mi Taller** | Título *"Postgres/SQLite alineado"*; referencia `database/sqlite/README.md` (schema local Mi Taller) |
| **Acción sugerida** | Separar skill genérico `aquelarre-database-postgres` (Supabase/Postgres) de convenciones SQLite locales del proyecto |

---

### 4.8 `mitaller-supabase`

| Aspecto | Detalle |
|---------|---------|
| **Rol** | Auth, RLS, storage, edge functions |
| **Archivos** | `SKILL.md` |
| **Genérico** | ~85% — proceso RLS, actor/rol/permiso, pruebas positivas/negativas |
| **Específico Mi Taller** | `supabase/functions/create-workshop-user/README.md` — función de dominio *workshop* |
| **Referencias** | `docs/UI_UX_SUPABASE_CODING_PRACTICES.md` — parcialmente proyecto |
| **Acción sugerida** | Eliminar referencia a `create-workshop-user`; mantener proceso Supabase genérico |

---

### 4.9 `mitaller-testing`

| Aspecto | Detalle |
|---------|---------|
| **Rol** | Test plan, evidencia Gate 2, cobertura por riesgo |
| **Archivos** | `SKILL.md`, `reference.md` |
| **Genérico** | ~80% — unit/widget/integration, evidencia PASS/FAIL, carpeta gitignored, Appium/MCP smoke |
| **Específico Mi Taller** | Sección *"patrones del proyecto"* con `shouldUseLocal`, sync, AppBar |
| **Referencias** | `docs/VALIDACIONES_Y_TESTS.md` — convenciones del repo Mi Taller |
| **Acción sugerida** | Mantener proceso de testing; mover casos de sync a tests del proyecto; traer `EVIDENCE_LOCAL.md` al harness como template |

---

### 4.10 `mitaller-github`

| Aspecto | Detalle |
|---------|---------|
| **Rol** | Branch, PR, merge, Gate 2/3 |
| **Archivos** | `SKILL.md` |
| **Genérico** | **100%** — solo naming |
| **Acción sugerida** | Renombrar a `aquelarre-github` |

---

### 4.11 `mitaller-refactor`

| Aspecto | Detalle |
|---------|---------|
| **Rol** | Refactors opt-in con regresión |
| **Archivos** | `SKILL.md` |
| **Genérico** | **100%** — solo naming |
| **Acción sugerida** | Renombrar a `aquelarre-refactor` |

---

## 5. Catálogo de referencias externas

Documentos que los skills citan y su clasificación para Aquelarre.

| Documento referenciado | Skills que lo usan | Tipo | Acción para Aquelarre |
|------------------------|-------------------|------|------------------------|
| `docs/AI_WORKFLOW_SKILLS_SPEC.md` | **Todos** | Harness (genérico) | **Migrar al paquete Aquelarre** — prioridad máxima |
| `docs/workflow/tasks/TASK-*.md` | Varios | Harness (genérico) | Crear `templates/TASK.template.md` |
| `docs/testing/evidence/` | testing | Harness (genérico) | Documentar en harness; `.gitignore` template |
| `docs/testing/EVIDENCE_LOCAL.md` | testing | Harness (genérico) | Migrar como doc del harness |
| `docs/VALIDACIONES_Y_TESTS.md` | dev-flutter, testing | Proyecto Mi Taller | Queda en cada proyecto; skill apunta a `docs/` del consumidor |
| `docs/UI_UX_SUPABASE_CODING_PRACTICES.md` | ux, dev, supabase | Proyecto (mezcla) | Separar: prácticas genéricas → harness; tema/UI → proyecto |
| `docs/THEME_SYSTEM_UI_SETUP.md` | ux-flutter | Proyecto Mi Taller | Eliminar del harness; cada proyecto define su tema |
| `docs/ORDERS_ARCHITECTURE_PATTERNS.md` | architecture, dev | **Dominio Mi Taller** | **Eliminar** del harness |
| `docs/OFFLINE_FIRST_SYNC_PATTERN.md` | architecture, dev | Patrón de proyecto | Opcional por proyecto; no obligatorio en skill genérico |
| `docs/INVENTORY_SYSTEM.md` | architecture-adr | **Dominio Mi Taller** | **Eliminar** del harness |
| `database/sqlite/README.md` | database-postgres | Proyecto Mi Taller | Referencia local del consumidor |
| `supabase/functions/create-workshop-user/README.md` | supabase | **Dominio Mi Taller** | **Eliminar** del harness |
| `.cursor/FlutterArmy/skills-main/...` | reference.md (varios) | Ruta personal dev | Reemplazar por `examples/skills-main/` en Aquelarre o omitir |

---

## 6. Contenido específico Mi Taller — lista consolidada para eliminar o externalizar

### 6.1 Eliminar del harness (no aplica a proyectos genéricos)

| # | Elemento | Ubicación |
|---|----------|-----------|
| 1 | Prefijo y nombre `mitaller-*` | Todos los skills |
| 2 | Texto *"Mi Taller"* / *"dominio del taller"* | orchestration, po-product, README |
| 3 | `docs/ORDERS_ARCHITECTURE_PATTERNS.md` | architecture-adr, dev-flutter |
| 4 | `docs/INVENTORY_SYSTEM.md` | architecture-adr |
| 5 | `supabase/functions/create-workshop-user/README.md` | supabase |
| 6 | `SyncDateTimeMixin` / `shouldUseLocal` como obligatorio | architecture, dev, testing |
| 7 | Repositorios *inventario* y *órdenes* como ejemplos | dev-flutter/reference.md |
| 8 | `lib/common/widgets/custom_app_bar.dart` | ux-flutter/reference.md |
| 9 | Rutas `.cursor/FlutterArmy/skills-main/...` | 4 archivos reference.md |
| 10 | Patrones sync SQLite+Supabase como **regla obligatoria** en dev-flutter | dev-flutter SKILL.md |

### 6.2 Externalizar a documentación del proyecto consumidor (patrones válidos pero no universales)

| # | Elemento | Dónde debería vivir |
|---|----------|---------------------|
| 1 | Offline-first / online-first | `docs/architecture/` del proyecto o ADR |
| 2 | `docs/OFFLINE_FIRST_SYNC_PATTERN.md` | Proyecto que use sync local/remoto |
| 3 | `docs/THEME_SYSTEM_UI_SETUP.md` | Proyecto con design system propio |
| 4 | Patrón AppBar (elevation, fontSize, etc.) | `docs/ux/DESIGN_SYSTEM.md` del proyecto |
| 5 | `docs/VALIDACIONES_Y_TESTS.md` | Convenciones por repo |
| 6 | `database/sqlite/README.md` | Proyecto con cache SQLite |
| 7 | Ejemplos sync en `examples.md` | Reference del proyecto, no del harness |

### 6.3 Mantener en el harness Aquelarre (genérico probado)

| # | Elemento |
|---|----------|
| 1 | Sistema de gates 0–3 y supervisor PASS/FAIL |
| 2 | Formato TASK + estados + clasificación |
| 3 | Routing por type (feature/bug/chore/refactor/spike) |
| 4 | Artefactos condicionales Gate 1 (PO, UX, ADR, DB, SUPA, TEST) |
| 5 | TDD por defecto + override documentado |
| 6 | no code before task / branch before code |
| 7 | Refactor opt-in |
| 8 | Evidencia testing + carpeta gitignored |
| 9 | PR/trazabilidad TASK-ID |
| 10 | Proceso ADR (estructura, no patrones de dominio) |
| 11 | Proceso UX spec (estados UI, accesibilidad) |
| 12 | Proceso Supabase RLS/auth (sin funciones de dominio) |
| 13 | Proceso DB schema/migración/rollback |
| 14 | Smoke/Appium/MCP como evidencia opcional |

---

## 7. Brechas vs. visión Aquelarre (`docs/VISION.md`)

Skills que **existen** en mitaller y mapean a Aquelarre:

| mitaller-skills | aquelarre (VISION) | Estado |
|-----------------|-------------------|--------|
| workflow-orchestration | aquelarre-workflow-orchestration | ✅ Existe (renombrar) |
| scrum-master | aquelarre-scrum-master | ✅ Existe |
| po-product | aquelarre-po-product | ✅ Existe |
| architecture-adr | aquelarre-architecture-adr | ✅ Existe (limpiar dominio) |
| ux-flutter | aquelarre-ux-mobile | ⚠️ Parcial (solo mobile; falta tablet) |
| dev-flutter | aquelarre-dev-flutter | ✅ Existe (limpiar sync obligatorio) |
| database-postgres | aquelarre-database-postgres | ✅ Existe |
| supabase | aquelarre-supabase | ✅ Existe |
| testing | aquelarre-testing | ✅ Existe |
| github | aquelarre-github | ✅ Existe |
| refactor | aquelarre-refactor | ✅ Existe |

Skills en VISION que **no existen** en mitaller-skills:

| Skill Aquelarre | Notas |
|-----------------|-------|
| `aquelarre-discovery` | No hay fase discovery explícita en mitaller |
| `aquelarre-ux-tablet` | No diferenciado |
| `aquelarre-ux-web` | No existe (solo Flutter) |
| `aquelarre-dev-fastapi` | No existe |
| `aquelarre-dev-node` | No existe |
| `aquelarre-dev-react` | No existe |
| `aquelarre-docker` | No existe |
| `aquelarre-bitrise` | No existe (Mi Taller no documenta CI en skills) |
| `aquelarre-qa-automation` | Parcialmente cubierto en testing (Appium/MCP) |

Campos de clasificación en VISION ausentes en mitaller:

| Campo | En mitaller | En VISION |
|-------|-------------|-----------|
| `platform` | ❌ | mobile, tablet, web, backend |
| `ci` | ❌ | bitrise, docker, none |

---

## 8. Matriz de decisión por archivo

Leyenda: **M** = Migrar al harness · **L** = Limpiar contenido Mi Taller · **R** = Renombrar · **D** = Dejar en examples como referencia histórica · **C** = Crear nuevo

| Archivo | M | L | R | Notas |
|---------|---|---|---|-------|
| `README.md` | | ✅ | ✅ | Reescribir para Aquelarre |
| `mitaller-workflow-orchestration/SKILL.md` | ✅ | ✅ | ✅ | Núcleo del harness |
| `mitaller-scrum-master/SKILL.md` | ✅ | | ✅ | Casi listo |
| `mitaller-po-product/SKILL.md` | ✅ | ✅ | ✅ | Quitar "taller" |
| `mitaller-architecture-adr/SKILL.md` | ✅ | ✅ | ✅ | Quitar fuentes de dominio |
| `mitaller-architecture-adr/reference.md` | | ✅ | ✅ | Quitar SyncDateTime/inventario; o mover a proyecto |
| `mitaller-architecture-adr/examples.md` | ✅ | | ✅ | Formato ADR es genérico |
| `mitaller-ux-flutter/SKILL.md` | ✅ | ✅ | ✅ | Proceso sí; AppBar a reference opcional |
| `mitaller-ux-flutter/reference.md` | | ✅ | ✅ | Quitar custom_app_bar y FlutterArmy paths |
| `mitaller-ux-flutter/examples.md` | ✅ | | ✅ | Estados UI genéricos |
| `mitaller-dev-flutter/SKILL.md` | ✅ | ✅ | ✅ | Separar workflow de patrones sync |
| `mitaller-dev-flutter/reference.md` | | ✅ | ✅ | Mover sync a doc de proyecto |
| `mitaller-dev-flutter/examples.md` | | ✅ | | Mover a patrón offline-first del proyecto |
| `mitaller-database-postgres/SKILL.md` | ✅ | ✅ | ✅ | Quitar sqlite/README obligatorio |
| `mitaller-supabase/SKILL.md` | ✅ | ✅ | ✅ | Quitar create-workshop-user |
| `mitaller-testing/SKILL.md` | ✅ | ✅ | ✅ | Quitar sección sync específica |
| `mitaller-testing/reference.md` | ✅ | | ✅ | Evidencia local es genérica |
| `mitaller-github/SKILL.md` | ✅ | | ✅ | Listo |
| `mitaller-refactor/SKILL.md` | ✅ | | ✅ | Listo |
| `docs/AI_WORKFLOW_SKILLS_SPEC.md` | **C** | | | **No existe aún — crear desde Mi Taller** |

---

## 9. Recomendación de arquitectura del paquete Aquelarre

Para evitar repetir el acoplamiento actual:

```
aquelarre/
├── docs/
│   ├── VISION.md
│   ├── AI_WORKFLOW_SKILLS_SPEC.md     ← reglas G*, gates (del SPEC de Mi Taller)
│   └── MITALLER_SKILLS_INVENTORY.md   ← este documento
├── skills/                             ← fuente canónica (genérico)
│   ├── aquelarre-workflow-orchestration/
│   ├── aquelarre-scrum-master/
│   └── ...
├── templates/
│   ├── TASK.template.md
│   ├── EVIDENCE_LOCAL.md
│   └── .gitignore.testing-evidence
└── examples/
    └── mitaller-skills/                ← referencia histórica battle-tested (sin tocar aún)

# En cada proyecto consumidor (ej. Mi Taller):
mi-taller/
├── .cursor/skills/          ← copia de aquelarre/skills
├── .agents/skills/          ← copia de aquelarre/skills
└── docs/
    ├── architecture/
    │   ├── OFFLINE_FIRST_SYNC_PATTERN.md    ← específico del proyecto
    │   └── ORDERS_ARCHITECTURE_PATTERNS.md  ← específico del proyecto
    ├── ux/
    │   └── THEME_SYSTEM_UI_SETUP.md         ← específico del proyecto
    └── workflow/                            ← tasks del proyecto
```

**Regla de oro:** el skill del harness dice *cómo trabajar*; el `docs/` del proyecto dice *qué convenciones técnicas y de dominio aplicar*.

---

## 10. Orden sugerido de trabajo (sin ejecutar aún)

| Paso | Acción | Depende de |
|------|--------|------------|
| 1 | Migrar `AI_WORKFLOW_SKILLS_SPEC.md` a `aquelarre/docs/` | — (ya en examples) |
| 2 | Extraer templates del SPEC a `aquelarre/templates/` + `EVIDENCE_LOCAL.md` | Paso 1 |
| 3 | Migrar `rules/workflow-gate0-task-ready.mdc` (dual IDE) | Paso 1 |
| 4 | Migrar skills 100% genéricos: github, refactor, scrum-master, orchestration | Paso 1 |
| 5 | Limpiar skills con acoplamiento: dev-flutter, architecture, ux, supabase, testing | Paso 4 |
| 6 | Renombrar `mitaller-*` → `aquelarre-*` | Paso 5 |
| 7 | Dejar `examples/mitaller-skills/` intacto como snapshot histórico | — |
| 8 | Crear skills faltantes: discovery, bitrise, docker, ux-web, dev-* | VISION |

---

## 11. Conclusión (skills únicamente)

Ver **§16** para conclusión consolidada incluyendo SPEC, docs/ y rules/.

**¿Existe contenido específico de Mi Taller en los skills?** **Sí.** Concentrado en dev-flutter, architecture-adr, ux-flutter y referencias cruzadas.

**¿El harness es reutilizable?** **Sí**, especialmente con el SPEC ahora disponible en examples.

---

## 12. Análisis — `docs/AI_WORKFLOW_SKILLS_SPEC.md`

### 12.1 Veredicto: **~95% genérico — núcleo del harness Aquelarre**

~2000 líneas. No es documentación de dominio: es la especificación del workflow AI-driven. **Primer artefacto a migrar.**

### 12.2 Contenido genérico (migrar)

| Sección | Valor |
|---------|-------|
| Problema, principios, teoría Router/Supervisor | Identidad del harness |
| Convenciones: IDs, slugs, rutas, estados, branching | API del workflow |
| Gates 0–3 + reglas G0/G1/G2/G3 | Supervisor |
| Matriz routing BUG/FEATURE/CHORE/REFACTOR/SPIKE | Orquestador |
| Apéndice A + A.1 (YAML routing + heurísticas) | Validador futuro |
| Apéndices B–L + F + M | 12 plantillas listas |
| Template TASK inline (sección idx-template-task) | `templates/TASK.template.md` |

### 12.3 Ajustes menores al migrar

| Elemento | Acción |
|----------|--------|
| Solo "Desarrollo Flutter" en lista de skills | Ampliar stacks (FastAPI, React, Node) |
| UX template "Flutter + M3" | Variantes mobile/tablet/web |
| Heurísticas `lib/**/presentation/**` | Perfil `stack: flutter` |
| `bitrise.yml` en heurística `ci` | ✅ Ya alineado con VISION |
| Slug ejemplo `inventory-photo-flow` | Ejemplos neutros |
| IDs `TASK-123` vs `TASK-2026-031` en práctica | Decidir convención ID |

### 12.4 Prueba de vida real

Los ~35 TASKs en `docs/workflow/tasks/` siguen el template del SPEC: frontmatter YAML, secciones 1–11, links a ADR/SUPA/TEST. El formato es harness; el contenido es dominio taller.

---

## 13. Análisis — `rules/` (Cursor)

### 13.1 `workflow-gate0-task-ready.mdc` — ✅ GENÉRICO

- Enforcer Gate 0, `alwaysApply: true`
- Excepción: cambios solo en `docs/` o `.cursor/skills/`
- **Migrar** a Aquelarre; añadir `.agents/skills/` para Antigravity

### 13.2 `autorules.mdc` — ❌ MUY ESPECÍFICO Mi Taller

~350 líneas. A pesar del nombre, es la guía arquitectónica del proyecto:

| Específico | Ejemplo |
|------------|---------|
| Dominio | `ORDERS_ARCHITECTURE_PATTERNS`, módulo `orders/` |
| Widgets | `InventoryItemSelectionDialog`, `StatusBadgeWidget` |
| SQLite | `DatabaseConstants`, `fromSqliteMap`, upsert patterns |
| Obligatorio | offline-first / online-first como SIEMPRE |
| Bug | Footer duplicado corrupto (líneas 348–354) |

**No migrar al harness.**

### 13.3 `flutter-pro.mdc` — ⚠️ SEMI-GENÉRICO

Convenciones Dart/Flutter en inglés (SOLID, Freezed, Bloc, testing). Mezcla preferencias Mi Taller (getIt, Firebase, tablet, offline-first).

**Usar como insumo** para reference opcional; no como rule global del harness.

---

## 14. Catálogo `docs/` (resumen)

### Migrar al harness

- `AI_WORKFLOW_SKILLS_SPEC.md`
- `testing/EVIDENCE_LOCAL.md`
- `workflow/tasks/README.md`
- Templates del SPEC → `templates/`

### Semi-genérico (opcional por proyecto)

- `OFFLINE_FIRST_*`, `ONLINE_FIRST_WRITE_PATTERN.md`
- `VALIDACIONES_Y_TESTS.md` (mitad dominio CR fiscal)
- `UI_UX_SUPABASE_CODING_PRACTICES.md` (cita código orders/inventario)
- `testing/APPIUM_*`, `E2E-SMOKE-MATRIX.md` (estructura útil; datos son Mi Taller)

### Solo Mi Taller (no harness)

- `ORDERS_*`, `INVENTORY_*`, `THEME_*`, `cliente/`, `WORKSHOP_*`
- Setup ops: Firebase, Apple, Maps, FCM, Storage, ENVIRONMENT
- Todos los artefactos `TASK-*`, `UX-*`, `TEST-*`, `SUPA-*`, `ADR-*` reales

---

## 15. Prioridades consolidadas para Aquelarre

| P | Qué | Origen |
|---|-----|--------|
| 1 | AI_WORKFLOW_SKILLS_SPEC + templates + EVIDENCE_LOCAL | `docs/` |
| 2 | Rule Gate 0 (dual IDE) | `rules/workflow-gate0-task-ready.mdc` |
| 3 | Skills github, refactor, scrum-master, orchestration | skills/ |
| 4 | Skills limpiados (dev, arch, ux, supa, testing, po) | skills/ |
| 5 | Snapshot examples | `examples/mitaller-skills/` completo |
| — | NO migrar | autorules.mdc, docs dominio, artefactos reales |

---

## 16. Conclusión consolidada

**La joya del repo es `AI_WORKFLOW_SKILLS_SPEC.md`.** Ahí está el 80% del harness: gates, G*, routing YAML, plantillas, convenciones. Los 11 skills son roles ligeros; la rule Gate 0 refuerza en Cursor.

| Capa | Destino Aquelarre | Queda en Mi Taller |
|------|-------------------|---------------------|
| Workflow engine | SPEC + templates + gate0 rule | — |
| Skills (limpiados) | `aquelarre-*` | — |
| Referencia histórica | `examples/mitaller-skills/` | — |
| Dominio + código | — | ORDERS, INVENTORY, TASK-2026-*, autorules |

**Riesgo sin separación:** agente en FastAPI recibe `InventoryItemSelectionDialog`, `ready_for_pickup`, y SQLite obligatorio.

---

*Documento de análisis v1.1. **Limpieza 2026-09-01:** en `examples/mitaller-skills/` se conservaron solo `docs/AI_WORKFLOW_SKILLS_SPEC.md`, `docs/testing/EVIDENCE_LOCAL.md`, `docs/workflow/tasks/README.md` y `rules/workflow-gate0-task-ready.mdc`. El resto de `docs/` y `rules/` fue eliminado por ser específico de Mi Taller.*
