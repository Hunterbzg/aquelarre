# Definition of Done (DoD) Checklist — AI SDLC Factory

> **Propósito**: Checklist obligatorio para verificar que un Task está completamente terminado antes de solicitar Gate 3.

---

## DoD Checklist

### 1. TDD Completo
- [ ] Tests escritos ANTES de la implementación (fase Red confirmada)
- [ ] Implementación hace pasar TODOS los tests (fase Green confirmada)
- [ ] Código refactorizado manteniendo tests en verde (fase Refactor completada)

### 2. Tests
- [ ] Todos los tests pasan: `pytest tests/[ruta] -v` → 100% green
- [ ] Cobertura de código ≥ 85%: `pytest --cov=app/[módulo] tests/[ruta]`
- [ ] Tests cubren happy path, edge cases y error cases

### 3. Calidad de Código
- [ ] Linter clean: `ruff check .` → sin errores
- [ ] Formatter applied: `ruff format .` → sin cambios pendientes
- [ ] Type check clean: `mypy app/[módulo]` → sin errores

### 4. Arquitectura
- [ ] Código sigue Clean Architecture (separación de capas correcta)
- [ ] No hay imports que violen la regla de dependencias
- [ ] Patrones del ADR aplicados correctamente

### 5. Documentación del Task
- [ ] Criterios de aceptación marcados como completados (`[x]`)
- [ ] Registro de implementación completado:
  - Solución aplicada
  - Comandos de verificación ejecutados
  - Resultados de tests, cobertura, linter, type check
- [ ] Estado del task actualizado a ✅ Done

### 6. Integración
- [ ] Código no rompe tests existentes: `pytest -v` (suite completa)
- [ ] No hay conflictos con otros componentes

---

## Comandos de Verificación

```bash
# 1. Tests del task específico
pytest tests/[ruta] -v

# 2. Suite completa
pytest -v

# 3. Cobertura
pytest --cov=app --cov-report=term-missing

# 4. Linter
ruff check .

# 5. Formatter
ruff format --check .

# 6. Type checking
mypy app/

# 7. Todo junto (script de verificación)
ruff check . && ruff format --check . && mypy app/ && pytest -v --cov=app
```

---

## Resultado Esperado para Gate 3

Al solicitar Gate 3, el Coding Agent debe presentar al usuario:

```
✅ TASK-NNN: [Título] — DEFINITION OF DONE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 TDD Cycle:
  🔴 Red:      Tests written and confirmed failing
  🟢 Green:    Implementation passes all tests
  ♻️  Refactor: Code cleaned and optimized

🧪 Tests:     X passed, 0 failed
📊 Coverage:  XX.X%
🔍 Linter:    Clean (0 issues)
📐 Formatter: Applied
🔒 Types:     Clean (0 errors)

📋 Acceptance Criteria:
  ✅ AC-1: [Criterio]
  ✅ AC-2: [Criterio]
  ✅ AC-3: [Criterio]

👤 Waiting for your approval to proceed to the next task.
```
