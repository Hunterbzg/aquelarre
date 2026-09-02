# Referencia — Discovery

## Checklist de exploración (codebase existente)

- [ ] README y docs en `docs/`
- [ ] Stack: Flutter, React, FastAPI, Node, Supabase
- [ ] CI: `bitrise.yml`, `docker-compose.yml`, GitHub Actions
- [ ] Estructura de carpetas y capas
- [ ] Tests existentes y cobertura aproximada
- [ ] Deuda técnica visible (TODOs, ADRs pendientes)

## Preguntas guía para el humano

1. ¿Quién usa el producto y en qué contexto?
2. ¿Qué problema resuelve hoy y qué no resuelve?
3. ¿Qué plataformas son obligatorias (móvil, web, API)?
4. ¿Hay restricciones legales, offline, o integraciones externas?
5. ¿Cuál es el criterio de éxito en 3–6 meses?

## Salida mínima verificable

El discovery está **listo para aprobar** cuando un humano puede responder "sí" a:

- Entiendo el problema y los usuarios.
- Conozco las plataformas y el CI esperado.
- Los riesgos principales están nombrados.
- Sé qué artefacto crear después (ADR, EPIC, TASK).

## Anti-patrones

- Discovery que duplica un PRD completo.
- Asumir patrones de sync/offline sin documentar en el proyecto.
- Omitir aprobación humana y pasar directo a implementación.
