# Workflow — Discovery

Sesión interactiva de discovery de dominio y contexto.

**Comando Antigravity:** `/discovery`  
**Skill:** `aquelarre-discovery`  
**Gate:** 0 (condicional — proyecto nuevo o dominio nuevo)

## Prerrequisitos

- Onboarding completado (o repo brownfield inventariado)
- `docs/project-context.md` leído si existe

## Pasos

### 1) Alcance

Confirmar con el humano: proyecto completo vs dominio/feature acotado.

### 2) Activar skill

Seguir `skills/aquelarre-discovery/SKILL.md`:

1. Crear `docs/discovery/DISCOVERY-<id>-<slug>.md` desde `templates/DISCOVERY.md`
2. Cubrir: problema, usuarios, glosario, restricciones, superficies (`platform`), riesgos
3. Si hay APIs externas → `aquelarre-doc-crawler` → `docs/discovery/external-apis/`

### 3) Sesión interactiva

Una sección a la vez; esperar respuesta del humano antes de continuar.

### 4) Gate 0

- Presentar resumen y criterios de cierre
- Solicitar **aprobación explícita**
- Actualizar `docs/project-context.md` → Gate 0 ✅

### 5) Siguiente paso

| Contexto | Recomendar |
|----------|------------|
| Requisitos user-visible | `/prd` · `aquelarre-po-product` |
| Solo infra/chore | `aquelarre-scrum-master` (task directo) |
| Decisiones estructurales | `/architecture` · `aquelarre-architecture-adr` |

## Rutas

Ver `docs/ARTIFACT_PATHS.md` — **no** usar `discovery-notes-v1.md` ni tasks bajo `docs/sprints/`.
