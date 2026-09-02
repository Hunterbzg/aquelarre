---
name: aquelarre-discovery
description: Realiza discovery de proyecto nuevo, codebase existente o dominio desconocido. Usa este skill al iniciar un proyecto, integrar Aquelarre en un repo, o antes de EPICs/ADRs cuando falte contexto de negocio y dominio.
---

# Discovery

Fuentes:

- `docs/AI_WORKFLOW_SKILLS_SPEC.md` — artefactos y gates
- `templates/DISCOVERY.md` — plantilla
- `docs/VISION.md` — fase 0 (sección 6.2)

## Objetivo

Capturar contexto de negocio, usuarios, restricciones y estado actual antes de decisiones técnicas o de producto.

## Inputs

- Descripción del proyecto o feature desde el humano.
- Codebase existente (si aplica): estructura, stack, docs.
- Restricciones conocidas (plataformas, fechas, compliance).

## Outputs

- `docs/discovery/DISCOVERY-<id>-<slug>.md` aprobado por el humano.
- Glosario de dominio, superficies (`platform`) y riesgos iniciales.
- Recomendación de próximos pasos (arquitectura, EPICs).

## Gates que aplica

- **Gate 1 (condicional):** proyecto nuevo o dominio nuevo → discovery aprobado antes de `ready` en tasks de feature estructural.

## Instrucciones

1. Confirmar alcance del discovery (proyecto completo vs feature/dominio).
2. Crear artefacto desde `templates/DISCOVERY.md`.
3. Completar como mínimo:
   - problema y oportunidad
   - usuarios y stakeholders
   - restricciones y supuestos
   - glosario del dominio
   - inventario del estado actual (si codebase existente)
   - superficies: mobile, tablet, web, backend
   - riesgos identificados
4. Inferir `platform` y `ci` esperados (Bitrise vs Docker) según superficies.
5. Si hay **APIs externas** (pagos, auth SaaS, etc.), archivar docs con `aquelarre-doc-crawler` en `docs/discovery/external-apis/` y referenciar en discovery.
6. **No** inventar requisitos de producto detallados; eso es `aquelarre-po-product`.
7. Solicitar **aprobación humana** antes de considerar discovery cerrado.
8. Linkear discovery desde EPICs o tasks iniciales cuando existan.

## Cuándo invocar

| Situación | Discovery |
|-----------|-----------|
| Proyecto greenfield | Obligatorio |
| Integrar Aquelarre en repo existente | Recomendado (inventario + gaps) |
| Feature en dominio nuevo | Discovery acotado al dominio |
| Bug/chore acotado | `N/A` con motivo |

## Coordinación

| Siguiente paso | Skill |
|----------------|-------|
| Requerimientos user-visible | `aquelarre-po-product` |
| Decisiones estructurales | `aquelarre-architecture-adr` |
| Docs API externa | `aquelarre-doc-crawler` |
| Desglose de trabajo | `aquelarre-scrum-master` |

## Artefactos

| Artefacto | Ruta |
|-----------|------|
| Discovery | `docs/discovery/DISCOVERY-<id>-<slug>.md` |
| Docs API externa (opcional) | `docs/discovery/external-apis/<nombre>.md` |
| Template | `templates/DISCOVERY.md` |
