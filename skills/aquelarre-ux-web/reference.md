# Referencia — UX Web

## Checklist por vista

- [ ] Ruta y título de página
- [ ] Estados: loading, empty, error, loaded
- [ ] Responsive: sm / md / lg (o breakpoints del proyecto)
- [ ] Acciones primarias y secundarias visibles
- [ ] Mensajes de error comprensibles
- [ ] Foco y navegación por teclado

## Formularios web

- `aria-invalid`, `aria-describedby` para errores
- Submit deshabilitado o loading durante request
- Prevención de doble submit

## Patrones comunes

| Patrón | Notas |
|--------|-------|
| List + detail | Rutas anidadas o query `?id=` |
| Modal / drawer | Cuándo cada uno |
| Snackbar / toast | Feedback de acciones async |
| Skeleton loaders | Preferir sobre spinner genérico en listas |

## Evidencia visual (QA)

Capturas en `docs/testing/evidence/` (gitignored); referencia en task §9.
