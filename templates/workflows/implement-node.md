# Workflow — Implementar task backend (Node.js / TDD)

Procedimiento para ejecutar un TASK `platform=backend` con stack Node (`aquelarre-dev-node`).

## Prerrequisitos

- TASK en `ready` (Gate 1 PASS)
- Branch creada (`aquelarre-github`)
- Sección **Especificación TDD** del task completa (§8a) o test plan en §8
- Framework confirmado en repo (`package.json`: fastify / @nestjs/core / express)

## Routing por stack

| Repo usa | Skill / guía |
|----------|----------------|
| Fastify (default greenfield) | Este workflow + `tdd-workflow.md` |
| NestJS | Mismos principios; Nest TestingModule + supertest |
| Express | supertest; capas según repo |

Si el repo es **Python/FastAPI** → usar `implement-backend.md` (FastAPI), no este archivo.

## Pasos

### 1) Validar task

1. Leer `docs/project-context.md`
2. Leer `docs/workflow/tasks/TASK-<id>-<slug>.md`
3. Verificar Gate 1: ADR, API contracts, test plan según routing
4. DoR incompleto → detener; completar con scrum-master / PO

### 2) Fase RED

Seguir `skills/aquelarre-dev-node/tdd-workflow.md`:

1. Crear tests en `tests/unit/` y/o `tests/integration/`
2. `pnpm test <ruta>` → deben **fallar**
3. Registrar en task §7

### 3) Fase GREEN

1. Implementar mínimo en `src/` — `architecture.md`, `api-patterns.md`
2. Coordinar migraciones DB si `db_change=yes`
3. `pnpm test` → **PASS**
4. Registrar en task §7

### 4) Fase REFACTOR

1. `pnpm run check:fix`
2. `pnpm run typecheck`
3. Cobertura según `risk` → `dod-checklist.md`

### 5) Evidencia Gate 2

Completar task §9:

```markdown
- pnpm test → PASS
- pnpm test:integration → PASS (si aplica)
- pnpm run check → PASS
- pnpm run typecheck → PASS
- docker compose -f docker-compose.test.yml run --rm test → PASS (si ci=docker)
```

### 6) PR y Gate 3

- Abrir PR (`aquelarre-github`)
- Aprobación humana antes de merge

## Tipos de task

| Tipo | TDD | Verificación |
|------|-----|--------------|
| feature / bug | Obligatorio | vitest + biome + tsc |
| infrastructure / configuration | N/A justificado | docker build, /health OK |
