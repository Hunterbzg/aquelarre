# Referencia interna dev-flutter

## Convenciones del repo

- Seguir patrones de arquitectura documentados.
- Registrar cambios y decisiones en el TASK.
- Mantener TDD como default, salvo override justificado.

## Mapeo rapido por necesidad

- Formularios/validaciones: usar patrones de `docs/VALIDACIONES_Y_TESTS.md`.
- Manejo de estados UI: usar patrones de `docs/UI_UX_SUPABASE_CODING_PRACTICES.md`.
- Sincronizacion de datos: usar `docs/OFFLINE_FIRST_SYNC_PATTERN.md`.

## Estrategia de datos del proyecto

- Lectura:
  - local primero
  - comparar `MAX(updated_at)` local/remoto
  - sincronizar remoto cuando remoto sea mas nuevo
- Escritura:
  - guardar/actualizar primero en Supabase
  - solo despues actualizar cache SQLite local
- Regla de tiempo:
  - usar `SyncDateTimeMixin.shouldUseLocal(...)`
  - respetar normalizacion UTC (sin microsegundos) para evitar falsos cambios

## Ejemplos concretos del repo

- Repositorio inventario: online-first en `createItem` y `updateItem`.
- Repositorio inventario: decision por timestamps en `_needsUpdate` y `syncActiveItems`.
- Repositorio ordenes: decision por `updatedAt` en `getOrderById` y sincronizacion local/remota.

## Practicas a evitar

- Saltarse la comparacion por `updated_at` en lecturas sincronizadas.
- Actualizar cache local como fuente principal en escrituras remotas.

## Trazabilidad de inspiracion externa

- Basado parcialmente en:
  - `.cursor/FlutterArmy/skills-main/skills/flutter-managing-state/SKILL.md`
  - `.cursor/FlutterArmy/skills-main/skills/flutter-handling-http-and-json/SKILL.md`
  - `.cursor/FlutterArmy/skills-main/skills/flutter-handling-concurrency/SKILL.md`
