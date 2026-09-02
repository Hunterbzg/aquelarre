---
name: aquelarre-dev-react
description: Implementa cambios en frontend React siguiendo el workflow Aquelarre. Usa este skill para tasks ready con platform web, TDD por defecto, estados UI segun UX spec y evidencia en tests/CI Docker.
---

# Desarrollo React

Fuentes:

- `docs/AI_WORKFLOW_SKILLS_SPEC.md` — Dev + Gate 2
- `reference.md` — convenciones React + M3
- `examples.md`
- UX spec linkeada (`aquelarre-ux-web`)

## Objetivo

Implementar vistas y componentes React con tests, alineados a UX spec y design system del proyecto.

## Inputs

- Task en `ready`, `platform: web`.
- UX spec si `user_visible=yes`.
- Stack: React, router, state management del proyecto.

## Outputs

- Componentes y páginas acotadas al task.
- Tests (Vitest/Jest + Testing Library).
- Evidencia Gate 2 en task §9.

## Gates que aplica

- **Gate 2:** tests + lint + build + CI Docker si `ci=docker`.

## Reglas operativas

1. No code before task; branch antes de codear.
2. TDD por defecto; component tests para UI user-visible.
3. Estados UI según UX: loading, empty, error, loaded.
4. Tokens de tema M3; evitar colores hardcodeados.
5. Data fetching según patrón del proyecto (React Query, SWR, etc.).
6. Coordinar con `aquelarre-docker` para entorno dev/CI.

## Checklist

- [ ] Leer UX spec y AC
- [ ] Tests component/integration
- [ ] `npm test`, lint, `npm run build`
- [ ] Evidencia en task §9

## Coordinación

| Necesidad | Skill |
|-----------|-------|
| UX | `aquelarre-ux-web` |
| Docker | `aquelarre-docker` |
| API | `aquelarre-dev-fastapi` / `aquelarre-dev-node` |
| PR | `aquelarre-github` |
