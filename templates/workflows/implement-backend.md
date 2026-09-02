# Workflow — Implementar task backend (TDD)

Procedimiento para ejecutar un TASK `platform=backend`. **Elegir guía según stack del repo.**

## Prerrequisitos

- TASK en `ready` (Gate 1 PASS)
- Branch creada (`aquelarre-github`)
- Especificación TDD del task completa (§8a) o test plan en §8

## Routing por stack

| Stack en repo | Workflow / skill |
|---------------|------------------|
| Python + FastAPI | `implement-backend.md` → `aquelarre-dev-fastapi` |
| Node.js (Fastify, Nest, Express) | `implement-node.md` → `aquelarre-dev-node` |

Detectar stack: `pyproject.toml` / `app/main.py` vs `package.json` + `src/`.

## Pasos comunes

1. Validar task y Gate 1 (ADR, contratos, test plan)
2. **RED** — tests que fallan (ver skill dev del stack)
3. **GREEN** — implementación mínima
4. **REFACTOR** — lint, types, cobertura por `risk`
5. Evidencia Gate 2 en task §9
6. PR y Gate 3 (`aquelarre-github`)

## Evidencia Gate 2 (referencia)

| Stack | Comandos típicos |
|-------|------------------|
| FastAPI | pytest, ruff, mypy, docker compose run api pytest |
| Node | pnpm test, biome check, tsc --noEmit, docker compose run test |

Detalle en `dod-checklist.md` de cada skill dev.

## Tipos de task

| Tipo | TDD | Verificación |
|------|-----|--------------|
| feature / bug | Obligatorio | tests + lint + types |
| infrastructure / configuration | N/A justificado | build + health |
