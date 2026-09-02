# Ejemplos — Node.js

## TDD feature completa (Fastify)

1. TASK §8a: casos unit (EntityService) + integration (POST /v1/entities)
2. RED: `tests/unit/entity.service.test.ts` + `tests/integration/entities.routes.test.ts` fallan
3. GREEN: `EntityService`, `DrizzleEntityRepository`, route plugin
4. REFACTOR: Biome + typecheck + DoD según `risk`

## Evidencia task §9

```markdown
### Verificación TASK-050
- pnpm test → PASS (14 tests)
- pnpm test:integration → PASS (4 tests)
- Cobertura src/application → 82% (risk=high, umbral 85% — pendiente 1 branch)
- pnpm run check → PASS
- pnpm run typecheck → PASS
- docker compose -f docker-compose.test.yml run --rm test → PASS
```

## Integración API externa

1. `aquelarre-doc-crawler` → `docs/discovery/external-apis/stripe.md`
2. ADR con decisión de integración
3. Cliente en `src/infrastructure/stripe/` + tests con MSW

## Brownfield Nest

- No reestructurar a capas Fastify en un task
- TDD con `@nestjs/testing`; e2e con supertest
- DoD igual: tests + lint + typecheck + evidencia §9

## Brownfield Express + Jest

- Mantener Jest si ya existe suite grande
- Aplicar mismos principios de capas donde el repo lo permita
- supertest para integration HTTP
