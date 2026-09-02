---
name: mitaller-architecture-adr
description: Evalua impacto arquitectonico y documenta decisiones en ADR para cambios estructurales, auth o base de datos. Usa este skill cuando el riesgo sea alto, haya cambios de boundaries o se requiera rollback/mitigacion.
---

# Arquitectura y ADR

Fuentes internas:

- `docs/AI_WORKFLOW_SKILLS_SPEC.md` (reglas G1-ADR)
- `docs/ORDERS_ARCHITECTURE_PATTERNS.md`
- `docs/OFFLINE_FIRST_SYNC_PATTERN.md`
- `docs/INVENTORY_SYSTEM.md`

Referencia ampliada: `reference.md`

## Inputs

- Task + clasificacion tecnica.
- Modulos impactados.
- Riesgos funcionales y no funcionales.

## Outputs

- ADR linkeado (cuando aplique).
- Decision de arquitectura, trade-offs y mitigaciones.
- Plan de rollback en cambios sensibles.

## Instrucciones

1. Exigir ADR cuando:
   - `db_change` sea `schema` o `rls_policy`, o
   - `surface` incluya `auth`.
2. En refactors de alto riesgo, documentar boundaries afectados.
3. Incluir en ADR:
   - contexto y decision
   - alternativas descartadas
   - riesgos y rollback
4. Actualizar links de trazabilidad en el task.

## Criterios arquitectonicos del proyecto

- Mantener capas claras (`presentation -> domain <- data`).
- Repositorios como SSOT y coordinadores de sincronizacion.
- Lectura `offline-first` y escritura `online-first` como politica default.
- Decisiones de sincronizacion basadas en `updated_at` con utilidades compartidas.

## Criterio de exclusion

- No elevar como patron codigo temporal, duplicado o marcado como TODO.
- Si una practica existente contradice robustez/seguridad, registrar mejora en ADR y no replicarla.
