# Ejemplos — Desarrollo Flutter

## Ejemplo A: Ciclo TDD (unit)

1. Escribir test que falla para la regla de negocio nueva.
2. Implementar minimo en domain/data para pasar el test.
3. Refactorizar sin cambiar comportamiento.
4. Registrar comando y PASS en task seccion 9.

## Ejemplo B: Widget test de estados UI

```dart
// Verificar que Cubit en Error muestra mensaje y boton Reintentar
testWidgets('muestra error con retry', (tester) async {
  // arrange: mock state Error
  // act: pump widget
  // assert: find.text('Reintentar')
});
```

## Ejemplo C: Registro en TASK (seccion 7)

```markdown
### 2026-09-01
- Agregado `OrderStatusCubit` con estados loading/loaded/error.
- Tests: `order_status_cubit_test.dart` (3 casos).
- Decision: reutilizar `AppErrorView` existente para error state.
```

## Ejemplo D: Evidencia Gate 2 (seccion 9)

```markdown
- `flutter test` → PASS (42 tests)
- `dart analyze` → PASS
- Bitrise build #1234 → PASS (link)
```

## Ejemplo E: Override TDD

Solo con justificacion en task:

```yaml
tdd: off
# Justificacion: hotfix produccion, test de regresion en TASK-099 follow-up.
```
