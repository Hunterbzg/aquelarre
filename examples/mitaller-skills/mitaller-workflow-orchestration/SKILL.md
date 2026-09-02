---
name: mitaller-workflow-orchestration
description: Orquesta el workflow AI-Driven de Mi Taller. Usa este skill cuando haya que enrutar un TASK, decidir skills a invocar, o validar gates (Gate 0/1/2/3) con reporte PASS/FAIL y reglas G*.
---

# Orquestacion del workflow (Routing + Supervisor)

Fuente principal: `docs/AI_WORKFLOW_SKILLS_SPEC.md`.

## Inputs

- Task en `docs/workflow/tasks/TASK-<id>-<slug>.md`.
- Etiquetas del task: `type`, `surface`, `risk`, `user_visible`, `db_change`, `tdd`.
- Opcional: cambios detectados en codigo/docs.

## Outputs

- `skills_plan`: cadena ordenada de skills a ejecutar.
- `gate_1_requirements`: artefactos requeridos antes de desarrollo.
- `overrides`: excepciones permitidas con justificacion.
- Reporte de validacion por gate (Supervisor).

## Routing

1. Leer el task y verificar que exista clasificacion minima.
2. Aplicar matriz del SPEC (bug/feature/chore/refactor/spike).
3. Construir `skills_plan` respetando:
   - no code before task
   - branch antes de codear
   - testing como gate
   - refactor solo opt-in
4. Generar `gate_1_requirements` segun condiciones (PO/UX/ADR/DB/SUPA/TEST).
5. Registrar justificacion corta por cada decision importante.

## Supervisor

Validar gates usando reglas G* del SPEC:

- Gate 0: existencia y calidad minima del TASK.
- Gate 1: plan tecnico + test plan + artefactos condicionales.
- Gate 2: implementacion y evidencia verificable.
- Gate 3: merge y cierre con trazabilidad.

## Formato de salida recomendado

```yaml
gate: "Gate 1 — Ready for Dev"
result: pass
violations: []
notes:
  - "No aplica UX: feature no user-visible."
```

Si hay fallas:

```yaml
gate: "Gate 1 — Ready for Dev"
result: fail
violations:
  - severity: blocker
    rule_id: G1-PO-001
    message: "Falta PRD/PO brief para feature user-visible."
    evidence:
      - "task.type=feature"
      - "task.user_visible=yes"
notes:
  - "Bloquear paso a implementacion hasta resolver blockers."
```
