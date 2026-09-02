---
name: mitaller-scrum-master
description: Gestiona trabajo en unidades trazables del workflow. Usa este skill para crear, dividir o actualizar EPIC/STORY/TASK, y para mantener estados del task entre intake, ready, in_progress, in_review, blocked, done.
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

- Task creado/actualizado con formato canonico.
- Split de trabajo cuando el tamaño no es manejable.
- Estado del task actualizado con causa y siguiente paso.

## Instrucciones

1. Si no existe task, crear `TASK-<id>-<slug>.md` en `docs/workflow/tasks/`.
2. Completar minimo Gate 0:
   - problema, objetivo, no-alcance
   - AC
   - clasificacion (`type`, `surface`, `risk`, etc.)
3. Si el scope es grande, proponer division en subtasks y dependencias.
4. Verificar que cada task tenga links de trazabilidad (branch/PR/artefactos).
5. No mover a `ready` sin requisitos de Gate 1.
