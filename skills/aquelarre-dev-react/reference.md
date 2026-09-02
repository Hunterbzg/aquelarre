# Referencia — React

## Estructura orientativa

```
src/
├── components/
├── pages/ o routes/
├── hooks/
├── services/     # API clients
├── theme/        # M3 tokens
└── App.tsx
```

## Comandos evidencia

```bash
npm test
npm run lint
npm run build
```

## Testing Library

- Queries por rol/label, no por className frágil
- `userEvent` para interacciones
- Mock de fetch/API en tests de página

## Estado y datos

- Server state: React Query / SWR según proyecto
- UI state: useState o store global si ya existe
- No duplicar fuente de verdad del servidor en estado local innecesario

## M3 / UI

- Preferir componentes del design system del proyecto
- Responsive con breakpoints documentados en UX spec
