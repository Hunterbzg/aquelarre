---
id: TASK-<id>
title: <título corto y específico>
type: bug | feature | chore | refactor | spike
surface: ui | domain | data | db | auth | infra | ci | docs
platform: mobile | tablet | web | backend | mixed
risk: low | medium | high
size: xs | s | m | l | xl
status: intake | ready | in_progress | in_review | blocked | done | cancelled
user_visible: yes | no
db_change: none | query | schema | rls_policy | storage
tdd: on | off
ci: bitrise | docker | none
owner: <persona/rol>
created_at: <YYYY-MM-DD>
updated_at: <YYYY-MM-DD>
parent:
  epic: EPIC-<id> | null
  story: STORY-<id> | null
links:
  branch: <branch-name> | null
  pr: <url> | null
  commits: []
  designs: []
  adr: []
  supabase: []
---

## 1) Resumen
- **Problema**: ...
- **Objetivo**: ...
- **No-alcance**: ...

## 2) Contexto
- **Antecedentes**: ...
- **Stakeholders** (si aplica): ...
- **Estado actual**: ...

## 3) Definición de éxito
### Criterios de aceptación (AC)
- [ ] AC1: ...
- [ ] AC2: ...

### Definition of Done (DoD)
- [ ] Código formateado y lint OK
- [ ] Tests requeridos ejecutados y pasando
- [ ] Documentación/artefactos actualizados
- [ ] PR revisado y mergeado (si aplica)

## 4) Clasificación (para Router)
- **Tipo**: `<type>`
- **Superficie**: `<surface>`
- **Plataforma**: `<platform>`
- **CI**: `<ci>`
- **Riesgo**: `<risk>`
- **Requiere PO**: sí/no
- **Requiere UX**: sí/no
- **Requiere ADR**: sí/no
- **TDD**: on/off

## 5) Artefactos requeridos por workflow (gates)
### Gate 0 — Intake
- [ ] Task completo hasta sección 4
- [ ] AC definidos

### Gate 1 — Ready for Dev
- [ ] PO brief/PRD: `...` o `N/A`
- [ ] UX spec: `...` o `N/A`
- [ ] ADR: `...` o `N/A`
- [ ] Test plan (sección 8 o link)

### Gate 2 — Ready for PR
- [ ] Implementación (sección 7)
- [ ] Evidencia tests (sección 9)
- [ ] CI PASS (Bitrise/Docker) o `N/A` justificado

### Gate 3 — Done
- [ ] PR mergeado
- [ ] Post-checks (sección 10)

## 6) Plan técnico (antes de codear)
- **Approach**: ...
- **Cambios esperados**: ...
- **Riesgos técnicos**: ...
- **Rollback plan** (si aplica): ...

### 6b) Archivos a crear/modificar (opcional — recomendado si `platform=backend`)

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `src/...` o `app/...` | Create / Modify | Código según stack (Node / Python) |
| `tests/...` | Create | Tests TDD (`.test.ts` o `test_*.py`) |

## 7) Implementación (registro operativo)
### <YYYY-MM-DD>
- ...

## 8) Test plan
- Unit: ...
- Widget/Component (web/mobile): ...
- Integration API: ...
- E2E: ... o `N/A` con motivo

### 8a) Especificación TDD (obligatorio si `platform=backend` y `tdd=on`)

> Escribir los tests **antes** del código (Gate 1). El agente debe confirmar RED en implementación.

**Tipo de task:** feature | bugfix | infrastructure | configuration

> Usar **Python** si stack FastAPI · **TypeScript** si stack Node.js.

#### Tests unitarios (Python / FastAPI)

```python
# tests/<ruta>/test_<modulo>.py
def test_<caso_happy_path>():
    """Dado ..., cuando ..., entonces ..."""
    ...

def test_<caso_error>():
    """Dado input inválido, entonces ..."""
    ...
```

#### Tests unitarios (TypeScript / Node)

```typescript
// tests/unit/<modulo>.test.ts
import { describe, it, expect, vi } from 'vitest';

describe('<Service>', () => {
  it('should <comportamiento> when <condición>', async () => {
    // Arrange — mock ports
    // Act
    // Assert
  });
});
```

#### Tests integración API (Python)

```python
async def test_<endpoint>_success(async_client):
    ...
```

#### Tests integración API (Node — Fastify)

```typescript
// tests/integration/<feature>.routes.test.ts
it('POST /v1/<resource> returns 201', async () => {
  const app = await buildTestApp();
  const res = await app.inject({ method: 'POST', url: '/v1/...', payload: {} });
  expect(res.statusCode).toBe(201);
  await app.close();
});
```

#### Schemas / payloads de ejemplo

**Request:**
```json
{ "field": "value" }
```

**Response esperado:**
```json
{ "id": "uuid", "field": "value" }
```

## 9) Evidencia de verificación
- Comandos: ...
- Resultado: PASS | FAIL
- CI: <link Bitrise/GitHub Actions> o `N/A`

## 10) Post-merge / cierre
- ...
