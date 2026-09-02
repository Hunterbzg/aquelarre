---
name: aquelarre-ux-web
description: Define especificaciones UX para interfaces web en React con Material Design 3. Usa este skill cuando el task tenga surface UI, platform web y sea user-visible, para documentar vistas, estados, responsive y accesibilidad antes de implementar.
---

# UX Web (React + Material Design 3)

Fuentes:

- `docs/AI_WORKFLOW_SKILLS_SPEC.md` — G1-UX
- `templates/UX.md`
- Design system del proyecto (`docs/ux/`, MUI Material 3 o equivalente)

## Objetivo

Definir comportamiento de UI web verificable: vistas, estados, responsive y a11y antes de implementar en React.

## Inputs

- Task con `platform: web`.
- Requisitos PO/AC.
- Librería UI del proyecto (MUI, custom tokens).

## Outputs

- UX spec en `docs/ux/specs/UX-<id>-<slug>.md`.
- Estados: loading, empty, error, success.
- Breakpoints responsive y navegación (router).

## Gates que aplica

- **Gate 1 (G1-UX-001):** `surface` incluye `ui` + `user_visible=yes` + `platform: web`.

## Instrucciones

1. Especificar vistas/rutas afectadas y componentes M3 (o design system del proyecto).
2. Estados UI obligatorios en cada vista principal.
3. Responsive: mobile-first o desktop-first según proyecto; breakpoints explícitos.
4. Formularios: validación inline, estados disabled/loading en submit.
5. A11y: roles ARIA, labels, foco de teclado, contraste WCAG AA.
6. Navegación: rutas, breadcrumbs, estados de URL/query params si aplica.
7. Linkear spec en task; `N/A` con motivo si no hay UI.

## Principios M3 web

- Tokens de tema (color, typography, elevation).
- Componentes: Button, TextField, Dialog, DataGrid según necesidad.
- Evitar estilos inline hardcodeados cuando existan tokens.

## Coordinación

| Implementación | Skill |
|----------------|-------|
| React + TDD | `aquelarre-dev-react` |
| API backend | `aquelarre-dev-fastapi` / `aquelarre-dev-node` |
| Contenedores | `aquelarre-docker` |

## Artefactos

| Artefacto | Ruta |
|-----------|------|
| UX spec | `docs/ux/specs/UX-<id>-<slug>.md` |
