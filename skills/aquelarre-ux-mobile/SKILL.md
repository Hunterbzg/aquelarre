---
name: aquelarre-ux-mobile
description: Define especificaciones UX para cambios de interfaz en Flutter (telefono). Usa este skill cuando el task tenga surface UI, platform mobile y sea user-visible, para documentar estados, interacciones, accesibilidad y criterios Material Design 3 antes de implementar.
---

# UX Mobile (Flutter + Material 3)

Fuentes:

- `docs/AI_WORKFLOW_SKILLS_SPEC.md` (reglas G1-UX, Apéndice C)
- `reference.md` — checklist M3 y a11y
- `examples.md` — patrones de spec
- Design system del **proyecto consumidor** (si existe: `docs/ux/`, `docs/architecture/`)

## Objetivo

Definir comportamiento de UI verificable antes de implementar, alineado a Material Design 3 y consistencia del repo.

## Inputs

- Task con contexto de pantalla o flujo (`platform: mobile`).
- Requisitos PO/AC linkeados.
- Tema y componentes existentes en el proyecto.

## Outputs

- UX spec en `docs/ux/specs/UX-<id>-<slug>.md` o seccion UX equivalente en el task.
- Estados UI: loading, empty, error, success/loaded.
- Reglas de interaccion, validacion de formularios y a11y minima.

## Gates que aplica

- **Gate 1 (G1-UX-001):** si `surface` incluye `ui` y `user_visible=yes` → UX spec o seccion con estados + interacciones + a11y.

## Instrucciones

1. Confirmar que aplica UX (user-visible + superficie UI). Si no, marcar `N/A` con motivo en el task.
2. Incluir en la spec como minimo:
   - contexto y pantallas/flujos afectados
   - estructura de pantalla y componentes M3
   - estados UI (loading, empty, error, success)
   - flujo happy path y casos borde
   - validaciones y mensajes de error
   - accesibilidad: contraste, semantics/labels, targets tactiles (~48dp)
   - navegacion (origen, destino, back)
3. Alinear con **design system del proyecto** si existe (`docs/ux/rules/`, tokens de tema). Si no existe, usar M3 por defecto y documentar decisiones visuales en la spec.
4. Para formularios: estados de campo, teclado, mensajes inline.
5. Linkear UX spec desde el task (trazabilidad Gate 1).
6. No copiar valores visuales hardcodeados del harness; cada proyecto define su tema.

## Principios M3 (genericos)

- Usar `ThemeData` / `ColorScheme` / tokens — evitar colores literales.
- Componentes M3 preferidos (FilledButton, OutlinedButton, NavigationBar, etc.).
- Estados vacio/error con CTA de recuperacion cuando aplique.
- Textos de accion cortos y orientados a tarea (`Guardar`, `Reintentar`).

## Criterio de adopcion

- Adoptar solo patrones **estables y repetidos** en el repo del proyecto.
- No estandarizar widgets placeholder, TODO o experimentos no consolidados.
- Si hay conflicto entre codigo actual y M3/accesibilidad, preferir buena practica y documentar en UX spec o ADR.

## Artefactos

| Artefacto | Ruta |
|-----------|------|
| UX spec | `docs/ux/specs/UX-<id>-<slug>.md` |
| Reglas UX estables (opcional) | `docs/ux/rules/` |
| Template | Apéndice C del `AI_WORKFLOW_SKILLS_SPEC.md` |
