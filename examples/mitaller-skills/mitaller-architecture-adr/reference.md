# Referencia interna de arquitectura

## Decision baseline

- Favorecer arquitectura por capas (`presentation`, `domain`, `data`).
- Repositorio como SSOT.
- Estrategia offline-first para lectura y online-first para escritura.

## Evidencia requerida en cambios estructurales

- ADR con contexto/decision/trade-offs.
- Riesgos y plan de rollback.
- Impacto en modulos dependientes.

## Patrones tecnicos confirmados en codigo

- `SyncDateTimeMixin` para comparacion UTC de timestamps.
- Uso de `shouldUseLocal(local, remote)` para decidir fuente de datos.
- Repositorios implementando:
  - lectura local + sincronizacion condicional
  - escritura remota + cache local posterior

## Guía para ADR de sincronizacion

- Definir entidad y alcance de `updated_at`.
- Definir fallback cuando remoto falla.
- Definir estrategia de cache y consistencia eventual.
- Definir pruebas de regresion para sincronizacion.

## Fuentes internas

- `docs/ORDERS_ARCHITECTURE_PATTERNS.md`
- `docs/OFFLINE_FIRST_SYNC_PATTERN.md`

## Trazabilidad de inspiracion externa

- Basado parcialmente en:
  - `.cursor/FlutterArmy/skills-main/skills/flutter-architecting-apps/SKILL.md`
  - `.cursor/FlutterArmy/skills-main/skills/flutter-caching-data/SKILL.md`
