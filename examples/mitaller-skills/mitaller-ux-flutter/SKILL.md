---
name: mitaller-ux-flutter
description: Define especificaciones UX para cambios de interfaz en Flutter. Usa este skill cuando el task tenga surface UI o sea user-visible, para documentar estados, interacciones, accesibilidad y criterios visuales antes de implementar.
---

# UX Flutter

Fuentes internas:

- `docs/AI_WORKFLOW_SKILLS_SPEC.md` (reglas G1-UX)
- `docs/UI_UX_SUPABASE_CODING_PRACTICES.md`
- `docs/THEME_SYSTEM_UI_SETUP.md`

Referencia ampliada: `reference.md`

## Inputs

- Task con contexto de pantalla/flujo.
- Requisitos PO/AC.
- Restricciones de tema, estados y accesibilidad.

## Outputs

- UX spec linkeada desde el task, o seccion equivalente en task.
- Definicion de estados: loading/empty/error/success.
- Reglas de interaccion y validacion de formularios.

## Instrucciones

1. Si `surface` incluye `ui` y `user_visible=yes`, crear artefacto UX para Gate 1.
2. Incluir como minimo:
   - estructura de pantalla y componentes
   - estados UI
   - validaciones y mensajes
   - accesibilidad minima (contraste, labels, tamanos tactiles)
3. Alinear con patrones ya usados en el repo.
4. Linkear la spec en el task y marcar `N/A` con motivo cuando no aplique.

## Patrones UX validados del proyecto

- AppBar consistente por pantalla:
  - `backgroundColor: theme.scaffoldBackgroundColor`
  - `elevation: 0`
  - titulo con `fontWeight: w600`, `fontSize: 20`
  - color de titulo/iconos con `theme.colorScheme.onBackground` u `onSurface`
- Acciones principales en AppBar con `TextButton.icon` y estilo legible.
- Pantallas con manejo explicito de estado (`loading`, `error`, `empty`, `loaded`) sin estados ambiguos.
- Uso de `ThemeData`/`ColorScheme`/tokens de color en vez de colores literales.

## Criterio de adopcion (hardening)

- Adoptar solo patrones repetidos y estables en `lib/` y docs del repo.
- Si un patron aparece como TODO o no esta consolidado, no convertirlo en estandar.
- Si hay conflicto entre implementacion actual y buenas practicas, preferir la buena practica y documentar el cambio.
