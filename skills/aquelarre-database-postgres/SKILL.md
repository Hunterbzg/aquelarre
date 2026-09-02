---
name: aquelarre-database-postgres
description: Disena y valida cambios de base de datos Postgres/Supabase para el workflow Aquelarre. Usa este skill cuando haya impacto en esquema, queries, migraciones o rendimiento.
---

# Database (Postgres)

Fuentes:

- `docs/AI_WORKFLOW_SKILLS_SPEC.md` (DB + reglas G1-DB)
- Template Apéndice K (DB)
- Migraciones del proyecto (`supabase/migrations/`, `db/migrations/`, etc.)

## Objetivo

Planificar cambios de esquema y consultas criticas con migracion, rollback y evidencia verificable.

## Inputs

- Task con `db_change` (`query`, `schema`, `none`).
- Contexto de tablas, relaciones, indices y volumen.
- Restricciones de migracion, downtime y compatibilidad hacia atras.

## Outputs

- Documento `docs/db/schema-changes/DB-<id>-<slug>.md` o seccion DB en el task.
- Estrategia de migracion y rollback.
- Evidencia de validacion (integridad, smoke queries, EXPLAIN si aplica).

## Gates que aplica

- **Gate 1 (G1-DB-001):** si `db_change=schema` → impacto + plan migracion/rollback (blocker).
- Coordinacion con ADR en cambios estructurales o irreversibles.

## Instrucciones

1. Si `db_change=schema`:
   - listar cambios (tablas, columnas, constraints, indices)
   - evaluar impacto en lectura/escritura y apps desplegadas
   - definir rollback (down migration o script inverso)
2. Si `db_change=query` (optimizacion):
   - documentar query antes/despues
   - incluir `EXPLAIN` o metricas si el riesgo es performance
3. Para datos existentes: backfill, valores default, riesgo de locking.
4. Proponer pruebas de regresion para consultas criticas en TEST plan.
5. Linkear `DB-*` y migraciones desde el task.
6. En proyectos Supabase, alinear nombres de migracion con convencion del repo.

## Cache local (SQLite, etc.)

Si el proyecto usa cache local ademas de Postgres remoto, documentar impacto en el **proyecto consumidor** (`docs/architecture/` o ADR), no asumir estrategia desde este skill.

## Artefactos

| Artefacto | Ruta |
|-----------|------|
| Cambio DB | `docs/db/schema-changes/DB-<id>-<slug>.md` |
| Migracion | segun proyecto (`supabase/migrations/`, etc.) |
| Template | Apéndice K del `AI_WORKFLOW_SKILLS_SPEC.md` |

## Coordinacion

- **RLS / auth** → `aquelarre-supabase`
- **Decision estructural** → `aquelarre-architecture-adr`
