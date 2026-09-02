---
name: aquelarre-docker
description: Gestiona contenedores y entornos Docker para web y backend. Usa este skill cuando platform sea web o backend, ci=docker, o haga falta docker-compose, Dockerfiles, entornos locales reproducibles o evidencia Gate 2 en pipeline containerizado.
---

# Docker (web / backend)

Fuentes:

- `docs/VISION.md` — stack web/backend + Docker
- `reference.md` — compose, evidencia, buenas prácticas

## Objetivo

Entornos locales y CI reproducibles para React, FastAPI y Node.js mediante contenedores.

## Inputs

- Task con `platform: web|backend` o `ci: docker`.
- Stack del servicio (React, FastAPI, Node).
- Requisitos de dependencias (Postgres, Redis, Supabase local si aplica).

## Outputs

- `Dockerfile` y/o `docker-compose.yml` (o actualización).
- Scripts o documentación de `docker compose up` para desarrollo.
- Evidencia Gate 2: tests/build en contenedor PASS.

## Gates que aplica

- **Gate 1 (proyecto nuevo web/backend):** `docker-compose.yml` o equivalente operativo.
- **Gate 2:** tests/lint en entorno containerizado PASS (o local equivalente documentado).

## Instrucciones

1. Preferir multi-stage builds para producción; imagen de dev más simple si el proyecto lo separa.
2. `docker-compose.yml` típico:
   - servicio app (web o API)
   - servicios de dependencia (db, cache) si no usan Supabase cloud exclusivamente
3. No commitear secretos; usar `.env.example` y variables de entorno.
4. Documentar en task o README del proyecto:
   - `docker compose up --build`
   - comando de tests dentro del contenedor
5. Para Gate 2: ejecutar tests en contenedor o pipeline CI Docker; registrar PASS/FAIL.
6. Alinear puertos y healthchecks con convenciones del proyecto.

## Coordinación

| Stack | Skill dev |
|-------|-----------|
| React | `aquelarre-dev-react` |
| FastAPI | `aquelarre-dev-fastapi` |
| Node | `aquelarre-dev-node` |
| Supabase local/cloud | `aquelarre-supabase` |

## Artefactos

| Artefacto | Ruta |
|-----------|------|
| Compose | `docker-compose.yml` |
| Dockerfile(s) | `Dockerfile`, `docker/` |
| Env ejemplo | `.env.example` |
| Evidencia | Task §9 |
