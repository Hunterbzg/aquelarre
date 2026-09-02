# Ejemplos dev-flutter del proyecto

## Ejemplo A: Lectura offline-first

1. Leer `lastUpdated` local.
2. Leer `lastUpdated` remoto.
3. Decidir con `shouldUseLocal(local, remote)`.
4. Si remoto es mas nuevo, sincronizar y cachear local.

## Ejemplo B: Escritura online-first

1. Crear/actualizar primero en Supabase.
2. Si remoto fue exitoso, persistir en SQLite local.
3. Retornar entidad final consistente con remoto.

## Ejemplo C: Sincronizacion por updated_at

- Comparar timestamps normalizados UTC.
- Evitar comparar fechas sin normalizacion.
- Mantener regla de epoch local vacio (forzar remoto).
