# Referencia — Node.js API (Aquelarre)

Índice del skill. Stack **default greenfield** (2026); en brownfield seguir el repo existente.

## Stack default (proyecto nuevo)

| Capa | Elección | Rol |
|------|----------|-----|
| Runtime | Node.js **20 LTS**+ | LTS estable; Fastify/Nest exigen 20+ |
| Lenguaje | **TypeScript strict** | Contratos en compile-time + Zod en runtime |
| HTTP | **Fastify 5** | Rendimiento, plugins, schema validation nativa |
| Validación | **Zod** | DTOs, env vars, respuestas tipadas |
| ORM | **Drizzle** (+ drizzle-kit) | SQL visible, migraciones, bundle ligero |
| Tests | **Vitest** | Unit + integration; ESM/TS nativo |
| HTTP tests | **fastify.inject()** | In-process, sin puerto real |
| DB tests | **Testcontainers** (Postgres) | Postgres real en CI; no mockear SQL |
| Mocks HTTP externos | **MSW** (Node) o **nock** | Clientes de terceros |
| Lint/format | **Biome** | Un toolchain, rápido |
| Types | **tsc --noEmit** | Biome no sustituye el compilador TS |
| Logs | **Pino** (default Fastify) | JSON estructurado en prod |
| Package manager | **pnpm** (o el del repo) | |

## Alternativas brownfield

| Si el repo usa… | Acción |
|-----------------|--------|
| **NestJS** | Seguir módulos/DI del framework; ver notas en `api-patterns.md` § Nest |
| **Express 5** | supertest + capas manuales; no migrar framework en un task |
| **Prisma** | Mantener; no migrar a Drizzle en task acotado |
| **Jest** | Mantener runner; aplicar mismos principios TDD |
| **ESLint + Prettier** | Mantener; no forzar Biome en brownfield |

## Guías del skill

| Archivo | Contenido |
|---------|-----------|
| `architecture.md` | Capas, boundaries, composición, DI en Node |
| `api-patterns.md` | Rutas, errores RFC 7807, auth, OpenAPI, repos |
| `tdd-workflow.md` | Red → Green → Refactor, pirámide de tests |
| `code-standards.md` | tsconfig, biome, vitest, package.json |
| `dod-checklist.md` | DoD Gate 2 por `risk` |

## Estructura orientativa (greenfield)

```
src/
├── config/           # env (Zod), constantes
├── domain/           # tipos, schemas Zod, errores de dominio (sin I/O)
├── application/      # casos de uso / services (orquestan domain + ports)
├── infrastructure/   # Drizzle, Supabase, clientes HTTP, adapters
├── http/             # plugins Fastify, routes, mappers request/response
├── lib/              # utilidades puras compartidas
├── app.ts            # buildApp() — factory testeable
└── server.ts         # listen(), graceful shutdown (solo producción)
tests/
├── unit/
├── integration/
└── helpers/          # buildTestApp, testDb, fixtures
```

**Principio:** `domain/` y `application/` no importan Fastify ni Drizzle. `http/` es delgado.

## Pirámide de tests

| Capa | Qué | Herramienta |
|------|-----|-------------|
| Unit | Lógica pura, services con repos mockeados | Vitest + vi.fn() |
| Integration HTTP | Rutas, serialización, middleware, auth | fastify.inject() |
| Integration DB | Queries, constraints, migraciones | Testcontainers + Drizzle |
| E2E (pocos) | Smoke con listen() real | supertest o fetch a puerto efímero |

## Comandos evidencia Gate 2

```bash
pnpm test                    # unit (default)
pnpm test:integration        # integration (Testcontainers; CI)
pnpm run check               # biome check .
pnpm run typecheck           # tsc --noEmit
docker compose -f docker-compose.test.yml run --rm test
```

## Artefactos relacionados

| Necesidad | Dónde |
|-----------|-------|
| Contratos API | `templates/API-CONTRACTS.md` |
| Onboarding | `templates/workflows/onboarding-node.md` |
| Implementación | `templates/workflows/implement-node.md` |
| Docker | skill `aquelarre-docker` |
| Supabase / RLS | skill `aquelarre-supabase` |
| Docs API externa | skill `aquelarre-doc-crawler` |

## Anti-patrones

- Lógica de negocio en route handlers
- `process.env` sin validar al boot
- Mockear la base de datos en tests de repositorio
- Tests que pasan sin implementación (RED no confirmado)
- `any` sin justificación en código nuevo
- Callbacks anidados; preferir async/await
- Bloquear el event loop (CPU sync pesado en request path)
- Secretos en código o logs
