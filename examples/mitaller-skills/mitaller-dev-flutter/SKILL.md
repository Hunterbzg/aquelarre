---
name: mitaller-dev-flutter
description: Implementa cambios Flutter siguiendo el workflow y convenciones del repo. Usa este skill para ejecutar tasks en estado ready con TDD por defecto, registrar implementacion en el TASK y mantener trazabilidad tecnica.
---

# Desarrollo Flutter (ejecucion)

Fuentes internas:

- `docs/AI_WORKFLOW_SKILLS_SPEC.md` (Dev + Gate 2)
- `docs/VALIDACIONES_Y_TESTS.md`
- `docs/UI_UX_SUPABASE_CODING_PRACTICES.md`
- `docs/ORDERS_ARCHITECTURE_PATTERNS.md`

Referencia ampliada: `reference.md`

## Inputs

- Task en `ready` con gate 1 aprobado.
- Branch de trabajo activa o por crear.
- Specs relacionadas (PO/UX/ADR/DB/SUPA/TEST).

## Outputs

- Codigo implementado acorde al scope.
- Registro en task (secciones de implementacion y decisiones).
- Evidencia de pruebas para Gate 2.

## Reglas operativas

1. Respetar no code before task.
2. Usar TDD por defecto (`tdd=on`), salvo override justificado.
3. Mantener cambios enfocados al alcance del task.
4. Actualizar trazabilidad en task: branch, commits, PR y artefactos.

## Patrones tecnicos obligatorios (proyecto)

- Lecturas: `offline-first` (consultar local primero y sincronizar segun timestamps).
- Escrituras: `online-first` (persistir en remoto y luego cachear/actualizar local).
- Sincronizacion: comparar `updated_at/updatedAt` local vs remoto para decidir fuente.
- Comparaciones de fecha: usar utilidades de `SyncDateTimeMixin` para normalizacion UTC.
- Estado UI: explicitar `loading/error/empty/loaded`, evitando transiciones silenciosas.

## Guardrails de calidad

- No promover TODOs como estandar.
- Evitar duplicar logica de sincronizacion; reutilizar mixins/utilidades.
- Evitar colores hardcodeados en nuevas pantallas cuando el tema ya lo cubre.

## Checklist de implementacion

- [ ] Leer contexto completo del task y artefactos linkeados.
- [ ] Aplicar patrones del repo (arquitectura, estado, validaciones).
- [ ] Implementar incrementos pequenos y verificables.
- [ ] Ejecutar pruebas/lints/formato requeridos.
- [ ] Documentar evidencia en task antes de PR.
- [ ] Confirmar estrategia de datos: lectura offline-first y escritura online-first.
- [ ] Confirmar uso de `updated_at` para decisiones de sincronizacion.
