# Ejemplos UX del proyecto

## Ejemplo A: AppBar consistente

Usar este patrón base en pantallas nuevas:

- `backgroundColor: theme.scaffoldBackgroundColor`
- `elevation: 0`
- `title` con peso `w600`, tamano `20`
- color de texto/iconos desde `theme.colorScheme`

## Ejemplo B: Estados de pantalla

Estructura recomendada:

- `loading`: indicador de progreso
- `error`: mensaje + accion de reintento
- `empty`: mensaje de vacio con contexto
- `loaded`: contenido principal

## Evitar

- Estandarizar widgets placeholders o TODOs.
- Introducir estilos hardcodeados cuando el tema ya cubre el caso.
