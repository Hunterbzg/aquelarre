# Docker Patterns — AI SDLC Factory

> **Propósito**: Patrones de contenedorización para aplicaciones FastAPI.

---

## Dockerfile Multi-Stage

```dockerfile
# ============================================
# Stage 1: Builder — Install dependencies
# ============================================
FROM python:3.11-slim AS builder

WORKDIR /build

# Install system dependencies for building
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency files
COPY pyproject.toml ./
COPY requirements.lock ./

# Install Python dependencies
RUN pip install --no-cache-dir --prefix=/install -r requirements.lock

# ============================================
# Stage 2: Runner — Production image
# ============================================
FROM python:3.11-slim AS runner

WORKDIR /app

# Create non-root user for security
RUN groupadd --gid 1000 appuser && \
    useradd --uid 1000 --gid 1000 --create-home appuser

# Copy installed dependencies from builder
COPY --from=builder /install /usr/local

# Copy application code
COPY app/ ./app/

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import httpx; httpx.get('http://localhost:8000/health')" || exit 1

# Run with uvicorn
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

---

## Docker Compose — Development

```yaml
# docker-compose.yml
version: "3.8"

services:
  api:
    build:
      context: .
      dockerfile: Dockerfile
      target: runner
    ports:
      - "8000:8000"
    volumes:
      - ./app:/app/app  # Hot reload in development
    env_file:
      - .env
    environment:
      - DEBUG=true
    command: >
      uvicorn app.main:app
      --host 0.0.0.0
      --port 8000
      --reload
      --log-level info
    restart: unless-stopped

  # Optional: local PostgreSQL for development without Supabase
  # db:
  #   image: postgres:15-alpine
  #   environment:
  #     POSTGRES_DB: myapp
  #     POSTGRES_USER: postgres
  #     POSTGRES_PASSWORD: postgres
  #   ports:
  #     - "5432:5432"
  #   volumes:
  #     - postgres_data:/var/lib/postgresql/data

# volumes:
#   postgres_data:
```

---

## Docker Compose — Testing

```yaml
# docker-compose.test.yml
version: "3.8"

services:
  test:
    build:
      context: .
      dockerfile: Dockerfile
      target: runner
    volumes:
      - ./app:/app/app
      - ./tests:/app/tests
      - ./pyproject.toml:/app/pyproject.toml
    env_file:
      - .env.test
    command: >
      pytest tests/ -v --cov=app --cov-report=term-missing
```

**Ejecutar tests en Docker**:
```bash
docker compose -f docker-compose.test.yml run --rm test
```

---

## .dockerignore

```
# .dockerignore
.git
.gitignore
.env
.env.*
__pycache__
*.pyc
.pytest_cache
.mypy_cache
.ruff_cache
.coverage
htmlcov/
docs/
tests/
*.md
docker-compose*.yml
Dockerfile
.agents/
```

---

## Health Check Endpoint

```python
# app/api/v1/endpoints/health.py
from fastapi import APIRouter

router = APIRouter(tags=["health"])


@router.get("/health")
async def health_check():
    return {"status": "healthy"}
```

---

## Environment Files

### .env (development)
```bash
# .env
APP_NAME=MyAPI
DEBUG=true
API_V1_PREFIX=/api/v1

# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

### .env.test (testing)
```bash
# .env.test
APP_NAME=MyAPI-Test
DEBUG=true
API_V1_PREFIX=/api/v1

# Use test Supabase project or mocked values
SUPABASE_URL=https://test-project.supabase.co
SUPABASE_ANON_KEY=test-anon-key
SUPABASE_SERVICE_ROLE_KEY=test-service-role-key
```
