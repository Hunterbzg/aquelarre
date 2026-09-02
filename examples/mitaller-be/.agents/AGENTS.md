# AI SDLC Factory — Global Rules & Agent Router

Este archivo define las reglas globales, el patrón de routing y las restricciones de gobernanza para el workflow de desarrollo AI SDLC Factory.

---

## Agent Router — Clasificación de Intención

Al recibir una solicitud del usuario, clasifica la intención en una de las siguientes categorías y activa el skill correspondiente. Si la solicitud es ambigua, pregunta al usuario antes de proceder.

### 1. PRODUCT_WORK → Activar skill `product-agent`

Activar cuando la solicitud involucra:
- Sesiones de discovery, análisis de negocio, exploración de dominio
- Creación de PRD, definición de features, gathering de requerimientos
- Decisiones de arquitectura, modelado de datos, diseño de contratos de API
- Creación de Epics, Stories, Tasks; story mapping; gestión de backlog
- Planificación de sprints, priorización, estimación
- Validación de Quality Gates 0, 1 y 2

### 2. CODING_WORK → Activar skill `coding-agent`

Activar cuando la solicitud involucra:
- Escritura de código de aplicación (endpoints, modelos, servicios, repositorios)
- Escritura de tests (unitarios, integración, e2e)
- Ejecución del ciclo TDD (Red-Green-Refactor)
- Configuración de Docker (Dockerfile, docker-compose)
- Integración con base de datos / Supabase
- Calidad de código (linting, type checking, formatting)
- Verificación de Definition of Done (DoD) — Gate 3

### 3. ORCHESTRATION → Activar skill `orchestrator`

Activar cuando la solicitud involucra:
- "¿Qué debemos hacer ahora?" / "¿Cuál es el siguiente paso?"
- "¿Cuál es el estado del proyecto?"
- "¿En qué quality gate estamos?"
- "Ayúdame a entender el workflow"
- Navegación general del proyecto y orientación

### 4. WORKFLOW_TRIGGER → Ejecutar workflow correspondiente

Activar cuando el usuario explícitamente invoca un comando de workflow (`/onboarding`, `/discovery`, `/prd`, `/architecture`, `/sprint-plan`, `/implement`, `/review`) o cuando el contexto claramente corresponde a una fase específica del pipeline.

### 5. DIRECT_RESPONSE → Responder directamente (Bypass de Workflow)

Activar cuando la solicitud involucra:
- Preguntas generales, teóricas o de investigación
- Aclaración de dudas o conversación casual
- El usuario pide explícitamente "sin workflow", "pregunta directa", o "no uses el workflow"
- Debugging o troubleshooting no relacionado al trabajo actual del proyecto
*(Nota: En este modo NO se aplican quality gates ni se generan artefactos versionados)*

### 6. DOC_CRAWLER → Activar skill `doc-crawler`

Activar cuando la solicitud involucra:
- Descargar, raspar, hacer "crawl" o "scrape" de documentación externa o APIs
- El usuario provee una URL para aprender cómo usar una herramienta
- Extracción de información de un sitio web para usarla en el proyecto

### Workflows

Los archivos en `.agents/workflows/` contienen instrucciones procedurales paso a paso. No se auto-descubren por frontmatter. Al detectar una intención WORKFLOW_TRIGGER o al recomendar un workflow, el agente DEBE leer el archivo correspondiente de `.agents/workflows/` y seguir sus pasos exactamente.

Workflows disponibles: `onboarding.md`, `discovery.md`, `prd.md`, `architecture.md`, `sprint-plan.md`, `implement.md`, `review.md`.

---

## Reglas de Gobernanza (Aplican a categorías 1-4)

> **IMPORTANTE**: Las siguientes reglas aplican SOLO cuando la intención clasificada es PRODUCT_WORK, CODING_WORK, ORCHESTRATION, o WORKFLOW_TRIGGER. En modo DIRECT_RESPONSE estas reglas NO se aplican — el agente responde libremente sin quality gates ni artefactos versionados.

### Enforcement de Quality Gates

```
Gate 0 (Discovery)    → DEBE pasarse ANTES de crear PRD o documentos de arquitectura
Gate 1a (PRD)         → DEBE pasarse ANTES de crear documentos de arquitectura
Gate 1b (ADR)         → DEBE pasarse ANTES de crear stories o tasks
Gate 2 (DoR por Task) → DEBE pasarse para cada Task ANTES de escribir código
Gate 3 (User Approval)→ DEBE pasarse para cada Task ANTES de avanzar a la siguiente
```

**Violación de gates**: Si se detecta un intento de saltar un quality gate, el agente DEBE:
1. Informar al usuario qué gate no se ha completado
2. Recomendar el workflow correspondiente para completar el gate
3. NEGARSE a proceder hasta que el gate sea completado y aprobado

### Versionado de Artefactos (Estilo BMAD)

- Todos los artefactos DEBEN seguir versionado BMAD: `nombre-v1.md`, `nombre-v2.md`, etc.
- Cada grupo de artefactos tiene su propia carpeta bajo `docs/`:
  - `docs/discovery/` — Artefactos de discovery
  - `docs/product/` — PRD, modelo de dominio
  - `docs/architecture/` — ADRs, data model, API contracts
  - `docs/backlog/` — Backlog index, epics, stories
  - `docs/sprints/` — Sprint plans y tasks
- Al actualizar un artefacto, crear una nueva versión y mantener versiones anteriores
- El archivo más reciente siempre es la versión activa

### Persistencia de Contexto

- Después de completar cualquier fase de workflow, ACTUALIZAR `docs/project-context.md`
- Todos los agentes DEBEN leer `docs/project-context.md` al inicio de cualquier sesión
- Referenciar artefactos relevantes por ruta de archivo en todas las discusiones
- Usar links clickeables al referenciar archivos: `[nombre](file:///ruta/al/archivo)`

### Cadencia Scrum

- **Sprint Planning** → **Desarrollo** (Task por Task con TDD) → **Sprint Review**
- No hay ceremonia de retrospectiva — las mejoras al workflow se manejan como tareas regulares
- Tracking de progreso via archivos de sprint plan con checkboxes de estado
- Cada sprint tiene su propia carpeta: `docs/sprints/sprint-NNN/`

### Human-in-the-Loop

- Presentar resultados y pedir aprobación explícita en CADA Quality Gate
- NUNCA asumir aprobación — esperar confirmación explícita del usuario
- Cuando haya duda, preguntar por clarificación en lugar de asumir
- Marcar claramente los puntos de decisión que requieren input humano

### Idioma de Artefactos

- Al inicio de cada nuevo proyecto (durante onboarding), preguntar al usuario su idioma preferido para artefactos (Español / English)
- Usar el idioma seleccionado consistentemente en todos los artefactos generados
- Comentarios de código e identificadores técnicos SIEMPRE en inglés
- Mapear la respuesta del usuario y persistirla en `project-context.md`

### No Code Without Context

- NUNCA escribir **código de features de producción nuevo** sin un archivo de Task que cumpla con la Definition of Ready (DoR)
- NUNCA saltear el ciclo TDD — tests DEBEN escribirse ANTES de la implementación
- NUNCA avanzar a la siguiente fase sin pasar el Quality Gate correspondiente
- SIEMPRE verificar que existen los artefactos prerequisito antes de empezar una fase

**Excepciones permitidas** (no requieren Task con DoR):
- Fixes/debugging de código existente
- Código de ejemplo, exploración o prototipo
- Configuración de infraestructura (Docker, CI/CD, config files)
- Refactoring solicitado directamente por el usuario

### Session Start

- Al inicio de cada sesión, si el usuario no tiene una solicitud específica, leer `docs/project-context.md` y presentar un breve resumen del estado actual y el siguiente paso recomendado
- Si el usuario abre con una solicitud directa, clasificar la intención y proceder sin dashboard automático

---

## Stack Técnico de la Fábrica

Esta fábrica está diseñada para producir backends con:
- **Lenguaje**: Python 3.11+
- **Framework**: FastAPI (async, OpenAPI auto-docs)
- **Validación**: Pydantic v2
- **Base de Datos**: Supabase (PostgreSQL) o PostgreSQL directo
- **Testing**: pytest, pytest-asyncio, pytest-cov, respx
- **Calidad**: ruff (linter + formatter), mypy (type checking)
- **Contenedores**: Docker + Docker Compose
- **Arquitectura**: Clean Architecture / Layered Architecture

Los patrones técnicos específicos están documentados en los resources del `coding-agent` skill.
