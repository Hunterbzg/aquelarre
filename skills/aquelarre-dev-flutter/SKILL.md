---
name: aquelarre-dev-flutter
description: Implementa cambios Flutter siguiendo el workflow Aquelarre. Usa este skill para ejecutar tasks en estado ready con TDD por defecto, registrar implementacion en el TASK y mantener trazabilidad tecnica en proyectos mobile/tablet.
---

# Desarrollo Flutter

Fuentes:

- `docs/AI_WORKFLOW_SKILLS_SPEC.md` (Dev + Gate 2)
- `reference.md` — convenciones Flutter genericas
- `examples.md` — flujos TDD y checklist
- Documentacion del **proyecto consumidor** (`docs/architecture/`, convenciones en `docs/`)

## Objetivo

Implementar el scope del task con calidad verificable, sin expandir alcance ni saltarse gates.

## Inputs

- Task en `ready` con Gate 1 aprobado.
- Branch activa (`task/TASK-<id>-<slug>`) o por crear via skill github.
- Specs linkeadas: PO, UX, ADR, DB, SUPA, TEST.

## Outputs

- Codigo implementado acorde al scope del task.
- Registro en task (secciones 7 implementacion, 9 evidencia).
- Tests y evidencia para Gate 2.

## Gates que aplica

- **Gate 2:** implementacion + evidencia tests/lint + CI Bitrise si `ci=bitrise`.

## Reglas operativas

1. **No code before task** — task en `ready` con Gate 1 PASS.
2. **TDD por defecto** (`tdd=on`); override solo con justificacion en task.
3. Cambios **acotados al scope** del task (1 task ≈ 1 PR).
4. Actualizar trazabilidad: branch, commits, PR, artefactos.
5. Seguir arquitectura y patrones del **proyecto consumidor** (no asumir offline-first u otros patrones desde el harness).
6. Si el proyecto define sync/cache/RLS, seguir su ADR o `docs/architecture/` — no inventar estrategia nueva sin documentar.

## Checklist de implementacion

- [ ] Leer task completo y artefactos linkeados (PO, UX, ADR, TEST).
- [ ] Crear/usar branch antes de codear.
- [ ] Ciclo TDD: red → green → refactor (unit/widget segun alcance).
- [ ] Aplicar convenciones del repo (capas, estado, naming).
- [ ] Estados UI segun UX spec: loading, error, empty, loaded.
- [ ] Ejecutar `flutter test`, `dart analyze`, format segun proyecto.
- [ ] Si `ci=bitrise`: verificar build verde o linkear en task.
- [ ] Documentar evidencia en task seccion 9 antes de PR.
- [ ] Solicitar aprobacion humana antes de considerar Gate 3.

## Guardrails de calidad

- No dejar TODOs como solucion final sin task de seguimiento.
- Preferir `Theme.of(context)` y tokens sobre colores literales.
- Reutilizar utilidades existentes del repo; no duplicar logica.
- Widgets pequenos y componibles; `ListView.builder` para listas largas.

## Coordinacion con otros skills

| Necesidad | Skill |
|-----------|-------|
| UX antes de UI | `aquelarre-ux-mobile` / `aquelarre-ux-tablet` |
| Supabase / RLS | `aquelarre-supabase` |
| Schema DB | `aquelarre-database-postgres` |
| Tests / evidencia Gate 2 | `aquelarre-testing` |
| Appium / UX en dispositivo (opt-in) | `aquelarre-qa-appium` |
| PR / merge | `aquelarre-github` |
| CI mobile | `aquelarre-bitrise` (cuando exista) |

## Artefactos

- Actualiza: codigo en `lib/`, tests en `test/`, task `TASK-*`
