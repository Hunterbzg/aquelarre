# Workflow — Onboarding backend (Node.js)

Inicializa un proyecto consumidor con Aquelarre + stack Node/TypeScript.
Ejecutar cuando el proyecto es greenfield `platform: backend` y aún no tiene estructura API.

## Prerrequisitos

- Aquelarre instalado (`install/install.ps1 -Dest <proyecto>`)
- Node.js 20+ y pnpm (o npm) disponibles localmente o vía Docker

## Pasos

### 1) Identidad del proyecto

Preguntar al humano:

1. Nombre del proyecto
2. Descripción breve (1–2 frases)
3. Idioma de artefactos (español / inglés)
4. URL del repositorio (si existe)
5. ¿Supabase en prod? (sí/no — afecta config y skills)

### 2) Contexto existente

Leer si existen:

- `docs/project-context.md`
- `docs/discovery/` (cualquier DISCOVERY-*)
- `README.md`, `package.json`

Si ya hay Express/Nest → **no** forzar Fastify; documentar stack en project-context y usar skill en modo brownfield.

### 3) Estructura `docs/` (si falta)

El instalador Aquelarre ya crea scaffold. Verificar:

- `docs/project-context.md`
- `docs/architecture/api-contracts/`

### 4) Scaffold Node (greenfield — si no existe `src/`)

Crear mínimo según `skills/aquelarre-dev-node/`:

```
src/
├── config/env.ts
├── domain/schemas/
├── domain/errors/
├── application/
│   ├── ports/
│   └── entity.service.ts   # placeholder o eliminar si vacío
├── infrastructure/persistence/
├── http/
│   ├── plugins/error-handler.ts
│   └── routes/v1/health.routes.ts
├── app.ts
└── server.ts
tests/
├── unit/
├── integration/
└── helpers/build-test-app.ts
drizzle/                    # migraciones (si Drizzle)
```

Archivos de config:

- `package.json` — scripts en `code-standards.md`
- `tsconfig.json`, `biome.json`, `vitest.config.ts`, `vitest.integration.config.ts`
- `.env.example` — PORT, DATABASE_URL, NODE_ENV
- `.gitignore`

Dependencias core: `fastify`, `zod`, `drizzle-orm`, `postgres` (driver).

### 5) Endpoints mínimos

- `GET /health` → `{ status: 'ok' }`
- `GET /ready` → ping DB si DATABASE_URL configurada

### 6) Docker (si `ci=docker`)

- `Dockerfile` multi-stage Node — ver `skills/aquelarre-docker/reference.md` § Node
- `docker-compose.yml` desarrollo
- `docker-compose.test.yml` con servicio `test` → `pnpm test`

### 7) Actualizar project-context

Marcar:

- Stack: Node 20 + TypeScript + Fastify + Drizzle + Vitest + Biome + Docker
- Gates: todos ⬜ salvo onboarding ✅
- Próximo paso: `aquelarre-discovery` o primer EPIC/TASK

### 8) Cierre

Presentar resumen al humano y recomendar discovery o primer TASK con clasificación Gate 0 completa.
