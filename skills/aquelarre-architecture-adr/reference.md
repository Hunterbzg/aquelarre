# Referencia — Arquitectura y ADR (Aquelarre)

## Cuando exigir ADR

| Condicion | ADR |
|-----------|-----|
| `db_change=schema` | Si — impacto estructural + migracion |
| `db_change=rls_policy` | Si — seguridad y permisos |
| `surface` incluye `auth` | Si |
| `type=refactor` + `risk=high` | Recomendado — boundaries |
| Cambio de capas o modulos principales | Recomendado |
| Bug fix local sin cambio estructural | Normalmente no |

## Contenido minimo del ADR

1. Status (`Proposed` | `Accepted` | `Rejected` | `Deprecated` | `Superseded`)
2. Context
3. Decision
4. Consequences (positivas y negativas)
5. Alternatives considered
6. Related (TASK, PRD, UX, SUPA, DB)

## Evidencia en cambios estructurales

- Impacto en modulos dependientes (lista explicita).
- Plan de rollback o feature flag si aplica.
- Pruebas de regresion esperadas (linkear TEST plan).

## Patrones por stack (orientativos, no obligatorios)

Definir en ADR o en `docs/architecture/` del **proyecto**, no asumir desde el harness:

| Stack | Decisiones tipicas a documentar |
|-------|--------------------------------|
| Flutter + Supabase | Capas, repositorios, cache local, sync offline |
| React + API | Estado servidor/cliente, BFF, auth |
| FastAPI / Node | Capas, DI, transacciones, idempotencia |
| Supabase | RLS, roles, edge functions, storage paths |

## Guia ADR para sincronizacion de datos (si el proyecto la usa)

Solo cuando el proyecto adopte cache local + remoto:

- Entidad y campo de version (`updated_at`, revision, etc.).
- Criterio para fuente de verdad en lectura.
- Escritura: orden remoto/local y manejo de fallos.
- Consistencia eventual y conflictos.
- Pruebas de regresion de sync.

## Documentacion del proyecto consumidor

Priorizar sobre esta referencia:

- `docs/architecture/OVERVIEW.md`
- `docs/architecture/*.md` — patrones elegidos del proyecto
- ADRs previos en `docs/adr/`

## Criterio de exclusion

- No replicar practicas fragiles o marcadas TODO en el codigo existente.
- Si el codigo contradice seguridad o robustez, registrar mejora en ADR nuevo.
