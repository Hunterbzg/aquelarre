# Definition of Done — FastAPI (Gate 2)

Checklist antes de solicitar PR / aprobación humana. Registrar en TASK §9.

## 1) TDD

- [ ] Tests escritos antes de implementar (RED confirmado)
- [ ] Implementación pasa todos los tests (GREEN)
- [ ] Refactor sin romper tests

## 2) Tests y cobertura (por `risk`)

| Riesgo | Mínimo |
|--------|--------|
| `low` | Unit + lint en módulo tocado |
| `medium` | Unit + integration API del módulo; cobertura módulo ≥ 70% o N/A justificado |
| `high` | Unit + integration; cobertura módulo ≥ 85% o N/A justificado |

```bash
pytest tests/<ruta> -v
pytest --cov=app/<modulo> tests/<ruta> --cov-report=term-missing
```

## 3) Calidad

- [ ] `ruff check .` → sin errores
- [ ] `ruff format --check .` → sin cambios pendientes
- [ ] `mypy app/<modulo>` → sin errores

## 4) Arquitectura

- [ ] Capas respetadas (ver `reference.md`)
- [ ] Patrones del ADR aplicados

## 5) Task

- [ ] AC marcados `[x]` en §3
- [ ] §7 implementación actualizada
- [ ] §9 evidencia con PASS/FAIL explícito

## 6) CI Docker (si `ci=docker`)

- [ ] `docker compose build` → PASS
- [ ] `docker compose run --rm api pytest` → PASS (o equivalente del proyecto)

## Plantilla evidencia §9

```markdown
### Verificación TASK-<id>
- pytest tests/services/test_entity.py -v → PASS (N tests)
- Cobertura app/services → XX% (risk=medium, umbral 70%)
- ruff check . → PASS
- mypy app/services → PASS
- docker compose run --rm api pytest → PASS
```
