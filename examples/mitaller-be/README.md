# mitaller-be — AI SDLC Factory (referencia Antigravity)

Snapshot del harness de agentes usado en **Antigravity** para el backend Mi Taller (Python + FastAPI). Este folder contiene **solo** la configuración `.agents/` — no código de aplicación.

## Contenido

| Ruta | Propósito |
|------|-----------|
| `.agents/AGENTS.md` | Router de intención + reglas globales (gates, BMAD, stack) |
| `.agents/workflows/` | 7 procedimientos (`/onboarding`, `/discovery`, `/implement`, …) |
| `.agents/skills/orchestrator/` | Estado del proyecto y siguiente paso |
| `.agents/skills/product-agent/` | Discovery, PRD, arquitectura, backlog, sprint |
| `.agents/skills/coding-agent/` | TDD, FastAPI, Supabase, Docker, DoD |
| `.agents/skills/doc-crawler/` | Crawl de documentación externa (APIs terceros) |

## Inventario Aquelarre

Análisis genérico vs específico y comparación con el harness Aquelarre:

**[docs/MITALLER_BE_INVENTORY.md](../../docs/MITALLER_BE_INVENTORY.md)**

## Relación con Aquelarre

| mitaller-be | Aquelarre |
|-------------|-----------|
| 4 skills compuestos | 20 skills `aquelarre-*` |
| Solo `.agents/` (Antigravity) | `.cursor/skills/` + `.agents/skills/` |
| Workflows por comando | Routing en `aquelarre-workflow-orchestration` |
| Gates 0, 1a, 1b, 2, 3 | Gates 0, 1, 2, 3 + reglas G* |

Dominio facturación/Hacienda (Kapix, etc.) aparece solo en **ejemplos** de los resources — no forma parte del harness portable.
