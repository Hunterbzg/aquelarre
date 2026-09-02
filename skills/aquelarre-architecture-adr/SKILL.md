---
name: aquelarre-architecture-adr
description: Evalua impacto arquitectonico y documenta decisiones en ADR para el workflow Aquelarre. Usa este skill cuando el riesgo sea alto, haya cambios de boundaries, auth, schema o se requiera rollback y mitigacion.
---

# Arquitectura y ADR

Fuentes:

- `docs/AI_WORKFLOW_SKILLS_SPEC.md` (reglas G1-ADR)
- `reference.md` — criterios genericos y guia ADR
- `examples.md` — casos tipo (auth, sync, boundaries)
- Documentacion de arquitectura del **proyecto consumidor** (si existe en `docs/architecture/`)

## Objetivo

Documentar decisiones irreversibles o de alto impacto antes de implementar, con trade-offs y plan de rollback.

## Inputs

- Task + clasificacion tecnica (`type`, `surface`, `risk`, `db_change`, `platform`).
- Modulos o capas impactados.
- Riesgos funcionales y no funcionales.

## Outputs

- ADR en `docs/adr/####-<decision>.md` (formato Nygard).
- Notas de arquitectura en el task cuando el ADR no sea necesario.
- Plan de rollback en cambios sensibles.

## Gates que aplica

- **Gate 1 (G1-ADR-001):** ADR si `db_change in {schema, rls_policy}` o `surface` incluye `auth`.
- **Gate 1 (G1-ADR-002, warning):** si `type=refactor` y `risk=high` → boundaries y trade-offs documentados.

## Instrucciones

1. Evaluar si el cambio requiere ADR (ver reglas arriba y matriz del SPEC).
2. Si aplica ADR, incluir como minimo:
   - **Context** — problema y fuerzas en juego
   - **Decision** — que se hara
   - **Consequences** — beneficios, costos, deuda
   - **Alternatives considered** — opciones descartadas
   - **Related** — links a TASK, PRD, UX, SUPA, DB
3. En refactors de alto riesgo, documentar boundaries afectados y comportamiento que no debe cambiar.
4. Para cambios de datos distribuidos o cache (si el proyecto los usa), documentar consistencia y rollback — ver `examples.md`.
5. Linkear ADR desde el task; actualizar status del ADR (`Proposed` → `Accepted`).
6. **No** imponer patrones del proyecto consumidor desde el harness; leer `docs/architecture/` del repo si existe.

## Criterios genericos (cuando no hay doc de proyecto)

- Preferir separacion de capas clara (UI / dominio / datos).
- Un solo lugar de verdad por agregado o modulo.
- Decisiones de persistencia y sync son **decision de proyecto**, no defaults del harness.
- No elevar codigo temporal, TODO o duplicado como patron.

## Artefactos

| Artefacto | Ruta |
|-----------|------|
| ADR | `docs/adr/####-<decision>.md` |
| Overview (opcional) | `docs/architecture/OVERVIEW.md` |
| Template | Apéndice D del `AI_WORKFLOW_SKILLS_SPEC.md` |
