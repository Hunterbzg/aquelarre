# Referencia — Docker (Aquelarre)

## Dockerfile multi-stage (Node.js / TypeScript)

```dockerfile
FROM node:20-alpine AS deps
WORKDIR /app
RUN corepack enable pnpm
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

FROM node:20-alpine AS builder
WORKDIR /app
RUN corepack enable pnpm
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN pnpm run build

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
RUN addgroup -g 1000 appuser && adduser -u 1000 -G appuser -D appuser
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package.json ./
USER appuser
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget -qO- http://localhost:3000/health || exit 1
CMD ["node", "dist/server.js"]
```

## docker-compose.yml (Node — desarrollo)

```yaml
services:
  api:
    build: { context: ., target: runner }
    ports: ["3000:3000"]
    volumes: ["./src:/app/src"]
    env_file: [.env]
    command: pnpm dev
```

## Tests en contenedor (Node)

```yaml
# docker-compose.test.yml
services:
  test:
    build: { context: ., target: deps }
    volumes: ["./src:/app/src", "./tests:/app/tests"]
    env_file: [.env.test]
    environment:
      DOCKER_HOST: unix:///var/run/docker.sock  # Testcontainers en Linux CI
    command: pnpm test
```

```bash
docker compose -f docker-compose.test.yml run --rm test
```

Ver `skills/aquelarre-dev-node/dod-checklist.md` para evidencia Gate 2 Node.

## .dockerignore (Node — añadir)

```
node_modules/
dist/
coverage/
.turbo/
```

## Dockerfile multi-stage (FastAPI)

```dockerfile
FROM python:3.11-slim AS builder
WORKDIR /build
RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*
COPY pyproject.toml ./
RUN pip install --no-cache-dir --prefix=/install .

FROM python:3.11-slim AS runner
WORKDIR /app
RUN groupadd --gid 1000 appuser && useradd --uid 1000 --gid 1000 --create-home appuser
COPY --from=builder /install /usr/local
COPY app/ ./app/
USER appuser
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

## docker-compose.yml (desarrollo)

```yaml
services:
  api:
    build: { context: ., target: runner }
    ports: ["8000:8000"]
    volumes: ["./app:/app/app"]
    env_file: [.env]
    environment: { DEBUG: "true" }
    command: uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

## Tests en contenedor

```yaml
# docker-compose.test.yml
services:
  test:
    build: { context: ., target: runner }
    volumes:
      - ./app:/app/app
      - ./tests:/app/tests
    env_file: [.env.test]
    command: pytest tests/ -v --cov=app --cov-report=term-missing
```

```bash
docker compose -f docker-compose.test.yml run --rm test
```

## .dockerignore

```
.git
.env
.env.*
__pycache__
.pytest_cache
.mypy_cache
.ruff_cache
.coverage
htmlcov/
docs/
tests/
*.md
.agents/
.cursor/
```

## Evidencia Gate 2

```markdown
- docker compose build → PASS
- docker compose run --rm test → PASS
```

## Web (React)

- Dev: app local + API en Docker, o full stack en compose
- Prod: nginx estático o Node SSR según arquitectura

## Cuándo no usar Docker

- `platform: mobile|tablet` → `aquelarre-bitrise`
- `ci: none` → justificar en task
