# Project Context — <nombre del proyecto>

> Hub opcional de estado del harness Aquelarre. Complementa (no reemplaza) los TASKs en `docs/workflow/tasks/`.
> Actualizar después de cada gate aprobado o al cerrar un sprint.

---

## 1) Identidad

| Campo | Valor |
|-------|-------|
| Proyecto | |
| Descripción | |
| Idioma artefactos | es \| en |
| Stack | ej. FastAPI + Supabase + Docker |
| Plataformas | mobile \| tablet \| web \| backend |
| Repo | |
| Última actualización | YYYY-MM-DD |

---

## 2) Quality Gates (Aquelarre)

| Gate | Estado | Fecha | Notas |
|------|--------|-------|-------|
| Gate 0 — Task / Discovery | ⬜ \| 🟡 \| ✅ | | |
| Gate 1 — Ready for Dev | ⬜ \| 🟡 \| ✅ | | |
| Gate 2 — Ready for PR | — | | Por task |
| Gate 3 — Done | — | | Por task |

**Discovery aprobado:** `docs/discovery/DISCOVERY-<id>-<slug>.md` o N/A

---

## 3) Artefactos clave (links)

| Artefacto | Ruta | Versión activa |
|-----------|------|----------------|
| PRD | `docs/product/briefs/PRD-<id>.md` | |
| ADR principal | `docs/adr/` | |
| Data model | `docs/architecture/` o `docs/db/` | |
| API contracts | `docs/architecture/api-contracts/` | |
| EPIC activo | `docs/workflow/epics/` | |
| Sprint / iteración | `docs/workflow/sprints/` | |

---

## 4) Sprint / iteración actual

| Campo | Valor |
|-------|-------|
| Sprint | SPRINT-<id> o N/A |
| Objetivo | |
| Task activo | TASK-<id> o ninguno |
| Tasks completados | 0 / N |

---

## 5) Próximo paso recomendado

- [ ] Acción sugerida (ej. completar Gate 1 en TASK-042, ejecutar discovery, abrir PR)
- Skill Aquelarre: `aquelarre-<nombre>`

---

## 6) Notas de sesión (breve)

### YYYY-MM-DD
- ...

**Destino sugerido:** `docs/project-context.md` (raíz de `docs/`)
