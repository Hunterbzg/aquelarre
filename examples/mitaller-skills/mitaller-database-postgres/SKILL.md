---
name: mitaller-database-postgres
description: Disena y valida cambios de base de datos para el workflow. Usa este skill cuando haya impacto en esquema, queries o rendimiento, para definir migracion, rollback y evidencia de verificacion.
---

# Database (Postgres/SQLite alineado)

Fuentes:

- `docs/AI_WORKFLOW_SKILLS_SPEC.md` (DB + reglas G1-DB)
- `database/sqlite/README.md`

## Inputs

- Task con `db_change`.
- Contexto de tablas, relaciones y consultas.
- Restricciones de migracion/rollback.

## Outputs

- Plan de cambio DB (documento o seccion del task).
- Estrategia de migracion y rollback.
- Evidencia de validacion (integridad/performance basica).

## Instrucciones

1. Si `db_change=schema`, definir impacto y rollback (Gate 1 blocker).
2. Documentar:
   - cambios de estructura
   - impactos en lectura/escritura
   - compatibilidad con datos existentes
3. Proponer pruebas de regresion para consultas criticas.
4. Linkear evidencia en task para Gate 2/3.
