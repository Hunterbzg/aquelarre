# Referencia — UX Mobile (Flutter + M3)

## Checklist minimo por pantalla

- [ ] Estados: `loading`, `empty`, `error`, `success` / `loaded`
- [ ] Happy path documentado paso a paso
- [ ] Validaciones y mensajes de error claros
- [ ] Accesibilidad: contraste, `Semantics`/labels, touch targets
- [ ] Consistencia con tema y componentes del proyecto
- [ ] Navegacion y back definidos

## Material Design 3

| Area | Guia |
|------|------|
| Color | `colorScheme` semantico (primary, surface, error) |
| Tipografia | `textTheme` del tema |
| Componentes | Preferir catalogo M3 sobre custom |
| Elevacion | Segun design system del proyecto o M3 defaults |
| Form factors | Mobile: una columna; considerar safe area y teclado |

## Formularios

- `keyboardType`, `textInputAction`, `maxLines` segun campo
- Validacion inline + mensaje bajo el campo
- Estado disabled/loading en submit
- Focus order logico

## Accesibilidad (a11y)

- Contraste minimo WCAG AA donde aplique
- Labels en iconos y botones sin texto
- Targets tactiles ~48x48 logical pixels
- Anuncios de estado para screen readers en cambios criticos

## Design system del proyecto consumidor

**Priorizar** sobre esta referencia si existen:

- `docs/ux/DESIGN_SYSTEM.md` o similar
- `docs/ux/rules/flutter-ux-rules.md`
- `docs/THEME_SYSTEM_UI_SETUP.md` (especifico del proyecto)

El harness no impone AppBar, espaciados ni tokens concretos; el proyecto los define.

## Practicas a evitar en nuevas pantallas

- Colores hex hardcodeados cuando el tema cubre el caso
- Estados ambiguos (pantalla en blanco sin loading/error)
- Copiar widgets no finalizados o marcados TODO como estandar

## Inspiracion (opcional)

Skills oficiales Flutter en `examples/skills-main/` del repo Aquelarre:

- `flutter-building-layouts`
- `flutter-building-forms`
- `flutter-improving-accessibility`
- `flutter-theming-apps`
