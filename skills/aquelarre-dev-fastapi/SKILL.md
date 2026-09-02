---
name: aquelarre-dev-fastapi
description: Implementa cambios en APIs Python con FastAPI siguiendo el workflow Aquelarre. Usa este skill para tasks ready con platform backend, stack FastAPI, TDD por defecto y evidencia en Docker/CI cuando ci=docker.
---

# Desarrollo FastAPI

Fuentes:

- `docs/AI_WORKFLOW_SKILLS_SPEC.md` — Dev + Gate 2
- `reference.md` — índice y capas
- `tdd-workflow.md` — Red → Green → Refactor
- `fastapi-patterns.md` — patrones Clean Architecture
- `code-standards.md` — ruff, mypy, pytest
- `dod-checklist.md` — DoD Gate 2 por riesgo
- `templates/workflows/implement-backend.md` — procedimiento paso a paso

## Objetivo

Implementar endpoints, servicios y lógica de backend con tests verificables y scope acotado al task.

## Inputs

- Task en `ready` con Gate 1 PASS.
- `platform: backend`, stack FastAPI confirmado en proyecto.
- Specs: PO, ADR, DB, SUPA, TEST.

## Outputs

- Código en rutas/servicios/repos según arquitectura del proyecto.
- Tests (pytest) y evidencia Gate 2.
- Registro en task §7 y §9.

## Gates que aplica

- **Gate 2:** tests + lint + CI Docker si `ci=docker`.

## Reglas operativas

1. No code before task; branch antes de codear.
2. TDD por defecto (`tdd=on`).
3. Validación con Pydantic; errores HTTP consistentes.
4. No mezclar lógica de negocio en routers; seguir capas del proyecto.
5. Cambios de schema → coordinar con `aquelarre-database-postgres` y migraciones.
6. Auth/RLS → coordinar con `aquelarre-supabase` si aplica.

## Checklist

- [ ] Leer task §8a (spec TDD) si `platform=backend`
- [ ] Ciclo TDD: ver `tdd-workflow.md`
- [ ] DoD: ver `dod-checklist.md`
- [ ] `docker compose` tests si `ci=docker`
- [ ] Documentar evidencia en task §9

## Coordinación

| Necesidad | Skill |
|-----------|-------|
| Contenedores | `aquelarre-docker` |
| Postgres | `aquelarre-database-postgres` |
| Supabase | `aquelarre-supabase` |
| Docs API externa | `aquelarre-doc-crawler` |
| PR | `aquelarre-github` |
