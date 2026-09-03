# Skills — Aquelarre (fuente canónica)

Carpeta de trabajo principal del harness. Aquí viven los **skills limpiados y nuevos** antes de instalarse en proyectos consumidores.

## Rol en el repo

```
examples/mitaller-skills/     ← prototipo battle-tested (referencia, no tocar salvo consulta)
        │
        │  limpieza + renombre mitaller-* → aquelarre-*
        ▼
skills/                       ← ESTA CARPETA (fuente canónica del harness)
        │
        │  instalación (futuro: install.ps1 --ide all)
        ▼
proyecto-consumidor/
├── .cursor/skills/             ← Cursor
└── .agents/skills/             ← Antigravity
```

**Regla:** todo skill que forme parte del paquete Aquelarre se crea o migra aquí. `examples/` queda como snapshot histórico.

## Estructura por skill

Cada skill es un directorio con al menos `SKILL.md`:

```
skills/
├── aquelarre-<nombre>/
│   ├── SKILL.md          # obligatorio (frontmatter name + description)
│   ├── reference.md      # opcional — patrones ampliados
│   └── examples.md       # opcional — casos concretos genéricos
```

### Contrato mínimo (`SKILL.md`)

```markdown
---
name: aquelarre-<nombre>
description: <Cuándo usar este skill — triggers claros para el agente>
---

# Título

## Objetivo
## Inputs
## Outputs
## Artefactos producidos o consumidos
## Gates que aplica
## Instrucciones
```

- Idioma operativo: **español**.
- Referencias al workflow: `docs/AI_WORKFLOW_SKILLS_SPEC.md` (cuando exista en `aquelarre/docs/`).
- **No** incluir dominio de un proyecto concreto (órdenes, inventario, widgets específicos, etc.).

## Catálogo objetivo y estado de migración

| Skill | Origen (`mitaller-*`) | Estado |
|-------|------------------------|--------|
| `aquelarre-workflow-orchestration` | workflow-orchestration | listo |
| `aquelarre-discovery` | — (nuevo) | listo |
| `aquelarre-scrum-master` | scrum-master | listo |
| `aquelarre-po-product` | po-product | listo |
| `aquelarre-architecture-adr` | architecture-adr | listo |
| `aquelarre-ux-mobile` | ux-flutter | listo |
| `aquelarre-ux-tablet` | — (nuevo) | listo |
| `aquelarre-ux-web` | — (nuevo) | listo |
| `aquelarre-dev-flutter` | dev-flutter | listo |
| `aquelarre-dev-fastapi` | — (nuevo) | listo |
| `aquelarre-dev-node` | — (nuevo) | listo — enriquecido (TDD, arquitectura Node) |
| `aquelarre-dev-react` | — (nuevo) | listo |
| `aquelarre-database-postgres` | database-postgres | listo |
| `aquelarre-supabase` | supabase | listo |
| `aquelarre-docker` | — (nuevo) | listo |
| `aquelarre-bitrise` | — (nuevo) | listo |
| `aquelarre-testing` | testing | listo |
| `aquelarre-qa-automation` | parcial en testing | listo — router opt-in |
| `aquelarre-qa-appium` | — (nuevo) | listo |
| `aquelarre-qa-react-native` | — (nuevo) | listo (Maestro default) |
| `aquelarre-github` | github | listo |
| `aquelarre-refactor` | refactor | listo |
| `aquelarre-doc-crawler` | mitaller-be doc-crawler | listo |

Actualizar la columna **Estado** a `listo` cuando el skill esté en esta carpeta y revisado.

**Total:** 23 skills en catálogo.

## Orden sugerido de migración

1. ~~`aquelarre-github`, `aquelarre-refactor`~~ ✅
2. ~~`aquelarre-scrum-master`, `aquelarre-workflow-orchestration`~~ ✅
3. ~~`aquelarre-po-product`, `aquelarre-testing`~~ ✅
4. ~~`aquelarre-architecture-adr`, `aquelarre-supabase`, `aquelarre-database-postgres`~~ ✅
5. ~~`aquelarre-ux-mobile`, `aquelarre-dev-flutter`~~ ✅
6. ~~Skills nuevos (discovery, bitrise, docker, ux-tablet/web, dev-*, qa-automation)~~ ✅
7. ~~Script instalador dual IDE~~ ✅ — `install/install.ps1 -Dest <ruta> -Ide all`
8. ~~Enriquecimiento backend (punto 11 mitaller-be): dev-fastapi, doc-crawler, TASK TDD, workflows~~ ✅
9. ~~P3: comandos Antigravity + rutas canónicas (`ARTIFACT_PATHS`, `WORKFLOW_COMMANDS`)~~ ✅
10. **Siguiente:** probar en proyecto real (Mi Taller u otro); publicar paquete o submodule

## Qué no va en esta carpeta

| Contenido | Ubicación correcta |
|-----------|-------------------|
| Visión, inventarios, specs largos | `docs/` |
| Plantillas TASK/ADR/UX | `templates/` |
| Rules de Cursor (Gate 0, etc.) | `rules/` |
| Scripts de instalación | `install/` |
| Prototipo sin limpiar | `examples/mitaller-skills/` |

## Referencias

- [VISION.md](../docs/VISION.md) — visión y catálogo completo
- [MITALLER_SKILLS_INVENTORY.md](../docs/MITALLER_SKILLS_INVENTORY.md) — qué limpiar de mitaller
- [AI_WORKFLOW_SKILLS_SPEC.md](../docs/AI_WORKFLOW_SKILLS_SPEC.md) — spec del workflow (canónica)
