# Workflow — Estado del proyecto

Resumen de gates, sprint y siguiente paso recomendado.

**Comando Antigravity:** `/status` (equivalente a “¿qué sigue?”)  
**Skill:** `aquelarre-workflow-orchestration`

## Pasos

### 1) Leer estado

- `docs/project-context.md`
- Sprint activo en `docs/workflow/sprints/`
- Tasks recientes en `docs/workflow/tasks/`

### 2) Inventario rápido

| Área | Pregunta |
|------|----------|
| Discovery | ¿Existe `DISCOVERY-*` aprobado? |
| Gate 1 | ¿Tasks en `ready` con artefactos linkeados? |
| Gate 2 | ¿Tasks en `in_review` con §9 completo? |
| Sprint | ¿Objetivo del sprint y carryover? |

### 3) Routing

Aplicar matriz del SPEC (Apéndice A) para el task activo o el siguiente trabajo propuesto.

### 4) Presentar al humano

```markdown
## Estado Aquelarre — <fecha>
- Gate 0: ✅ | 🟡 | ⬜
- Sprint: SPRINT-003 — N/M tasks done
- Task activo: TASK-042 (ready) — platform=backend
- Siguiente: /implement o completar UX en Gate 1
```

### 5) Recomendar comando o skill

Usar tabla en `docs/WORKFLOW_COMMANDS.md`.
