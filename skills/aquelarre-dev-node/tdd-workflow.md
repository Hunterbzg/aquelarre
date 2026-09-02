# TDD Workflow — Node.js (Aquelarre)

Ciclo **obligatorio** cuando `tdd=on` y `platform=backend` (salvo `infrastructure` / `configuration` con N/A justificado).

## Red → Green → Refactor

### 1) RED — tests que fallan

1. Leer especificación TDD del TASK (§8a)
2. Identificar capa: unit vs integration (ver pirámide en `reference.md`)
3. Crear archivos en `tests/unit/` o `tests/integration/` (espejo de `src/`)
4. Escribir **todos** los casos del task
5. `pnpm test tests/unit/entity.service.test.ts` → deben **fallar**
6. Si pasan sin implementación → tests demasiado triviales; reforzar assertions

### 2) GREEN — implementación mínima

1. Código mínimo en `src/` siguiendo `architecture.md` y `api-patterns.md`
2. `pnpm test` en la ruta tocada → **PASS**
3. No añadir features fuera del scope del task

### 3) REFACTOR — calidad

1. Eliminar duplicación; nombres claros
2. `pnpm run check:fix` (Biome)
3. `pnpm run typecheck`
4. Tests en verde
5. Cobertura según `dod-checklist.md`

## Qué testear en cada capa

| Capa | Mock | Ejemplo |
|------|------|---------|
| `domain/` (puro) | Nada | Validadores Zod, reglas puras |
| `application/` | Ports (repos, clients) | `vi.fn()` en EntityRepository |
| `http/` routes | Service real o mock | `fastify.inject()` |
| `infrastructure/` repos | **Postgres real** (Testcontainers) | INSERT + SELECT |
| Clientes HTTP | MSW / nock | Respuestas grabadas |

**Regla:** no mockear SQL en tests de repositorio — usar Testcontainers.

## Helper de app (`tests/helpers/build-test-app.ts`)

```typescript
import { buildApp } from '../../src/app.js';
import type { FastifyInstance } from 'fastify';

export async function buildTestApp(
  overrides?: Partial<AppDependencies>,
): Promise<FastifyInstance> {
  const app = await buildApp({
    ...overrides,
    logger: false,
  });
  await app.ready();
  return app;
}
```

Siempre `await app.ready()` antes de `inject()`. Cerrar con `await app.close()` en `afterEach`.

## Test unitario — service

```typescript
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { EntityService } from '../../src/application/entity.service.js';
import type { EntityRepository } from '../../src/application/ports/entity-repository.port.js';

describe('EntityService', () => {
  let repo: EntityRepository;
  let service: EntityService;

  beforeEach(() => {
    repo = {
      findById: vi.fn(),
      create: vi.fn(),
    };
    service = new EntityService(repo);
  });

  it('creates entity with valid input', async () => {
    vi.mocked(repo.create).mockResolvedValue({ id: '1', name: 'Test' });
    const result = await service.create({ name: 'Test' });
    expect(result.name).toBe('Test');
    expect(repo.create).toHaveBeenCalledWith({ name: 'Test' });
  });
});
```

## Test integración HTTP — fastify.inject()

```typescript
import { describe, it, expect, afterEach } from 'vitest';
import { buildTestApp } from '../helpers/build-test-app.js';

describe('POST /v1/entities', () => {
  let app: Awaited<ReturnType<typeof buildTestApp>>;

  afterEach(async () => {
    await app?.close();
  });

  it('returns 201 with created entity', async () => {
    app = await buildTestApp({ /* mock repo or test db */ });

    const response = await app.inject({
      method: 'POST',
      url: '/v1/entities',
      payload: { name: 'Test' },
    });

    expect(response.statusCode).toBe(201);
    expect(response.json()).toMatchObject({ name: 'Test', id: expect.any(String) });
  });
});
```

Preferir **fastify.inject()** sobre supertest en proyectos Fastify (in-process, sin socket).

## Test integración DB — Testcontainers

```typescript
import { PostgreSqlContainer } from '@testcontainers/postgresql';
import { drizzle } from 'drizzle-orm/node-postgres';
import { migrate } from 'drizzle-orm/node-postgres/migrator';

let container: StartedPostgreSqlContainer;

beforeAll(async () => {
  container = await new PostgreSqlContainer('postgres:17-alpine').start();
  const db = drizzle(container.getConnectionUri());
  await migrate(db, { migrationsFolder: './drizzle' });
}, 60_000);

afterAll(async () => {
  await container?.stop();
});
```

Ejecutar suite integration con timeout mayor: `vitest.config.ts` → `testTimeout: 30_000` en project `integration`.

## Mock HTTP externo (MSW)

```typescript
import { setupServer } from 'msw/node';
import { http, HttpResponse } from 'msw';

const server = setupServer(
  http.post('https://api.stripe.com/v1/charges', () =>
    HttpResponse.json({ id: 'ch_123', status: 'succeeded' }),
  ),
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());
```

## Config Vitest recomendada

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: false,
    isolate: true,
    include: ['tests/unit/**/*.test.ts'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'lcov'],
      include: ['src/**/*.ts'],
    },
  },
});
```

Proyecto separado para integration:

```typescript
// vitest.integration.config.ts
export default defineConfig({
  test: {
    include: ['tests/integration/**/*.test.ts'],
    testTimeout: 30_000,
    hookTimeout: 60_000,
  },
});
```

Scripts: `"test": "vitest run"`, `"test:integration": "vitest run --config vitest.integration.config.ts"`.

## Tipos de task

| Tipo | TDD | Verificación |
|------|-----|--------------|
| feature, bugfix | Obligatorio | unit + integration según capas tocadas |
| infrastructure, configuration | N/A justificado | `docker compose build`, app arranca |

## Express / Nest (brownfield)

| Framework | HTTP tests |
|-----------|------------|
| Express | supertest contra `app` exportado |
| Nest | `TestingModule` + supertest e2e |

Mismo ciclo RED→GREEN→REFACTOR; cambia solo el helper de app.
