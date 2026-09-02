---
id: DB-<id>
title: <cambio de schema o query>
status: draft | approved | applied | rolled_back
owner: <Dev/DBA>
created_at: <YYYY-MM-DD>
updated_at: <YYYY-MM-DD>
links:
  tasks: []
  adr: []
  migrations: []
---

## 1) Contexto
- Por qué se necesita el cambio.

## 2) Cambios propuestos
- Tablas, columnas, índices, constraints.

## 3) Migración
- Up: ...
- Down / rollback: ...

## 4) Impacto
- Queries afectadas, downtime, volumen.

## 5) Verificación
- [ ] Migración aplicada en staging
- [ ] Tests / explain analyze si aplica

## 6) Evidencia
- Comandos, links, PASS/FAIL
