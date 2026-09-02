# Ejemplos — FastAPI

## TDD con spec en TASK §8a

1. Completar §6b (archivos) y §8a (tests + payloads) en el task antes de `ready`.
2. Crear `tests/services/test_entity.py` con casos del task → `pytest` **RED**.
3. Implementar `app/services/entity_service.py` mínimo → **GREEN**.
4. Refactor + `dod-checklist.md` según `risk`.

Ver `tdd-workflow.md` para fixtures y mocks.

## Evidencia task §9

```markdown
### Verificación TASK-042
- pytest tests/services/test_entity.py -v → PASS (6 tests)
- Cobertura app/services → 78% (risk=medium, umbral 70%)
- ruff check . → PASS
- mypy app/services → PASS
- docker compose -f docker-compose.test.yml run --rm test → PASS
```

## Integración API externa

1. `aquelarre-doc-crawler` → `docs/discovery/external-apis/stripe.md`
2. ADR con decisión de integración
3. Cliente en `app/infrastructure/stripe/` + tests con respx
