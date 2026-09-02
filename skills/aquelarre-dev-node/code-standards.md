# Code Standards — Node.js / TypeScript

Convenciones default greenfield. Brownfield: seguir el repo; no reformat masivo en un task acotado.

## TypeScript

```json
// tsconfig.json (extracto)
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "verbatimModuleSyntax": true,
    "skipLibCheck": true,
    "outDir": "dist",
    "rootDir": "src"
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist", "tests"]
}
```

Tests con tsconfig propio o `"include": ["src", "tests"]` según setup.

## Biome

```json
// biome.json (extracto)
{
  "$schema": "https://biomejs.dev/schemas/2.0.0/schema.json",
  "formatter": { "indentStyle": "space", "indentWidth": 2, "lineWidth": 100 },
  "javascript": {
    "formatter": { "quoteStyle": "single", "semicolons": "always" }
  },
  "linter": {
    "enabled": true,
    "rules": { "recommended": true, "suspicious": { "noExplicitAny": "warn" } }
  }
}
```

```bash
pnpm exec biome check .          # CI
pnpm exec biome check --write .  # fix local
```

**Biome no reemplaza `tsc`:** ejecutar `tsc --noEmit` en Gate 2.

## package.json — scripts mínimos

```json
{
  "type": "module",
  "engines": { "node": ">=20" },
  "scripts": {
    "dev": "tsx watch src/server.ts",
    "build": "tsc",
    "start": "node dist/server.js",
    "test": "vitest run",
    "test:watch": "vitest",
    "test:integration": "vitest run --config vitest.integration.config.ts",
    "test:coverage": "vitest run --coverage",
    "typecheck": "tsc --noEmit",
    "check": "biome check .",
    "check:fix": "biome check --write .",
    "db:migrate": "drizzle-kit migrate",
    "db:generate": "drizzle-kit generate"
  }
}
```

## Naming

| Elemento | Convención |
|----------|------------|
| Archivos | `kebab-case.ts` |
| Clases / tipos | `PascalCase` |
| Funciones / vars | `camelCase` |
| Constantes env | `SCREAMING_SNAKE_CASE` |
| Tests | `*.test.ts` junto o en `tests/` espejo |
| Rutas URL | kebab-case plural: `/v1/order-items` |

## Imports

- ESM: extensiones `.js` en imports relativos (`import { x } from './foo.js'`)
- Orden: node builtins → externos → internos (`@/` alias si está configurado)
- Biome `organizeImports` en save/CI

## Dependencias dev típicas (greenfield)

```json
{
  "devDependencies": {
    "@biomejs/biome": "^2.0.0",
    "@testcontainers/postgresql": "^11.0.0",
    "@types/node": "^22.0.0",
    "drizzle-kit": "^0.30.0",
    "tsx": "^4.0.0",
    "typescript": "^5.7.0",
    "vitest": "^3.0.0",
    "@vitest/coverage-v8": "^3.0.0"
  }
}
```

Runtime: `fastify`, `zod`, `drizzle-orm`, `pino` (via Fastify).

## .gitignore mínimo

```
node_modules/
dist/
.env
.env.*
!.env.example
coverage/
.turbo/
*.log
```

## .env.example

```bash
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://user:pass@localhost:5432/app
LOG_LEVEL=info
# SUPABASE_URL=
# SUPABASE_SERVICE_ROLE_KEY=
```

Validar con Zod en `src/config/env.ts` al arranque.
