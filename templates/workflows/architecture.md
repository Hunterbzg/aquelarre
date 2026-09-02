# Workflow — Arquitectura (ADR y contratos)

Decisiones estructurales, boundaries y contratos técnicos.

**Comando Antigravity:** `/architecture`  
**Skills:** `aquelarre-architecture-adr` · `aquelarre-database-postgres` · `aquelarre-supabase` (condicional)

## Prerrequisitos

- PRD o task con alcance estructural claro
- Gate 1 parcial: valor de producto entendido

## Pasos

### 1) Leer contexto

- `docs/project-context.md`
- `docs/discovery/`
- `docs/product/briefs/` (si existe)

### 2) ADR

Crear `docs/adr/####-<decision>.md` desde `templates/ADR.md`.

### 3) Artefactos condicionales

| Condición | Artefacto | Skill |
|-----------|-----------|-------|
| Cambio de schema | `docs/db/schema-changes/DB-*.md` | `aquelarre-database-postgres` |
| Supabase / RLS | `docs/supabase/SUPA-*.md` | `aquelarre-supabase` |
| API pública | `docs/architecture/api-contracts/<slug>.md` | template `API-CONTRACTS.md` |

### 4) Aprobación humana

Presentar ADRs y contratos; esperar confirmación.

### 5) Siguiente paso

`/sprint-plan` · `aquelarre-scrum-master`
