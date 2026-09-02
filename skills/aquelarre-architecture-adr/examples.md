# Ejemplos — ADR (Aquelarre)

Casos tipo para estructurar ADRs. Adaptar al dominio del proyecto consumidor.

## Caso A: cambio auth o RLS (Supabase)

El ADR debe incluir:

- Actores/roles (anon, authenticated, service, roles custom).
- Matriz permiso esperado por tabla/operacion (SELECT, INSERT, UPDATE, DELETE).
- Denegaciones explicitas (cross-tenant, escalacion de privilegios).
- Riesgos de seguridad y mitigaciones.
- Evidencia: pruebas positivas (permitido) y negativas (denegado) en TEST plan.

## Caso B: cambio de schema (Postgres)

El ADR debe incluir:

- Tablas/columnas/indices afectados y motivacion.
- Impacto en datos existentes (backfill, default, locking).
- Orden de migracion y rollback SQL.
- Compatibilidad con versiones de app en produccion (si aplica).
- Link a `DB-*` o migracion en `supabase/migrations/`.

## Caso C: cambio de boundaries (refactor alto riesgo)

El ADR debe incluir:

- Modulos o capas antes y despues.
- APIs publicas que no deben romperse.
- Estrategia incremental (strangler, feature flag) si aplica.
- Criterio de exito y pruebas de regresion.

## Caso D: politica de sincronizacion (opcional — solo si el proyecto usa cache + remoto)

El ADR debe incluir:

- Problema de consistencia observado.
- Decision sobre versionado y criterio de fuente en lectura.
- Orden de escritura y fallback offline.
- Impacto en repositorios, datasources y pruebas.
- Rollback ante regresion de datos.
