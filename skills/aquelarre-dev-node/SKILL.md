---
name: aquelarre-dev-node
description: Implementa APIs backend con Node.js y TypeScript siguiendo el workflow Aquelarre. Usa este skill para tasks ready con platform backend, stack Node (Fastify default; Nest/Express en brownfield), TDD por defecto y evidencia Docker/CI cuando ci=docker.
---

# Desarrollo Node.js

Fuentes:

- `docs/AI_WORKFLOW_SKILLS_SPEC.md` — Dev + Gate 2
- `reference.md` — stack default, pirámide de tests, índice
- `architecture.md` — capas, ports, composición Node
- `api-patterns.md` — Zod, RFC 7807, routes, repos, OpenAPI
- `tdd-workflow.md` — Red → Green → Refactor (Vitest, inject, Testcontainers)
- `code-standards.md` — TypeScript strict, Biome, scripts
- `dod-checklist.md` — DoD Gate 2 por riesgo
- `templates/workflows/onboarding-node.md` — greenfield
- `templates/workflows/implement-node.md` — implementación paso a paso

## Objetivo

Implementar APIs REST/JSON con prácticas actuales de la industria Node: arquitectura en capas testeable, validación runtime, errores estándar, TDD verificable y scope acotado al task.

## Inputs

- Task en `ready` con Gate 1 PASS.
- `platform: backend`, stack Node confirmado (`package.json`, ADR).
- Specs: PO, ADR, DB, SUPA, TEST, API contracts.

## Outputs

- Código en capas según `architecture.md` (o convención brownfield del repo).
- Tests Vitest (o runner del repo) + evidencia Gate 2.
- Registro en task §7 y §9.

## Gates que aplica

- **Gate 2:** tests + lint + typecheck + CI Docker si `ci=docker`.

## Stack default (greenfield)

Node 20+ · TypeScript strict · Fastify · Zod · Drizzle · Vitest · Biome · Testcontainers · pnpm.

En brownfield: leer framework y herramientas existentes; **no migrar stack** en un task acotado.

## Reglas operativas

1. No code before task; branch antes de codear.
2. TDD por defecto (`tdd=on`); ciclo en `tdd-workflow.md`.
3. Boundaries: domain/application sin I/O; http delgado; repos en infrastructure.
4. Validación Zod (o equivalente del framework) en frontera HTTP.
5. Errores API: RFC 7807 Problem Details salvo ADR distinto.
6. Env validado al boot; nunca secretos en código/logs.
7. DB/schema → `aquelarre-database-postgres`; Supabase/RLS → `aquelarre-supabase`.

## Checklist

- [ ] Leer task §8a (spec TDD) si `platform=backend`
- [ ] Confirmar framework (Fastify / Nest / Express) desde el repo
- [ ] Ciclo TDD: `tdd-workflow.md`
- [ ] DoD: `dod-checklist.md`
- [ ] `docker compose` tests si `ci=docker`
- [ ] Documentar evidencia en task §9

## Coordinación

| Necesidad | Skill |
|-----------|-------|
| Contenedores | `aquelarre-docker` |
| Postgres | `aquelarre-database-postgres` |
| Supabase | `aquelarre-supabase` |
| Docs API externa | `aquelarre-doc-crawler` |
| Frontend consumidor | `aquelarre-dev-react` |
| PR | `aquelarre-github` |
