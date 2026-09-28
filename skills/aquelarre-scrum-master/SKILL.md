---
name: aquelarre-scrum-master
description: Gestiona trabajo en unidades trazables del workflow Aquelarre. Usa este skill para crear, dividir o actualizar EPIC/STORY/TASK, y para mantener estados del task entre intake, ready, in_progress, in_review, blocked, done y cancelled.
---

# Scrum Master (workflow)

Fuente: `docs/AI_WORKFLOW_SKILLS_SPEC.md`.

## Objetivo

Convertir solicitudes en trabajo ejecutable y trazable, sin iniciar codigo fuera de task.

## Inputs

- Solicitud del usuario o problema reportado.
- Contexto de dependencias y alcance.
- Artefactos existentes (EPIC/STORY/TASK).

## Outputs

- Task creado o actualizado con formato canonico.
- Division de trabajo cuando el tamano no es manejable.
- Estado del task actualizado con causa y siguiente paso.

## Gates que aplica

- **Gate 0:** crear o completar task minimo antes de cualquier implementacion.
- **Gate 1:** verificar artefactos requeridos antes de mover a `ready`.

## Instrucciones

1. Si no existe task, crear `TASK-<id>-<slug>.md` en `docs/workflow/tasks/`.
2. Completar minimo Gate 0 en el task:
   - problema, objetivo, no-alcance
   - criterios de aceptacion (AC)
   - clasificacion en frontmatter o seccion 4:
     - `type`: feature | bug | chore | refactor | spike
     - `surface`: ui | domain | data | db | auth | infra | ci | docs
     - `platform`: mobile | tablet | web | backend | mixed
     - `risk`: low | medium | high
     - `user_visible`: yes | no
     - `db_change`: none | query | schema | rls_policy | storage
     - `tdd`: on | off (off requiere justificacion)
     - `ci`: bitrise | docker | none (derivado de platform cuando aplique)
3. Si el scope es grande, proponer EPIC/STORY y dividir en tasks con dependencias (`depends_on`, `blocks`).
   - **REGLA CRÍTICA DE JERARQUÍA:** Los Tasks NUNCA se asignan directamente a un Epic. La jerarquía obligatoria es: `Epic → Story → Task`. Si no hay una Story que agrupe los tasks, crear una antes de crear los tasks.
   - **Epics Técnicas (sin usuario final):** Usar el formato *"As a developer, I want... so that..."* para sus Stories. NO omitir la Story aunque sea infraestructura.
4. Verificar trazabilidad: links a branch, PR, PRD, UX, ADR, TEST, DB, Supabase cuando existan.
5. **Al hacer desglose de pantallas (Visual Refinement)**:
   - Analizar dependencias visuales e interacciones para proponer Epics y Stories.
   - Proponer el desglose en el chat primero. **NO CREAR los archivos** hasta que el humano apruebe o ajuste la propuesta.
6. No mover a `ready` sin cumplir requisitos de Gate 1 (orquestador valida).
7. Actualizar `status` y `updated_at` en cada transicion; documentar causa si `blocked`.

## Estados permitidos

`intake` → `ready` → `in_progress` → `in_review` → `done` | `cancelled` | `blocked`

## Artefactos

| Tipo | Ruta canonica |
|------|----------------|
| Task | `docs/workflow/tasks/TASK-<id>-<slug>.md` |
| Story | `docs/workflow/stories/STORY-<id>-<slug>.md` |
| Epic | `docs/workflow/epics/EPIC-<id>-<slug>.md` |
| Sprint | `docs/workflow/sprints/SPRINT-<id>-<slug>.md` |

Rutas y migración desde mitaller-be: `docs/ARTIFACT_PATHS.md`.
