# Referencia interna UX Flutter

## Objetivo

Resumen de patrones UX del equipo para uso rapido en tareas UI.

## Checklist minimo por pantalla

- Estados `loading`, `empty`, `error`, `success`.
- Mensajes de validacion claros.
- Accesibilidad minima (contraste, etiquetas, touch targets).
- Consistencia con tema y componentes existentes.

## Patron AppBar del proyecto (actual)

- Fondo: `theme.scaffoldBackgroundColor`.
- Elevacion: `0`.
- Titulo: peso `w600`, tamano `20`.
- Color titulo/iconos: `theme.colorScheme.onBackground` (o `onSurface` en pantallas de detalle).
- Acciones primarias: `TextButton.icon` con estilo del tema.

## Buenas practicas a mantener

- Preferir `Theme.of(context).colorScheme` y tokens sobre colores literales.
- Declarar estados vacio/error con CTA de recuperacion cuando aplique.
- Mantener textos de accion cortos y orientados a tarea (`Guardar`, `Actualizar`, `Reintentar`).

## Practicas a NO estandarizar

- No basar nuevos desarrollos en widgets placeholders sin implementar (ejemplo: `lib/common/widgets/custom_app_bar.dart`).
- Evitar hardcodear colores de feedback en nuevas pantallas si existe alternativa semantica en tema/tokens.

## Fuentes internas

- `docs/UI_UX_SUPABASE_CODING_PRACTICES.md`
- `docs/THEME_SYSTEM_UI_SETUP.md`

## Trazabilidad de inspiracion externa

- Basado parcialmente en ideas de:
  - `.cursor/FlutterArmy/skills-main/skills/flutter-building-layouts/SKILL.md`
  - `.cursor/FlutterArmy/skills-main/skills/flutter-building-forms/SKILL.md`
  - `.cursor/FlutterArmy/skills-main/skills/flutter-improving-accessibility/SKILL.md`
