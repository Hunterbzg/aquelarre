# Ejemplos — Discovery

## Ejemplo A: Proyecto nuevo (greenfield)

```markdown
## Superficies objetivo
- mobile (Flutter) → ci: bitrise
- backend (FastAPI) → ci: docker

## Riesgos
| Riesgo | Mitigación |
|--------|------------|
| Auth multi-rol | ADR + skill supabase en Gate 1 |
```

## Ejemplo B: Repo existente

```markdown
## Estado actual
- Flutter app en `lib/`, sin `bitrise.yml`
- Supabase configurado, RLS parcial en `users`
- Gap: falta discovery de dominio "inventario" documentado

## Próximos pasos
- [ ] Crear DISCOVERY-002-inventario (dominio acotado)
- [ ] ADR sync strategy si no existe en `docs/architecture/`
```

## Ejemplo C: N/A en task

```markdown
Discovery: N/A — bug de tipografía en un botón; dominio conocido, sin cambio estructural.
```
