# Definition of Done — Node.js (Gate 2)

Checklist antes de solicitar PR / aprobación humana. Registrar en TASK §9.

## 1) TDD

- [ ] Tests escritos antes de implementar (RED confirmado)
- [ ] Implementación pasa todos los tests (GREEN)
- [ ] Refactor sin romper tests

## 2) Tests y cobertura (por `risk`)

| Riesgo | Mínimo |
|--------|--------|
| `low` | Unit del módulo tocado + check + typecheck |
| `medium` | Unit + integration HTTP (`inject`/supertest) del feature; cobertura módulo ≥ 70% o N/A justificado |
| `high` | Unit + integration HTTP + integration DB si hay persistencia; cobertura módulo ≥ 85% o N/A justificado |

```bash
pnpm test
pnpm test:coverage -- src/application/entity.service.ts  # ejemplo acotado
pnpm test:integration   # si risk=medium|high y hay DB/repos
```

## 3) Calidad

- [ ] `pnpm run check` → sin errores (Biome)
- [ ] `pnpm run typecheck` → sin errores (`tsc --noEmit`)
- [ ] `pnpm run build` → PASS (si el proyecto compila a dist)

## 4) Arquitectura

- [ ] Boundaries respetados (`architecture.md`)
- [ ] Handlers delgados; lógica en application/domain
- [ ] Env validado al boot (Zod)
- [ ] Errores HTTP en formato Problem Details (si aplica API)

## 5) Task

- [ ] AC marcados `[x]` en §3
- [ ] §7 implementación actualizada
- [ ] §9 evidencia con PASS/FAIL explícito

## 6) CI Docker (si `ci=docker`)

- [ ] `docker compose build` → PASS
- [ ] `docker compose -f docker-compose.test.yml run --rm test` → PASS

## Plantilla evidencia §9

```markdown
### Verificación TASK-<id>
- pnpm test → PASS (N tests)
- pnpm test:integration → PASS (M tests) — si aplica
- Cobertura src/application → XX% (risk=medium, umbral 70%)
- pnpm run check → PASS
- pnpm run typecheck → PASS
- docker compose -f docker-compose.test.yml run --rm test → PASS
```

## Excepciones

| Tipo task | DoD reducido |
|-----------|--------------|
| infrastructure / configuration | build + app/health responde; TDD N/A documentado |
| Solo docs/config | lint N/A si no hay código TS tocado |
