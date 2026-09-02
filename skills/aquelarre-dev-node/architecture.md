# Arquitectura — APIs Node.js

Principios de la industria aplicables a Node, **sin copiar** la estructura Python/FastAPI. El objetivo es separar responsabilidades de forma que el código sea testeable, evolucionable y comprensible para humanos y agentes IA.

## Enfoque: capas + ports (hexagonal lite)

Node no tiene un framework que imponga arquitectura (salvo Nest). Aquelarre recomienda **capas técnicas con boundaries explícitos** y **inyección por constructor/factory** — el patrón más extendido en equipos Node maduros.

```
         HTTP (Fastify routes)
              │
              ▼
         application/     ← casos de uso; coordina domain + ports
              │
      ┌───────┴───────┐
      ▼               ▼
   domain/      infrastructure/   ← adapters: DB, APIs externas, colas
   (puro)            (I/O)
```

### Reglas de dependencia

| Capa | Puede importar | No debe importar |
|------|----------------|------------------|
| `domain/` | nada externo al dominio | Fastify, Drizzle, fetch, process.env |
| `application/` | `domain/`, interfaces (ports) | Implementaciones concretas de DB |
| `infrastructure/` | `domain/`, drivers | `http/` |
| `http/` | `application/`, schemas de transporte | SQL directo, lógica de negocio |

### Ports (interfaces)

Definir contratos en `application/ports/` o junto al service:

```typescript
// application/ports/entity-repository.port.ts
export interface EntityRepository {
  findById(id: string): Promise<Entity | null>;
  create(data: CreateEntityInput): Promise<Entity>;
}
```

La implementación vive en `infrastructure/persistence/drizzle-entity.repository.ts`. Los tests unitarios del service mockean el **port**, no Drizzle.

## Composición: `buildApp()` y wiring

Patrón estándar en Node testeable:

```typescript
// app.ts
export async function buildApp(deps?: Partial<AppDependencies>) {
  const config = loadConfig(); // Zod-validated env
  const db = deps?.db ?? createDb(config.databaseUrl);
  const entityRepo = new DrizzleEntityRepository(db);
  const entityService = new EntityService(entityRepo);

  const app = Fastify({ logger: config.isDev });
  await registerRoutes(app, { entityService });
  await registerErrorHandler(app);
  return app;
}
```

- **`server.ts`**: solo `buildApp()` + `listen()` + graceful shutdown.
- **Tests**: `buildApp({ db: testDb })` con dependencias sustituibles.

## Inyección de dependencias en Node

| Enfoque | Cuándo |
|---------|--------|
| Constructor injection | Default — simple, explícito, fácil de testear |
| Factory functions | Wiring en `app.ts` |
| NestJS DI container | Solo si el proyecto ya es Nest |

No introducir contenedor DI pesado en greenfield Fastify.

## Módulos por feature vs capas técnicas

| Estilo | Pros | Cuándo Aquelarre lo recomienda |
|--------|------|--------------------------------|
| **Capas técnicas** (`domain/`, `application/`, `http/`) | Consistente cross-feature; fácil para agentes | Proyectos API medianos, greenfield |
| **Feature folders** (`features/users/`, `features/orders/`) | Cohesión por dominio | Monolitos modulares grandes |
| **Nest modules** | Framework impone estructura | Repos Nest existentes |

Greenfield: capas técnicas. Si el ADR del proyecto elige feature folders, respetarlo.

## Errores y dominio

- **Errores de dominio**: clases tipadas en `domain/errors/` (`EntityNotFoundError`, `ValidationError`).
- **Errores HTTP**: mapear en capa `http/` a **RFC 7807** Problem Details (ver `api-patterns.md`).
- No usar strings mágicos ni códigos HTTP dispersos en services.

## Configuración (12-factor)

- Variables de entorno validadas **al boot** con Zod (`config/env.ts`).
- Fallar rápido si falta `DATABASE_URL` o secrets.
- `.env.example` documentado; nunca commitear `.env`.

## Observabilidad

- **Pino** (integrado en Fastify): logs JSON en prod, pretty en dev.
- **requestId** por request (header `X-Request-Id` o generado).
- No loggear bodies con PII ni tokens.

## Async y concurrencia

- async/await en todo I/O.
- Operaciones CPU-intensivas: worker threads o cola externa — no en el hot path HTTP.
- Timeouts en llamadas HTTP externas (AbortSignal).

## Coordinación con otros skills

| Cambio | Skill |
|--------|-------|
| Schema/migraciones Postgres | `aquelarre-database-postgres` |
| Auth, RLS, Storage Supabase | `aquelarre-supabase` |
| Contratos OpenAPI ↔ frontend | `aquelarre-dev-react` + `API-CONTRACTS.md` |
