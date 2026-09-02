# Workflow — PRD / brief de producto

Genera o actualiza requerimientos de producto a partir del discovery.

**Comando Antigravity:** `/prd`  
**Skill:** `aquelarre-po-product`  
**Gate:** 1 (artefactos de producto)

## Prerrequisitos

- Discovery aprobado (`docs/discovery/DISCOVERY-*.md`) o N/A justificado
- Gate 0 PASS en `docs/project-context.md` si aplica

## Pasos

### 1) Validar Gate 0

Si discovery obligatorio y falta → **detener**; recomendar `/discovery`.

### 2) Activar skill

Seguir `aquelarre-po-product`:

1. Leer discovery linkeado
2. Crear/actualizar `docs/product/briefs/PRD-<id>-<slug>.md` desde `templates/PRD.md`
3. Definir AC de producto, alcance, fuera de alcance

### 3) Linkear

Referenciar PRD desde EPICs o tasks que lo consuman.

### 4) Aprobación humana

Solicitar revisión antes de considerar PRD cerrado.

### 5) Siguiente paso

`/architecture` si hay decisiones estructurales · `/sprint-plan` si el alcance ya está acotado a un sprint.
