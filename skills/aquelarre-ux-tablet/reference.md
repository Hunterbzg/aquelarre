# Referencia — UX Tablet

## Patrones M3 adaptativos

| Patrón | Cuándo |
|--------|--------|
| Master-detail | Lista + detalle simultáneos en ancho ≥ ~600dp |
| Navigation rail | Navegación principal con muchas secciones |
| Canonical layouts | List-detail, supporting pane (M3 guidelines) |
| Dialog vs bottom sheet | En tablet preferir dialogs centrados o side sheets |

## Checklist tablet

- [ ] Breakpoints definidos en la spec
- [ ] Comportamiento portrait / landscape
- [ ] Master-detail: qué pasa al rotar
- [ ] Empty/error en panel secundario vs pantalla completa
- [ ] Teclado físico / shortcuts (si aplica desktop-like)

## Compartir con mobile

Si mobile y tablet comparten flujo:

- Una UX spec con secciones **Mobile** y **Tablet**, o
- Dos specs linkeadas desde el mismo task

No duplicar estados de negocio; sí detallar layout por form factor.
