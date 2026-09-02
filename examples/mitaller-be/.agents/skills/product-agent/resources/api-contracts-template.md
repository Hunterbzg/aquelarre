# API Contracts Template — AI SDLC Factory

---

# API Contracts — [Project Name]

**Versión**: v1
**Fecha**: [YYYY-MM-DD]
**PRD Reference**: `docs/product/prd-vN.md`
**Data Model Reference**: `docs/architecture/data-model-vN.md`

---

## 1. API Overview

| Property | Value |
|:---|:---|
| **Base URL** | `/api/v1` |
| **Auth** | Bearer JWT (Supabase Auth) |
| **Content-Type** | `application/json` |
| **Versioning** | URL prefix (`/v1/`, `/v2/`) |

---

## 2. Standard Response Format

### Success Response
```json
{
  "id": "uuid",
  "field": "value",
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

### Error Response
```json
{
  "code": "NOT_FOUND",
  "message": "Entity with id 'xxx' not found",
  "details": null
}
```

### Paginated Response
```json
{
  "items": [],
  "total": 100,
  "limit": 20,
  "offset": 0
}
```

---

## 3. Authentication

| Endpoint Pattern | Auth Required | Role |
|:---|:---|:---|
| `GET /health` | ❌ No | - |
| `POST /auth/*` | ❌ No | - |
| `GET /api/v1/*` | ✅ Yes | Authenticated user |
| `POST /api/v1/*` | ✅ Yes | Authenticated user |
| `DELETE /api/v1/admin/*` | ✅ Yes | Admin role |

---

## 4. Endpoints

### Resource: `[entities]`

#### `GET /api/v1/entities`

**Description**: List all entities (paginated)

**Query Parameters**:
| Param | Type | Required | Default | Description |
|:---|:---|:---|:---|:---|
| `limit` | `int` | No | `20` | Items per page (max 100) |
| `offset` | `int` | No | `0` | Pagination offset |
| `status` | `string` | No | - | Filter by status |

**Response** `200 OK`:
```json
{
  "items": [
    {
      "id": "uuid-1",
      "name": "Entity 1",
      "status": "active",
      "created_at": "2024-01-01T00:00:00Z"
    }
  ],
  "total": 50,
  "limit": 20,
  "offset": 0
}
```

---

#### `GET /api/v1/entities/{entity_id}`

**Description**: Get entity by ID

**Path Parameters**:
| Param | Type | Description |
|:---|:---|:---|
| `entity_id` | `UUID` | Entity unique identifier |

**Response** `200 OK`:
```json
{
  "id": "uuid-1",
  "name": "Entity 1",
  "description": "Details",
  "status": "active",
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

**Response** `404 Not Found`:
```json
{
  "code": "NOT_FOUND",
  "message": "Entity with id 'uuid-1' not found",
  "details": null
}
```

---

#### `POST /api/v1/entities`

**Description**: Create a new entity

**Request Body**:
```json
{
  "name": "New Entity",
  "description": "Optional description"
}
```

**Response** `201 Created`:
```json
{
  "id": "uuid-new",
  "name": "New Entity",
  "description": "Optional description",
  "status": "pending",
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

**Response** `422 Validation Error`:
```json
{
  "code": "VALIDATION_ERROR",
  "message": "Validation failed",
  "details": {
    "name": "Field is required"
  }
}
```

---

#### `PATCH /api/v1/entities/{entity_id}`

**Description**: Update entity fields

**Request Body** (all fields optional):
```json
{
  "name": "Updated Name",
  "description": "Updated description"
}
```

**Response** `200 OK`:
```json
{
  "id": "uuid-1",
  "name": "Updated Name",
  "description": "Updated description",
  "status": "active",
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-02T00:00:00Z"
}
```

---

#### `DELETE /api/v1/entities/{entity_id}`

**Description**: Delete entity

**Response** `204 No Content`: _(empty body)_

**Response** `404 Not Found`:
```json
{
  "code": "NOT_FOUND",
  "message": "Entity with id 'uuid-1' not found",
  "details": null
}
```

---

## 5. HTTP Status Codes

| Code | Meaning | When Used |
|:---|:---|:---|
| `200` | OK | Successful GET, PATCH |
| `201` | Created | Successful POST |
| `204` | No Content | Successful DELETE |
| `400` | Bad Request | Malformed request |
| `401` | Unauthorized | Missing or invalid JWT |
| `403` | Forbidden | Valid JWT but insufficient permissions |
| `404` | Not Found | Resource doesn't exist |
| `409` | Conflict | Duplicate resource |
| `422` | Unprocessable Entity | Validation error |
| `500` | Internal Server Error | Unexpected server error |

---

## 6. Rate Limiting

| Scope | Limit | Window |
|:---|:---|:---|
| _[Per user]_ | _[N requests]_ | _[per minute]_ |
| _[Per IP]_ | _[N requests]_ | _[per minute]_ |

---

## 7. Notes

- _[CORS policy and allowed origins]_
- _[Webhook endpoints if applicable]_
- _[File upload patterns if applicable]_
