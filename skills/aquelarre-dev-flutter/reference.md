# Referencia — Desarrollo Flutter (Aquelarre)

## Convenciones genericas

- Seguir arquitectura documentada en el proyecto (`docs/architecture/`).
- Registrar decisiones no obvias en el TASK seccion 7.
- TDD por defecto; tests junto al codigo que cambian.

## Capas (orientativo — confirmar en proyecto)

```
lib/
├── presentation/   # widgets, screens, state (Bloc/Cubit)
├── domain/         # entities, use cases, repository interfaces
└── data/           # repositories impl, datasources, DTOs
```

Si el proyecto usa otra estructura, seguir la existente.

## Estado UI

- Manejar estados explicitos en Cubit/Bloc: initial, loading, loaded, empty, error.
- UI reacciona al estado; evitar flags sueltos en widgets.
- Errores visibles al usuario con opcion de reintento cuando aplique.

## Datos y persistencia

**No hay estrategia unica del harness.** Consultar en el proyecto:

| Si el proyecto tiene… | Leer |
|----------------------|------|
| Cache local + API/Supabase | ADR o `docs/architecture/*sync*` |
| Solo remoto | Repositorios y datasources del modulo |
| Validaciones de formulario | `docs/` de convenciones del repo |

Si no hay documentacion y el cambio es estructural, crear ADR antes de implementar (`aquelarre-architecture-adr`).

## Comandos habituales (evidencia Gate 2)

```bash
flutter test
dart analyze
dart format --set-exit-if-changed .
```

Ajustar segun scripts del proyecto (`melos`, flavors, etc.).

## CI Bitrise (mobile/tablet)

Si `ci=bitrise` en el task:

- Linkear build PASS en evidencia del task.
- No solicitar merge sin build verde salvo override documentado.

## Practicas a evitar

- Acceder a datasources desde widgets directamente.
- Duplicar estado entre capas.
- Hardcodear strings de UI sin localizacion si el proyecto usa l10n.
- Expandir scope del task sin nuevo task o acuerdo.

## Documentacion del proyecto consumidor

Priorizar si existe:

- `docs/VALIDACIONES_Y_TESTS.md`
- `docs/UI_UX_SUPABASE_CODING_PRACTICES.md`
- Patrones en `docs/architecture/`

Estos archivos son **del proyecto**, no del harness Aquelarre.
