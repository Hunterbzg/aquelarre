---
name: aquelarre-ux-tablet
description: Define especificaciones UX para Flutter en tablet (layouts adaptativos). Usa este skill cuando el task tenga surface UI, platform tablet y sea user-visible, para documentar breakpoints, paneles, estados y accesibilidad Material Design 3.
---

# UX Tablet (Flutter + Material 3 adaptativo)

Fuentes:

- `aquelarre-ux-mobile` — base de estados, a11y y M3 (mismos principios)
- `docs/AI_WORKFLOW_SKILLS_SPEC.md` — G1-UX, Apéndice C / `templates/UX.md`
- Design system del proyecto consumidor

## Objetivo

Definir UX verificable para form factor tablet: layouts multi-panel, navegación adaptativa y uso del espacio.

## Inputs

- Task con `platform: tablet`.
- Requisitos PO/AC y UX mobile relacionada (si comparten flujo).
- Breakpoints y patrones existentes en el repo.

## Outputs

- UX spec en `docs/ux/specs/UX-<id>-<slug>.md`.
- Reglas de layout: master-detail, navigation rail, paneles simultáneos.
- Estados UI y a11y (igual que mobile).

## Gates que aplica

- **Gate 1 (G1-UX-001):** `surface` incluye `ui` + `user_visible=yes` + `platform: tablet`.

## Instrucciones

1. Además del checklist mobile, especificar:
   - breakpoints (ej. ancho mínimo tablet, orientación)
   - layout en portrait vs landscape
   - navegación: `NavigationRail`, `NavigationDrawer`, tabs, master-detail
   - qué contenido es compartido vs duplicado respecto a mobile
2. Estados obligatorios: loading, empty, error, success/loaded.
3. Targets táctiles y densidad de información (más contenido visible que en phone).
4. Si el proyecto usa `LayoutBuilder`, `AdaptiveLayout` o paquete responsive, alinear la spec.
5. Linkear UX spec desde el task; `N/A` con motivo si no hay cambio visual.

## Diferencias clave vs mobile

| Aspecto | Tablet |
|---------|--------|
| Navegación | Rail/drawer, paneles laterales |
| Layout | Dos columnas, list-detail |
| Orientación | Portrait y landscape explícitos |
| Densidad | Más datos por pantalla; evitar stretch vacío |

## Artefactos

| Artefacto | Ruta |
|-----------|------|
| UX spec | `docs/ux/specs/UX-<id>-<slug>.md` |
| Template | `templates/UX.md` |
