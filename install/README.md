# Instalador — Aquelarre

Copia el harness a un **proyecto consumidor** con soporte dual IDE.

## Requisitos

- Windows: PowerShell 5.1+ (incluido en Windows 10/11)
- macOS/Linux: bash + `cp`

## Uso rápido

```powershell
# Desde el repo Aquelarre (Windows)
.\install\install.ps1 -Dest D:\ruta\mi-proyecto

# Ruta posicional (equivalente)
.\install\install.ps1 ..\mi-proyecto

# Solo Cursor
.\install\install.ps1 -Dest ..\mi-proyecto -Ide cursor

# Solo Antigravity
.\install\install.ps1 -Dest ..\mi-proyecto -Ide antigravity

# Vista previa sin copiar
.\install\install.ps1 -Dest ..\mi-proyecto -DryRun
```

```bash
# macOS / Linux / Git Bash
chmod +x install/install.sh
./install/install.sh --target ../mi-proyecto
./install/install.sh --target ../mi-proyecto --ide antigravity
```

## Qué instala

| Componente | Destino en el proyecto |
|------------|------------------------|
| 21 skills `aquelarre-*` | `.cursor/skills/` y/o `.agents/skills/` |
| Rule Gate 0 | `.cursor/rules/` (Cursor) |
| Plantillas | `templates/` |
| Spec workflow | `docs/AI_WORKFLOW_SKILLS_SPEC.md` (si no existe) |
| Política evidencia QA | `docs/testing/EVIDENCE_LOCAL.md` (si no existe) |
| Hub de contexto (opcional) | `docs/project-context.md` (si no existe) |
| Carpetas workflow | `docs/workflow/`, `docs/discovery/`, `docs/architecture/`, … |
| Manifiesto | `.aquelarre-install.json` |
| Workflows Antigravity | `.agents/workflows/` + `.agents/AGENTS.md` (si no existen) |
| Guías de rutas y comandos | `docs/ARTIFACT_PATHS.md`, `docs/WORKFLOW_COMMANDS.md` |

## Comportamiento

- **Skills:** siempre se reemplazan por la versión del harness (idempotente al re-ejecutar).
- **Docs y rules:** no sobrescriben archivos existentes salvo con `--force` / `-Force`.
- **Scaffold:** solo crea carpetas que no existan.
- **Antigravity rules:** aún sin ruta estándar; skills sí se instalan en `.agents/skills/`.

## Reinstalar / actualizar skills

```powershell
.\install\install.ps1 -Dest ..\mi-proyecto -Ide all
```

Para actualizar también la spec y rules:

```powershell
.\install\install.ps1 -Dest ..\mi-proyecto -Force
```

## Siguiente paso en el proyecto

1. Abrir el proyecto en Cursor o Antigravity.
2. Ejecutar skill `aquelarre-discovery` (proyecto nuevo o brownfield).
3. Crear el primer `TASK-*` con `templates/TASK.md`.
