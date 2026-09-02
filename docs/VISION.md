# Aquelarre — Visión y contexto del proyecto

> Documento maestro de contexto para el desarrollo del harness de agentes.
> Versión: 0.3 · Última actualización: 2026-09-01

---

## 1. Resumen ejecutivo

**Aquelarre** es un repositorio único, portable y reutilizable que funciona como el **ejército personal de agentes** para todos los proyectos de desarrollo. No es un producto final: es el **harness** (andamiaje operativo) que se descarga, integra o referencia desde cualquier proyecto para unificar el workflow de trabajo con IA.

El objetivo es eliminar la fragmentación entre chats, herramientas y convenciones ad hoc. Cada proyecto —móvil, backend, web o infraestructura— comparte el mismo ciclo de vida, los mismos artefactos de contexto y las mismas reglas de calidad, adaptándose al stack concreto mediante **skills** especializados.

**Principio rector:** ningún agente avanza sin contexto, sin artefactos y sin autorización humana cuando corresponde.

---

## 2. Problema que resuelve

Al trabajar en múltiples proyectos con agentes de IA se repiten siempre las mismas necesidades:

| Necesidad | Sin Aquelarre | Con Aquelarre |
|-----------|---------------|---------------|
| Entender el proyecto | Cada chat empieza de cero | Discovery documentado y persistente |
| Decidir cómo construir | Decisiones implícitas o perdidas | ADRs y análisis de arquitectura obligatorio |
| Organizar el trabajo | Notas dispersas | Epics, Stories y Tasks trazables (segundo cerebro) |
| Control de calidad | El agente codea sin restricciones | Gates que bloquean pasos inválidos |
| Verificar resultados | Confianza ciega en el output | TDD + testing automático + aprobación humana |
| Cambiar de chat o sesión | Pérdida de contexto | Artefactos en repo como fuente de verdad |
| Cambiar de IDE (Cursor ↔ Antigravity) | Skills y convenciones distintas por herramienta | Mismo paquete Aquelarre instalado en ambos entornos |

---

## 3. Stack tecnológico objetivo

Aquelarre debe soportar los stacks que se usan habitualmente. Los skills de desarrollo son **intercambiables por superficie**; el workflow y los gates son **comunes**.

### 3.1 Superficies de producto

| Superficie | Tecnología | Entorno / CI |
|------------|------------|--------------|
| App móvil | Flutter | **Bitrise** desde el inicio |
| App tablet | Flutter (layouts adaptativos) | **Bitrise** desde el inicio |
| Web | React | Docker desde el inicio |
| API / Backend | Python + FastAPI **o** Node.js | Docker desde el inicio |

> **Regla de plataforma:** móvil y tablet usan **Bitrise** (no Docker) para builds, tests en CI, artefactos y distribución. Web y backend usan **Docker** para entornos locales y despliegue.

### 3.2 Infraestructura y datos

| Capa | Tecnología |
|------|------------|
| Base de datos e infra | Supabase (Postgres, Auth, RLS, Storage, Edge Functions) |
| Diseño visual | Material Design 3 (móvil, tablet y web) |
| CI/CD móvil | Bitrise (workflows, stacks, code signing, distribución) |
| CI/CD web / backend | Docker + pipelines asociados al proyecto |

### 3.3 Implicaciones para el harness

- Los skills de **desarrollo** son por stack (`dev-flutter`, `dev-fastapi`, `dev-node`, `dev-react`).
- Los skills de **UX** son por superficie (`ux-mobile`, `ux-tablet`, `ux-web`), todos alineados a Material Design.
- Los skills de **infra** son transversales pero **por plataforma**:
  - `supabase`, `database-postgres` — todos los proyectos
  - `docker` — web y backend
  - `bitrise` — móvil y tablet (Flutter)
- El **orquestador** enruta según etiquetas del task (`surface`, `type`, `risk`, `platform`, etc.).

### 3.4 Bitrise en el stack móvil

Bitrise no es solo CI/CD: es parte del entorno operativo de los proyectos Flutter. El harness debe cubrir:

| Área | Qué gestiona el skill `aquelarre-bitrise` |
|------|-------------------------------------------|
| Workflows | `bitrise.yml`, steps, stacks (Android/iOS) |
| Builds | Debug, release, flavors/schemes |
| Tests en CI | Unit, widget, integration en pipeline |
| Artefactos | APK, AAB, IPA, build numbers |
| Code signing | Certificados, provisioning profiles (iOS) |
| Distribución | TestFlight, Play Store internal, Build Distribution |
| Evidencia Gate 2 | Link a build Bitrise PASS + artefactos descargables |
| Debugging CI | Logs de build fallido, reproducción local del step |

**Integración con agentes:** el MCP de Bitrise (disponible en el entorno de desarrollo) permite al agente consultar builds, logs, artefactos y disparar pipelines — el skill `aquelarre-bitrise` define *cuándo* y *cómo* usarlo dentro del workflow.

### 3.5 Entornos de agente (IDEs)

Aquelarre se usa activamente en **dos entornos de desarrollo con agentes**. El paquete debe dar soporte oficial a **ambos**, no elegir uno u otro.

| Entorno | Rol en el workflow | Ubicación de skills (proyecto) |
|---------|-------------------|-------------------------------|
| **[Cursor](https://cursor.com)** | IDE principal con agentes, skills, rules y MCP | `.cursor/skills/<skill>/SKILL.md` |
| **[Antigravity](https://antigravity.google)** | IDE alternativo de Google con agentes y skills (estándar abierto) | `.agents/skills/<skill>/SKILL.md` |

> Ambos consumen el mismo formato **Agent Skills** (`SKILL.md` + frontmatter `name`/`description`). El contenido del skill es **idéntico**; solo cambia la ruta donde cada IDE lo descubre.

#### Modelo de empaquetado: una fuente, dos destinos

El repo Aquelarre mantiene **una sola fuente canónica** de skills. La instalación en un proyecto consumidor despliega a las rutas que requiere cada IDE:

```
aquelarre/skills/                          ← fuente canónica (en el harness)
    aquelarre-workflow-orchestration/
        SKILL.md
            │
            ├── install → .cursor/skills/       (Cursor)
            └── install → .agents/skills/       (Antigravity)
```

**Contenido compartido (agnóstico al IDE):**

| Capa | Ubicación | Notas |
|------|-----------|-------|
| Skills | `skills/` en harness → copiados a ambos IDEs | Mismo `SKILL.md` en Cursor y Antigravity |
| Workflow y artefactos | `docs/workflow/`, `docs/discovery/`, etc. | Segundo cerebro; igual en cualquier IDE |
| Templates | `templates/` | TASK, ADR, UX, DISCOVERY |
| Gates y spec | `docs/AI_WORKFLOW_SKILLS_SPEC.md` | Reglas G* compartidas |

**Configuración por IDE (específica de cada herramienta):**

| Capa | Cursor | Antigravity |
|------|--------|-------------|
| Skills (destino) | `.cursor/skills/` | `.agents/skills/` |
| Rules / instrucciones persistentes | `.cursor/rules/` | Por definir (equivalente Antigravity) |
| MCP servers | Config MCP de Cursor | Config MCP de Antigravity |
| Skills globales (usuario) | `~/.cursor/skills/` | `~/.gemini/config/skills/` |

El instalador de Aquelarre (R7) debe aceptar `--ide cursor`, `--ide antigravity` o `--ide all` (default: **all**).

#### Principio de paridad

1. **Paridad funcional** — Todo skill de Aquelarre debe estar disponible en Cursor y Antigravity. No hay skills exclusivos de un IDE salvo wrappers de configuración.
2. **Paridad de workflow** — Gates, TASKs y artefactos funcionan igual sin importar el IDE activo.
3. **Sin lock-in** — Cambiar de Cursor a Antigravity (o viceversa) no debe rehacer discovery, arquitectura ni tasks; solo reinstalar o sincronizar skills.
4. **Detección en el skill orquestador** — El skill `aquelarre-workflow-orchestration` puede adaptar instrucciones menores (p. ej. rutas MCP) según el IDE detectado, pero el contrato de gates y artefactos no cambia.

#### Alcance Antigravity

| Producto | Soporte Aquelarre | Notas |
|----------|-------------------|-------|
| Antigravity IDE | ✅ Objetivo principal | `.agents/skills/` en el workspace |
| Antigravity CLI | 🔜 Evaluar | Ruta distinta (`~/.gemini/antigravity-cli/skills/`); posible target del instalador en fase posterior |

---

## 4. Principios de diseño

1. **Un solo lugar de verdad** — El repo del proyecto (o `.aquelarre/` integrado) contiene artefactos, tasks y evidencia. Los chats son vistas temporales; el repo es permanente.

2. **No code before task** — No se escribe código de producto sin un TASK activo, clasificado y aprobado en su gate correspondiente.

3. **Artefactos antes de implementación** — Discovery, requerimientos, arquitectura, UX y plan de pruebas existen *antes* de desarrollar, según aplique.

4. **TDD por defecto** — El desarrollo sigue Test-Driven Development salvo override justificado y documentado.

5. **Humano en el loop** — La autorización del usuario es el único criterio para dar por terminado algo que afecte al producto. Los agentes preparan; el humano valida.

6. **Gates explícitos** — Transiciones de fase con reglas verificables (PASS/FAIL), no convenciones blandas.

7. **Skills pequeños y composables** — Cada skill tiene contrato claro: inputs, outputs, artefactos y gates que aplica.

8. **Dual IDE: Cursor + Antigravity** — El paquete soporta ambos entornos de agente con paridad funcional. Skills y workflow compartidos; solo la ruta de instalación y la config MCP/rules varían por IDE.

9. **Español como idioma operativo** — Skills, artefactos de workflow y documentación interna en español.

10. **Solo patrones validados** — No promover código temporal, TODOs o prácticas frágiles como estándar del harness.

---

## 5. Modelo conceptual: agentes, roles y skills

Aquelarre no implica necesariamente un LLM por agente. Un **agente** es un **rol operativo** implementado como **skill** (o conjunto de skills) que el orquestador invoca según el task.

### 5.1 Mapa de roles

```
┌─────────────────────────────────────────────────────────────────┐
│                    ORQUESTADOR (Supervisor)                      │
│         Routing · Gates · Plan de skills · PASS/FAIL             │
└───────────────────────────┬─────────────────────────────────────┘
                            │
    ┌───────────────────────┼───────────────────────┐
    │                       │                       │
    ▼                       ▼                       ▼
┌─────────┐          ┌─────────────┐         ┌─────────────┐
│ FASE    │          │ FASE        │         │ FASE        │
│ PRE-DEV │          │ PLANIFICACIÓN│         │ POST-DEV    │
└────┬────┘          └──────┬──────┘         └──────┬──────┘
     │                      │                      │
     ▼                      ▼                      ▼
 Discovery            Scrum Master            Testing
 PO / Producto        Arquitectura            QA Automático
                      UX (móvil/tablet/web)   Bitrise (móvil CI)
                      Supabase / DB
```

### 5.2 Catálogo de skills (objetivo)

Basado en el prototipo `examples/mitaller-skills/`, extendido para Aquelarre:

| Skill | Rol | Fase |
|-------|-----|------|
| `aquelarre-workflow-orchestration` | Orquestador + Supervisor de gates | Transversal |
| `aquelarre-discovery` | Discovery inicial del proyecto o feature | Pre-dev |
| `aquelarre-scrum-master` | Epics, Stories, Tasks, estados | Planificación |
| `aquelarre-po-product` | Requerimientos, PRD, criterios de aceptación | Pre-dev / Gate 1 |
| `aquelarre-architecture-adr` | Análisis arquitectónico y ADRs | Pre-dev / Gate 1 |
| `aquelarre-ux-mobile` | Especificación UX Material (teléfono) | Gate 1 |
| `aquelarre-ux-tablet` | Especificación UX Material (tablet) | Gate 1 |
| `aquelarre-ux-web` | Especificación UX Material (web/React) | Gate 1 |
| `aquelarre-dev-flutter` | Implementación Flutter con TDD | Desarrollo |
| `aquelarre-dev-fastapi` | Implementación FastAPI con TDD | Desarrollo |
| `aquelarre-dev-node` | Implementación Node.js con TDD | Desarrollo |
| `aquelarre-dev-react` | Implementación React con TDD | Desarrollo |
| `aquelarre-supabase` | Auth, RLS, Storage, Edge Functions | Gate 1 / Dev |
| `aquelarre-database-postgres` | Esquema, migraciones, rendimiento | Gate 1 / Dev |
| `aquelarre-docker` | Contenedores, compose, entornos (web/backend) | Dev / Infra |
| `aquelarre-bitrise` | Workflows, builds, tests CI, signing, distribución (móvil/tablet) | Dev / CI / Entrega |
| `aquelarre-testing` | Plan de pruebas, evidencia, Gate 2 | Dev / QA |
| `aquelarre-qa-automation` | Pruebas realistas, reproducción de bugs | Post-dev / QA |
| `aquelarre-github` | Branch, PR, trazabilidad, merge | Entrega |
| `aquelarre-refactor` | Refactors opt-in con regresión | Dev (opt-in) |

> **Nota:** Los skills con prefijo `mitaller-*` en `examples/mitaller-skills/` son la **referencia v0** del proyecto Mi Taller. Aquelarre los generaliza y renombra.

---

## 6. Ciclo de vida del trabajo

### 6.1 Diagrama de fases

```
  IDEACIÓN          PLANIFICACIÓN           DESARROLLO           CIERRE
      │                   │                     │                  │
      ▼                   ▼                     ▼                  ▼
 ┌──────────┐      ┌──────────────┐      ┌────────────┐    ┌────────────┐
 │Discovery │ ──►  │ Arquitectura │ ──►  │    TDD     │ ──►│  Aprobación│
 │+ PO/Req  │      │ + UX + Tasks │      │Implementación│   │  humana    │
 └──────────┘      └──────────────┘      └────────────┘    └────────────┘
      │                   │                     │                  │
      │              ┌────┴────┐                │                  │
      │              │  GATES  │                ▼                  ▼
      │              │ 0 → 1   │           ┌────────────┐    ┌────────────┐
      └──────────────┤ 1 → 2   │           │  Testing   │    │ Merge /    │
                     │ 2 → 3   │           │ automático │    │ Gate 3     │
                     └─────────┘           └────────────┘    └────────────┘
```

### 6.2 Fase 0 — Discovery

**Objetivo:** Entender el proyecto, la problemática de negocio y el contexto antes de cualquier decisión técnica o de producto.

**Cuándo:** Al iniciar un proyecto nuevo, al incorporar Aquelarre a un codebase existente, o al abordar un dominio/feature desconocido.

**Responsable:** Skill `aquelarre-discovery` (con apoyo de `aquelarre-po-product` si hay visibilidad de usuario).

**Artefacto:** `docs/discovery/DISCOVERY-<id>-<slug>.md`

**Contenido mínimo:**

- Problema y oportunidad de negocio
- Usuarios y stakeholders
- Restricciones (tiempo, presupuesto, regulación, plataformas)
- Supuestos y preguntas abiertas
- Glosario del dominio
- Inventario del estado actual (si es codebase existente)
- Superficies involucradas (móvil, tablet, web, API)
- Riesgos identificados

**Salida:** Discovery aprobado por el humano → habilita análisis de arquitectura y creación de EPICs.

---

### 6.3 Fase 1 — Análisis de arquitectura

**Objetivo:** Definir *cómo* se construirá la solución antes de escribir código de producto.

**Cuándo:** Siempre antes del desarrollo. Obligatorio para proyectos nuevos; incremental para cambios en proyectos existentes.

**Responsable:** Skill `aquelarre-architecture-adr`

**Artefactos:**

- `docs/architecture/ADR-<nnn>-<slug>.md` — Architecture Decision Records
- `docs/architecture/OVERVIEW.md` — Vista general del sistema (opcional en proyectos pequeños)

**Contenido mínimo del ADR:**

- Contexto y decisión
- Alternativas consideradas
- Trade-offs
- Impacto en módulos/capas
- Riesgos y plan de rollback (si aplica)

**Dependencias (gate):**

- Para crear o actualizar ADRs de impacto estructural se requiere documento de requerimientos (PRD, PO brief o sección equivalente en el TASK).
- Cambios en `auth`, `db_change=schema|rls_policy` → ADR obligatorio.

---

### 6.4 Fase 2 — UX y especificaciones de interfaz

**Objetivo:** Definir la experiencia de usuario antes de implementar interfaces visibles.

**Cuándo:** Tasks con `user_visible=yes` y `surface` que incluya UI.

**Responsable:** Skill según superficie:

- `aquelarre-ux-mobile` — Flutter, form factor teléfono
- `aquelarre-ux-tablet` — Flutter, layouts adaptativos / breakpoints
- `aquelarre-ux-web` — React + Material Design web

**Artefacto:** `docs/ux/UX-<id>-<slug>.md`

**Contenido mínimo:**

- Estructura de pantalla/vista y componentes
- Estados UI: `loading`, `empty`, `error`, `success` / `loaded`
- Flujos de navegación e interacción
- Validaciones y mensajes de error
- Accesibilidad mínima (contraste, labels, targets táctiles)
- Tokens y tema Material Design (sin colores hardcodeados)

**Estándar visual:** Material Design 3 en las tres superficies.

---

### 6.5 Fase 3 — Organización del trabajo (Scrum adaptado)

**Objetivo:** Mantener el **segundo cerebro** del proyecto: contexto persistente, documentación viva y trazabilidad independiente del chat activo.

**Responsable:** Skill `aquelarre-scrum-master`

**Jerarquía de artefactos:**

```
EPIC-<id>-<slug>.md
  └── STORY-<id>-<slug>.md
        └── TASK-<id>-<slug>.md   ← unidad mínima de ejecución
```

**Ubicación:** `docs/workflow/epics/`, `docs/workflow/stories/`, `docs/workflow/tasks/`

**Estados del TASK:**

| Estado | Significado |
|--------|-------------|
| `intake` | Recién creado, incompleto |
| `ready` | Gate 1 aprobado, listo para desarrollo |
| `in_progress` | Desarrollo activo |
| `in_review` | PR abierto, pendiente revisión |
| `blocked` | Impedimento documentado |
| `done` | Gate 3 cerrado |

**Clasificación obligatoria del TASK (Gate 0):**

```yaml
type: feature | bug | chore | refactor | spike
surface: ui | api | auth | infra | db | mixed
platform: mobile | tablet | web | backend | mixed  # determina Bitrise vs Docker
risk: low | medium | high
user_visible: yes | no
db_change: none | query | schema | rls_policy | storage
tdd: on | off  # off requiere override justificado
ci: bitrise | docker | none  # derivado de platform; none requiere justificación
```

**Ceremonias adaptadas (ligeras, orientadas a agentes):**

- **Intake** — Convertir solicitud en TASK con clasificación mínima.
- **Refinement** — Completar artefactos de Gate 1 antes de `ready`.
- **Daily context** — Actualizar estado del task y bloqueos en el artefacto (no reunión).
- **Review** — Evidencia de Gate 2 + solicitud de aprobación humana.
- **Retro** — Lecciones aprendidas en el task o EPIC al cerrar.

---

### 6.6 Fase 4 — Desarrollo con TDD

**Objetivo:** Implementar el TASK con evidencia verificable de que el código hace lo correcto.

**Responsable:** Skill de desarrollo según stack (`aquelarre-dev-*`)

**Reglas:**

1. TASK en estado `ready` con Gate 1 PASS.
2. Branch creada antes de codear (`feature/TASK-<id>-<slug>` o convención del proyecto).
3. Ciclo TDD: red → green → refactor.
4. Cambios acotados al alcance del TASK.
5. Registro de implementación y decisiones en el TASK.
6. Entorno de ejecución según plataforma:
   - **Móvil / tablet (`platform: mobile|tablet`):** Bitrise configurado desde el inicio (`bitrise.yml` en repo, workflow con tests).
   - **Web / backend (`platform: web|backend`):** Docker disponible desde el inicio (`docker-compose.yml` o equivalente).

**Evidencia en el TASK:**

- Archivos modificados (referencia)
- Comandos de test ejecutados y resultado (local y/o CI)
- Decisiones técnicas relevantes
- Links a branch, commits y PR
- **Móvil/tablet:** link a build Bitrise (número, status, artefacto si aplica)
- **Web/backend:** evidencia de contenedor o pipeline Docker si aplica

---

### 6.7 Fase 5 — Testing automático y QA realista

**Objetivo:** Verificar el trabajo más allá de los tests unitarios; acercarse a condiciones reales y reproducir errores.

**Responsables:**

- `aquelarre-testing` — Plan de pruebas, cobertura según riesgo, evidencia Gate 2
- `aquelarre-qa-automation` — Pruebas de integración/E2E, smoke visual, Appium/MCP, reproducción de bugs

**Niveles de prueba según riesgo:**

| Riesgo | Mínimo esperado |
|--------|-----------------|
| `low` | Unit tests + lint |
| `medium` | Unit + integración en módulos tocados |
| `high` | Unit + integración + E2E o smoke manual documentado |

**Evidencia:**

- Resultados en el TASK o `docs/testing/TEST-<id>-<slug>.md`
- Capturas y artefactos pesados en `docs/testing/evidence/` (gitignored)
- Referencia a ruta local en el TASK (PASS/FAIL)

**Casos de uso del agente QA:**

- El usuario pide al agente de desarrollo que "pruebe como un usuario real"
- Reproducir un bug reportado paso a paso
- Validar flujos críticos post-implementación
- Smoke de regresión antes de merge
- **Móvil/tablet:** validar build Bitrise verde antes de solicitar aprobación humana

---

### 6.8 Fase 6 — Aprobación humana y cierre

**Objetivo:** Garantizar que un humano valida el resultado antes de darlo por terminado.

**Regla absoluta:** Ningún TASK pasa a `done` ni se hace merge sin **autorización explícita del usuario**.

**Flujo:**

1. Agente completa implementación + evidencia Gate 2.
2. Agente solicita revisión al humano con resumen ejecutivo.
3. Humano prueba manualmente (o delega pero confirma).
4. Humano autoriza → merge permitido → Gate 3 → `done`.
5. Humano rechaza → TASK vuelve a `in_progress` o `blocked` con feedback documentado.

El orquestador **no** puede auto-aprobar Gate 3.

---

## 7. Sistema de Gates

Los gates son **puntos de control verificables**. El orquestador actúa como supervisor y emite reportes PASS/FAIL.

### 7.1 Resumen de gates

| Gate | Nombre | ¿Qué habilita? |
|------|--------|----------------|
| **Gate 0** | Task válido | Clasificar y estructurar el trabajo |
| **Gate 1** | Ready for Dev | Pasar TASK a `ready` e iniciar desarrollo |
| **Gate 2** | Ready for Review | Abrir PR / solicitar aprobación humana |
| **Gate 3** | Done | Merge y cierre del TASK |

### 7.2 Gate 0 — Task válido

**Bloquea:** Cualquier desarrollo sin TASK.

**Requisitos:**

- [ ] Archivo `TASK-<id>-<slug>.md` existe
- [ ] Problema, objetivo y no-alcance definidos
- [ ] Criterios de aceptación (AC) presentes
- [ ] Clasificación completa (`type`, `surface`, `platform`, `risk`, `user_visible`, `db_change`, `tdd`, `ci`)
- [ ] Link a STORY o EPIC padre (si aplica)

### 7.3 Gate 1 — Ready for Dev

**Bloquea:** Código de producto, branches de feature sin plan.

**Requisitos base (siempre):**

- [ ] Gate 0 PASS
- [ ] Plan de pruebas definido (en TASK o TEST-*)
- [ ] Branch strategy definida

**Requisitos condicionales:**

| Condición | Artefacto requerido |
|-----------|---------------------|
| `type=feature` + `user_visible=yes` | PRD / PO brief |
| `surface` incluye `ui` + `user_visible=yes` | UX spec |
| `risk=high` o cambio estructural | ADR |
| `db_change=schema` | Plan de migración + rollback |
| `db_change=rls_policy` o `surface=auth` | Spec Supabase (roles, permisos) |
| Proyecto nuevo o dominio nuevo | Discovery aprobado |
| `platform=mobile|tablet` (proyecto nuevo) | `bitrise.yml` con workflow mínimo (build + test) |
| `platform=web|backend` (proyecto nuevo) | `docker-compose.yml` o equivalente |

### 7.4 Gate 2 — Ready for Review

**Bloquea:** Solicitud de merge sin evidencia.

**Requisitos:**

- [ ] Implementación acotada al TASK
- [ ] Tests ejecutados con resultado PASS (o N/A justificado)
- [ ] Lint/formato según proyecto
- [ ] TASK actualizado con evidencia
- [ ] PR abierto con trazabilidad al TASK-ID
- [ ] **Móvil/tablet:** build Bitrise PASS linkeado en el TASK (o justificación documentada)
- [ ] **Web/backend:** tests en Docker/local PASS (o justificación documentada)

### 7.5 Gate 3 — Done

**Bloquea:** Cierre automático.

**Requisitos:**

- [ ] Aprobación humana explícita documentada en el TASK
- [ ] PR mergeado (o decisión de no-merge documentada)
- [ ] Estado del TASK = `done`
- [ ] Artefactos de trazabilidad completos

### 7.6 Formato de reporte del supervisor

```yaml
gate: "Gate 1 — Ready for Dev"
task_id: "TASK-042-login-screen"
result: fail
violations:
  - severity: blocker
    rule_id: G1-UX-001
    message: "Falta UX spec para feature user-visible con surface=ui."
    evidence:
      - "task.user_visible=yes"
      - "task.surface=ui"
notes:
  - "Invocar aquelarre-ux-mobile antes de pasar a ready."
```

---

## 8. Matriz de routing (orquestador)

El orquestador construye un `skills_plan` según la clasificación del TASK.

| type | Skills típicos (orden) |
|------|------------------------|
| `feature` | po-product → architecture-adr → ux-* → testing (plan) → dev-* → bitrise/docker (CI) → testing (evidencia) → github |
| `bug` | testing (repro) → dev-* → bitrise/docker (CI) → testing (regresión) → github |
| `chore` | dev-* → bitrise (móvil) o docker (web/backend) → testing (si aplica) → github |
| `refactor` | refactor → architecture-adr (si boundaries) → testing → dev-* → bitrise/docker → github |
| `spike` | discovery o architecture-adr → documentar hallazgos (sin merge de código productivo) |

**Reglas de routing:**

- `refactor` es **opt-in** — no se ejecuta sin `type=refactor` explícito.
- `ux-*` solo si `user_visible=yes` y hay superficie UI.
- `aquelarre-supabase` si `surface=auth` o `db_change` incluye RLS/storage.
- `aquelarre-bitrise` si `platform=mobile|tablet` o `ci=bitrise`.
- `aquelarre-docker` si `platform=web|backend` o `ci=docker`.
- `aquelarre-qa-automation` bajo demanda del usuario o si `risk=high`.

---

## 9. Estructura de carpetas del harness

### 9.1 En el repo Aquelarre (el harness)

```
aquelarre/
├── README.md
├── docs/
│   └── VISION.md              ← este documento
├── skills/                    ← fuente canónica de skills (futuro)
│   ├── aquelarre-workflow-orchestration/
│   ├── aquelarre-discovery/
│   ├── aquelarre-scrum-master/
│   ├── aquelarre-bitrise/
│   └── ...
├── install/                   ← scripts de instalación dual IDE (futuro)
│   ├── install.ps1
│   └── install.sh
├── templates/                 ← plantillas de artefactos (futuro)
│   ├── TASK.template.md
│   ├── ADR.template.md
│   ├── UX.template.md
│   └── DISCOVERY.template.md
└── examples/                  ← referencias y prototipos
    ├── mitaller-skills/
    ├── BMAD-METHOD-main/
    └── skills-main/
```

### 9.2 Integrado en un proyecto consumidor

```
mi-proyecto-flutter/           ← móvil / tablet
├── .cursor/skills/            ← Cursor: skills de Aquelarre
├── .agents/skills/            ← Antigravity: mismos skills (paridad)
├── docs/ ...
├── lib/
├── bitrise.yml
└── supabase/

mi-proyecto-web/               ← web / backend
├── .cursor/skills/
├── .agents/skills/
├── docs/ ...
├── src/
├── docker-compose.yml
└── supabase/
```

> En ambos IDEs los skills son copias del mismo contenido. Los artefactos de workflow (`docs/`) son la fuente de verdad compartida.

---

## 10. Contrato de un skill Aquelarre

Cada skill sigue el formato estándar de Agent Skills:

```markdown
---
name: aquelarre-<nombre>
description: <Cuándo usar este skill — una oración clara con triggers>
---

# Título

## Objetivo
## Inputs
## Outputs
## Artefactos producidos o consumidos
## Gates que aplica
## Instrucciones
## Ejemplos (opcional)
## Referencias (opcional)
```

**Reglas:**

- Frontmatter obligatorio: `name`, `description`.
- Descripción orientada a descubrimiento automático por el agente.
- Referencias externas como `reference.md` interno, no dependencias operativas directas.
- `examples.md` para patrones concretos del stack.

---

## 11. Integración con proyectos existentes

### 11.1 Proyecto nuevo

1. Crear repo del proyecto con la plataforma CI correcta desde el inicio:
   - **Flutter (móvil/tablet):** `bitrise.yml` + app conectada en Bitrise.
   - **Web / backend:** `docker-compose.yml` (o Dockerfile equivalente).
2. Instalar Aquelarre en **ambos IDEs** del proyecto:
   - Cursor → `.cursor/skills/`
   - Antigravity → `.agents/skills/`
   - (Futuro: `install.ps1 --ide all` desde el paquete Aquelarre)
3. Ejecutar **Discovery** (`aquelarre-discovery`).
4. Crear `docs/architecture/OVERVIEW.md` y ADRs iniciales.
5. Crear EPIC de arranque y primeros TASKs.
6. Desarrollar siguiendo gates.

### 11.2 Proyecto existente (brownfield)

1. Instalar Aquelarre.
2. Discovery enfocado en inventario: estructura, deuda, convenciones actuales.
3. Documentar arquitectura *como está* antes de cambiar.
4. A partir de ahí, todo cambio entra por TASK + gates.

### 11.3 Mecanismo de instalación (por definir)

Opciones a evaluar en tareas futuras:

- Script `install.sh` / `install.ps1` con flags `--ide cursor|antigravity|all` que copia skills y templates a las rutas correctas de cada IDE.
- Paquete npm/pip publicable.
- Submodule git.
- Comando `npx skills add` con targets para Cursor y Antigravity (cuando el estándar lo soporte de forma uniforme).

**Comportamiento esperado del instalador:**

```bash
# Instalar en ambos IDEs (default)
./install.ps1 --target ../mi-proyecto

# Solo un IDE
./install.ps1 --target ../mi-proyecto --ide cursor
./install.ps1 --target ../mi-proyecto --ide antigravity
```

---

## 12. Relación con referencias del repo

| Referencia | Qué aporta a Aquelarre |
|------------|------------------------|
| `examples/mitaller-skills/` | Prototipo funcional v0: orquestación, gates G*, scrum, skills Flutter/Supabase. Base directa para migrar a `aquelarre-*`. |
| `examples/BMAD-METHOD-main/` | Inspiración en workflow multi-fase, planning skills, autonomous loops, project context theory. |
| `examples/skills-main/` | Formato y distribución de skills oficiales Flutter; patrón de instalación. |

---

## 13. Fuera de alcance (v0.1)

Para mantener foco en las primeras iteraciones:

- UI web del harness (dashboard de tasks).
- Integración CI/CD automática de gates en Bitrise/Docker (solo documentación y skills por ahora; MCP Bitrise disponible para consultas manuales).
- Multi-tenant o trabajo en equipo distribuido.
- Skills para stacks no listados (Kotlin nativo, Go, etc.).
- Agentes con memoria externa fuera del repo.

---

## 14. Roadmap sugerido

| Fase | Entregable |
|------|------------|
| **R0** | Este documento + README raíz |
| **R1** | Spec formal de gates (`AI_WORKFLOW_SKILLS_SPEC.md`) migrado desde mitaller |
| **R2** | Templates de artefactos (TASK, ADR, UX, DISCOVERY) |
| **R3** | Skills core: orquestación, scrum-master, discovery, po-product, architecture |
| **R4** | Skills de desarrollo: Flutter, FastAPI, React |
| **R5** | Skills UX: mobile, tablet, web |
| **R6** | Skills testing + qa-automation + bitrise |
| **R7** | Script de instalación dual IDE (Cursor + Antigravity) |
| **R8** | Piloto en un proyecto real end-to-end |

---

## 15. Glosario

| Término | Definición |
|---------|------------|
| **Harness** | Conjunto de skills, templates, gates y convenciones que guían a los agentes. |
| **Skill** | Archivo `SKILL.md` con instrucciones que el agente lee y ejecuta. |
| **Gate** | Punto de control con requisitos verificables antes de avanzar de fase. |
| **TASK** | Unidad mínima de trabajo ejecutable por un agente. |
| **ADR** | Architecture Decision Record — documento de decisión técnica. |
| **TDD** | Test-Driven Development — escribir test antes que implementación. |
| **Superficie** | Tipo de producto o capa: UI móvil, UI web, API, auth, etc. |
| **Plataforma** | Clasificación del task que determina stack CI: `mobile`, `tablet`, `web`, `backend`. |
| **Bitrise** | Plataforma CI/CD para proyectos Flutter (móvil/tablet): builds, tests, signing, distribución. |
| **Cursor** | IDE con agentes de IA; descubre skills en `.cursor/skills/`. Entorno de agente soportado por Aquelarre. |
| **Antigravity** | IDE de Google con agentes de IA; descubre skills en `.agents/skills/`. Entorno de agente soportado por Aquelarre. |
| **Segundo cerebro** | Conjunto de artefactos en repo que preservan contexto entre sesiones. |

---

## 16. Decisiones pendientes

Registrar aquí las decisiones que se tomarán en tareas futuras:

- [ ] ¿Prefijo de skills: `aquelarre-*` o configurable por proyecto?
- [x] ¿Ubicación de skills? → Fuente canónica en `skills/` del harness; instalación dual en `.cursor/skills/` (Cursor) y `.agents/skills/` (Antigravity).
- [ ] ¿Rules de Cursor (`.cursor/rules/`) vs equivalente Antigravity: plantillas compartidas o por IDE?
- [ ] ¿Instalador sincroniza skills en cada `git pull` del harness o es manual?
- [ ] ¿Un solo `AI_WORKFLOW_SKILLS_SPEC.md` o spec dividido por fase?
- [ ] ¿Cómo versionar el harness respecto a proyectos consumidores?
- [ ] ¿Integración con MCP (Bitrise, Appium, Supabase MCP, Dart MCP) como parte de los skills bitrise y qa-automation?
- [ ] ¿Workflow Bitrise estándar compartido entre proyectos Flutter o uno por repo?
- [ ] ¿Steps mínimos obligatorios en `bitrise.yml` (analyze, test, build) para Gate 1?
- [ ] ¿Reglas de override de gates: quién puede, cómo se documenta?

---

*Este documento es la fuente de verdad del **por qué** y el **qué** de Aquelarre. Las especificaciones técnicas detalladas (reglas G*, templates, skills individuales) se derivarán de aquí en documentos y archivos concretos.*
