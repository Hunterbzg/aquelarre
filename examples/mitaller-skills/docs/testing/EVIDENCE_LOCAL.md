# Evidencia visual de pruebas — solo local

## Regla

La carpeta **`docs/testing/evidence/`** es **local** y está en `.gitignore`.

- **No** agregar capturas, grabaciones ni dumps a git.
- **Sí** registrar en el TASK / TEST-* el **resultado** (PASS/FAIL), comandos y, si hace falta, la **ruta local** usada (ej. `docs/testing/evidence/TASK-2026-033/`).

## Uso (agentes y humanos)

1. Crear subcarpeta por task o caso: `docs/testing/evidence/TASK-YYYY-NNN/` o `e1-NNN-*.png`.
2. Guardar screenshots ahí durante smoke Appium / Mobile MCP / manual.
3. En Gate 2: citar la ruta en el task como “evidencia local (no commiteada)”; el revisor puede pedir verlas en máquina o en el chat.

## Relacionado

- Skill: `.cursor/skills/mitaller-testing/` (sección evidencia local)
- Playbook device: `docs/testing/APPIUM_STAGING_DEVICE_PLAYBOOK.md`
- También ignorado (legado): `/appium_screenshots`
