# Patrones API — Node.js

Prácticas actuales de la industria para APIs REST/JSON en Node. Default: **Fastify + TypeScript + Zod**.

## Validación con Zod

Fuente de verdad en `domain/schemas/`; reutilizar en HTTP y services:

```typescript
import { z } from 'zod';

export const createEntitySchema = z.object({
  name: z.string().min(1).max(200),
  description: z.string().optional(),
});

export type CreateEntityInput = z.infer<typeof createEntitySchema>;
```

En la ruta (Fastify):

```typescript
app.post('/v1/entities', async (request, reply) => {
  const parsed = createEntitySchema.safeParse(request.body);
  if (!parsed.success) {
    return reply.status(400).send(toProblemDetails(parsed.error));
  }
  const entity = await entityService.create(parsed.data);
  return reply.status(201).send(toEntityResponse(entity));
});
```

Alternativa: `@fastify/type-provider-zod` si el proyecto ya lo usa.

## Errores — RFC 7807 Problem Details

Formato estándar de la industria para APIs HTTP:

```typescript
// http/errors/problem-details.ts
export type ProblemDetails = {
  type: string;       // URI identificadora del error
  title: string;
  status: number;
  detail?: string;
  instance?: string;    // path del request
  errors?: Record<string, string[]>; // validación
};
```

Handler global en plugin Fastify:

```typescript
app.setErrorHandler((error, request, reply) => {
  if (error instanceof EntityNotFoundError) {
    return reply.status(404).send({
      type: 'https://api.example.com/errors/not-found',
      title: 'Resource not found',
      status: 404,
      detail: error.message,
      instance: request.url,
    });
  }
  request.log.error(error);
  return reply.status(500).send({
    type: 'https://api.example.com/errors/internal',
    title: 'Internal Server Error',
    status: 500,
  });
});
```

## Route handlers delgados

El handler solo: parse → llamar service → mapear respuesta.

```typescript
// http/routes/v1/entities.routes.ts
export async function registerEntityRoutes(
  app: FastifyInstance,
  deps: { entityService: EntityService },
) {
  app.post('/v1/entities', async (request, reply) => {
    // validación + delegación — sin SQL ni reglas de negocio aquí
  });
}
```

Registrar rutas como **plugins** Fastify con prefijo `/v1`.

## Application services

```typescript
// application/entity.service.ts
export class EntityService {
  constructor(private readonly repo: EntityRepository) {}

  async create(input: CreateEntityInput): Promise<Entity> {
    // reglas de negocio, invariantes
    return this.repo.create(input);
  }

  async getById(id: string): Promise<Entity> {
    const entity = await this.repo.findById(id);
    if (!entity) throw new EntityNotFoundError(id);
    return entity;
  }
}
```

## Repositorio (Drizzle)

```typescript
// infrastructure/persistence/drizzle-entity.repository.ts
export class DrizzleEntityRepository implements EntityRepository {
  constructor(private readonly db: Database) {}

  async findById(id: string): Promise<Entity | null> {
    const row = await this.db.query.entities.findFirst({
      where: eq(entities.id, id),
    });
    return row ? toDomain(row) : null;
  }
}
```

Mappers `toDomain` / `toPersistence` en infrastructure — mantener `domain/` libre de ORM.

## OpenAPI / contratos

- `@fastify/swagger` + `@fastify/swagger-ui` para docs vivas en dev.
- Contratos estables también en `docs/architecture/api-contracts/` (Aquelarre).
- Versionado de API por prefijo URL: `/v1/`, `/v2/`.

## Auth (patrón común)

| Estilo | Implementación |
|--------|----------------|
| JWT Bearer | Plugin `onRequest` valida token; adjunta `request.user` |
| Supabase Auth | Validar JWT con secret JWKS; coordinar `aquelarre-supabase` |
| API keys | Header + lookup en DB/cache |

Auth en plugin reutilizable; guards por ruta con `preHandler`.

## Health y readiness

```typescript
app.get('/health', async () => ({ status: 'ok' }));
app.get('/ready', async (_, reply) => {
  await db.execute(sql`SELECT 1`);
  return { status: 'ready' };
});
```

`/health` para liveness; `/ready` para readiness (DB up).

## Graceful shutdown

```typescript
// server.ts
const app = await buildApp();
await app.listen({ port: config.port, host: '0.0.0.0' });

for (const signal of ['SIGINT', 'SIGTERM']) {
  process.on(signal, async () => {
    await app.close();
    process.exit(0);
  });
}
```

## Clientes HTTP externos

- Cliente tipado en `infrastructure/<provider>/`.
- Timeout + retry con backoff donde aplique.
- Tests: MSW o nock — nunca llamar API real en CI.
- Documentar contrato vía `aquelarre-doc-crawler`.

## § NestJS (brownfield)

Si el proyecto usa Nest:

- DTOs con `class-validator` + `ValidationPipe`.
- Services inyectados; controllers delgados.
- Tests: `@nestjs/testing` `TestingModule`.
- E2E: supertest contra `app.getHttpServer()`.
- Mismos principios: domain logic fuera del controller.

## § Express (brownfield)

- Routers modulares; middleware de errores centralizado.
- Tests: **supertest** contra `app` exportado.
- Validación manual con Zod en middleware o handler.
