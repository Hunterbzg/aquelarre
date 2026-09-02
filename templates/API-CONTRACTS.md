---
id: API-<id>
title: <nombre del contrato API>
status: draft | approved | superseded
owner: <rol>
created_at: <YYYY-MM-DD>
updated_at: <YYYY-MM-DD>
links:
  prd: PRD-<id> | null
  adr: ADR-<nnn> | null
  data_model: docs/architecture/data-model-<slug>.md | null
---

# Contratos API — <nombre del proyecto o módulo>

## 1) Overview

| Propiedad | Valor |
|-----------|-------|
| Base URL | `/api/v1` |
| Auth | Bearer JWT (o según ADR) |
| Content-Type | `application/json` |
| Versionado | Prefijo URL (`/v1/`) |

## 2) Formato de respuesta estándar

### Éxito
```json
{
  "id": "uuid",
  "field": "value",
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

### Error
```json
{
  "code": "NOT_FOUND",
  "message": "Entity with id 'xxx' not found",
  "details": null
}
```

### Paginado
```json
{
  "items": [],
  "total": 100,
  "limit": 20,
  "offset": 0
}
```

## 3) Autenticación

| Patrón | Auth | Rol |
|--------|------|-----|
| `GET /health` | No | — |
| `GET /api/v1/*` | Sí | Usuario autenticado |
| `POST /api/v1/*` | Sí | Usuario autenticado |
| Rutas admin | Sí | Rol admin |

## 4) Endpoints

### Recurso: `<entities>`

#### `GET /api/v1/entities`

Listado paginado.

| Query | Tipo | Requerido | Default | Descripción |
|-------|------|-----------|---------|-------------|
| `limit` | int | No | 20 | Máx 100 |
| `offset` | int | No | 0 | Offset |
| `status` | string | No | — | Filtro |

**200 OK:** lista paginada de entidades.

---

#### `GET /api/v1/entities/{entity_id}`

Detalle por ID. **404** si no existe.

---

#### `POST /api/v1/entities`

**Body:**
```json
{
  "name": "New Entity",
  "description": "Optional"
}
```

**201 Created** / **422** validación.

---

#### `PATCH /api/v1/entities/{entity_id}`

Actualización parcial. **200 OK** / **404**.

---

#### `DELETE /api/v1/entities/{entity_id}`

**204 No Content** / **404**.

## 5) Códigos HTTP

| Código | Uso |
|--------|-----|
| 200 | GET, PATCH OK |
| 201 | POST creado |
| 204 | DELETE OK |
| 400 | Request malformado |
| 401 | JWT inválido |
| 403 | Sin permiso |
| 404 | No encontrado |
| 409 | Conflicto / duplicado |
| 422 | Validación |
| 500 | Error interno |

## 6) Notas

- CORS / orígenes permitidos
- Webhooks (si aplica)
- Rate limiting (si aplica)

**Destino sugerido:** `docs/architecture/api-contracts/API-<id>-<slug>.md`
