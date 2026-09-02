# Ejemplos arquitectura/ADR

## Caso: cambio en politica de sincronizacion

ADR debe incluir:

- Problema de consistencia observado.
- Decision sobre `updated_at` y criterio `shouldUseLocal`.
- Impacto en repositorios, datasources y pruebas.
- Rollback en caso de regresion de datos.

## Caso: cambio auth o RLS

ADR debe incluir:

- Roles y permisos afectados.
- Riesgos de seguridad.
- Evidencia esperada de pruebas positivas/negativas.
