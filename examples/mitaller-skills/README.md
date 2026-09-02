# Skills de Mi Taller (referencia histórica → Aquelarre)

Prototipo battle-tested del workflow. **Copia canónica migrada** al harness Aquelarre:

| Antes (aquí) | Ahora (Aquelarre) |
|--------------|-------------------|
| `docs/AI_WORKFLOW_SKILLS_SPEC.md` | [`docs/AI_WORKFLOW_SKILLS_SPEC.md`](../../docs/AI_WORKFLOW_SKILLS_SPEC.md) |
| Apéndices / plantillas | [`templates/`](../../templates/) |
| `rules/workflow-gate0-task-ready.mdc` | [`rules/workflow-gate0-task-ready.mdc`](../../rules/workflow-gate0-task-ready.mdc) |
| `mitaller-*` skills | [`skills/aquelarre-*`](../../skills/README.md) (20 skills) |

Este folder se conserva como snapshot de referencia; no editar salvo consulta histórica.

## Contenido local restante

| Ruta | Propósito |
|------|-----------|
| `docs/AI_WORKFLOW_SKILLS_SPEC.md` | Copia histórica (ver canónica en `docs/`) |
| `docs/testing/EVIDENCE_LOCAL.md` | Copiada a `docs/testing/` del harness |
| `docs/workflow/tasks/README.md` | Convenciones de tasks |
| `mitaller-*/` | 11 skills originales (sin renombrar) |

> Se eliminó documentación específica del producto Mi Taller (órdenes, inventario, TASKs reales, etc.).

## Reglas de diseño (heredadas por Aquelarre)

- Skills en español; contrato: inputs, outputs, artefactos, gates.
- Solo estandarizar prácticas validadas; no promover TODOs como estándar.
