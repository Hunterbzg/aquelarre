# Task Template — AI SDLC Factory (Definition of Ready)

> **IMPORTANTE**: Este template define la unidad atómica de trabajo. Un Task que no cumpla
> TODOS los campos obligatorios NO puede pasar el Gate 2 y NO puede ser implementado.

---

# TASK-[NNN]: [Título Descriptivo y Específico]

**Story**: STORY-NNN — [Título de la Story]
**Sprint**: Sprint NNN
**Estado**: ⬜ Ready / 🔴 Red (Tests) / 🟢 Green (Implementation) / ♻️ Refactor / ✅ Done
**Tipo**: Feature / Infrastructure / Configuration / Bugfix
**Asignado a**: Coding Agent

---

## 1. Contexto y Objetivo

_¿Qué se va a construir en este task? ¿Cómo se conecta con la story y el epic?_

---

## 2. Archivos a Crear / Modificar

| Archivo | Acción | Descripción |
|:---|:---|:---|
| `app/[ruta]/[archivo].py` | Create / Modify | _[Qué se hace]_ |
| `tests/[ruta]/test_[archivo].py` | Create | _[Tests a escribir]_ |

---

## 3. Criterios de Aceptación

- [ ] **AC-1**: _[Criterio específico y verificable]_
- [ ] **AC-2**: _[Criterio específico y verificable]_
- [ ] **AC-3**: _[Criterio específico y verificable]_

---

## 4. Especificación de Pruebas TDD

> **Estos tests DEBEN escribirse ANTES de la implementación (Fase Red)**

### Tests Unitarios
```python
# tests/[ruta]/test_[nombre].py

def test_[caso_1]():
    """[Descripción: Dado X, cuando Y, entonces Z]"""
    pass

def test_[caso_2]():
    """[Descripción: Dado X, cuando Y, entonces Z]"""
    pass

def test_[caso_error]():
    """[Descripción: Dado input inválido, debe lanzar excepción X]"""
    pass
```

### Tests de Integración (si aplica)
```python
# tests/integration/test_[nombre].py

async def test_[endpoint_happy_path]():
    """[Descripción del flujo de integración]"""
    pass

async def test_[endpoint_error_case]():
    """[Descripción del caso de error]"""
    pass
```

---

## 5. Schemas / Payloads de Ejemplo

### Input
```json
{
}
```

### Output Esperado (Happy Path)
```json
{
}
```

### Output Esperado (Error Case)
```json
{
}
```

---

## 6. Dependencias

| Task Prerequisito | Estado | Artefacto Necesario |
|:---|:---|:---|
| _[TASK-NNN]_ | _[✅ Done / ⬜ Pending]_ | _[Qué se necesita de ese task]_ |

---

## 7. Librerías / Imports Necesarios

- _[librería]: [para qué]_

---

## 8. Notas de Implementación

_Guías técnicas adicionales, patrones a seguir, decisiones de diseño relevantes._

---

## 9. Definition of Ready (DoR) — Checklist

> **TODOS los items deben estar marcados para pasar Gate 2**

- [ ] ID y título descriptivo ✔️
- [ ] Contexto y objetivo claros ✔️
- [ ] Archivos a crear/modificar listados ✔️
- [ ] Criterios de aceptación definidos ✔️
- [ ] Especificación de pruebas TDD completa ✔️
- [ ] Schemas de entrada/salida con ejemplos ✔️
- [ ] Dependencias identificadas y resueltas ✔️
- [ ] Sin ambigüedades — implementable sin preguntas ✔️

---

## 10. Registro de Implementación (llenado por Coding Agent al completar)

### Solución Aplicada
_[Breve descripción de la solución implementada]_

### Comandos de Verificación Ejecutados
```bash
# Tests
pytest tests/[ruta] -v

# Cobertura
pytest --cov=app/[módulo] tests/[ruta]

# Linter
ruff check app/[módulo]

# Type check
mypy app/[módulo]
```

### Resultados
| Verificación | Resultado |
|:---|:---|
| Tests | _[N passed, N failed]_ |
| Cobertura | _[N%]_ |
| Linter | _[Clean / N issues]_ |
| Type Check | _[Clean / N issues]_ |

### Definition of Done (DoD) — Checklist
- [ ] TDD completo (Red → Green → Refactor)
- [ ] Tests 100% green
- [ ] Cobertura ≥ 85%
- [ ] Linter clean (`ruff check`)
- [ ] Formatter applied (`ruff format`)
- [ ] Type check clean (`mypy`)
- [ ] Task actualizada con registro de implementación
- [ ] Gate 3: Usuario aprobó ✅

---

> **Gate 3**: El usuario debe aprobar explícitamente este task antes de proceder al siguiente.
