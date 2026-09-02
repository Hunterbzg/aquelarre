# Ejemplos — UX spec mobile

## Ejemplo A: Pantalla con lista y estados

```markdown
## Estados
- loading: CircularProgressIndicator centrado
- empty: icono + "No hay elementos" + CTA "Crear primero"
- error: mensaje + boton "Reintentar"
- loaded: ListView con items

## Interacciones
- tap item → detalle
- pull-to-refresh → recargar
```

## Ejemplo B: Formulario

```markdown
## Campos
- Nombre (requerido, min 2 chars)
- Email (formato valido)

## Validacion
- Inline bajo cada campo
- Submit deshabilitado hasta form valido

## Estados submit
- idle / loading / error servidor / success → navegar atras
```

## Ejemplo C: N/A justificado

En el task:

```markdown
### UX spec
N/A — chore `type=chore`, `user_visible=no`, cambio solo en capa de datos sin cambio visual.
```

## Evitar en la spec

- Valores de color hex sin referencia a token del tema
- Referencias a widgets concretos del harness (solo del proyecto si son estables)
- Duplicar el log de implementacion (eso va en el TASK seccion 7)
