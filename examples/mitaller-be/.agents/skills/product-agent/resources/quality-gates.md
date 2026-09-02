# Quality Gates — AI SDLC Factory

> **Propósito**: Definición formal de los Quality Gates del pipeline. Ninguna fase puede avanzar sin pasar su gate correspondiente.

---

## Gate 0: Discovery Session ✅

**Propósito**: Entender al 100% los requerimientos, dominio y restricciones.

**Prerequisitos**: Business context disponible.

**Criterios de Salida**:
- [ ] No quedan preguntas ambiguas del negocio
- [ ] Dominio del problema completamente entendido
- [ ] Stakeholders y usuarios identificados
- [ ] Restricciones y dependencias externas documentadas
- [ ] Edge cases y escenarios de error conocidos
- [ ] Discovery notes documentadas en `docs/discovery/`
- [ ] **Aprobación explícita del usuario**

**Artefacto requerido**: `docs/discovery/discovery-notes-vN.md`

---

## Gate 1a: PRD Approved ✅

**Propósito**: PRD completo y aprobado como base para diseño técnico.

**Prerequisitos**: Gate 0 aprobado.

**Criterios de Salida**:
- [ ] PRD completo con todas las secciones del template
- [ ] Features priorizadas con MoSCoW (Must/Should/Could/Won't)
- [ ] Requisitos no-funcionales definidos con targets medibles
- [ ] Personas y flujos de usuario documentados
- [ ] Dependencias externas identificadas
- [ ] Fuera de alcance claramente definido
- [ ] **Aprobación explícita del usuario**

**Artefacto requerido**: `docs/product/prd-vN.md`

---

## Gate 1b: Architecture (ADR) Approved ✅

**Propósito**: Arquitectura técnica diseñada y aprobada.

**Prerequisitos**: Gate 1a aprobado.

**Criterios de Salida**:
- [ ] ADR(s) con decisiones justificadas y alternativas evaluadas
- [ ] Modelo de datos con tablas, relaciones y constraints
- [ ] Contratos de API con schemas de request/response
- [ ] Patrones de arquitectura seleccionados (Clean Arch, layering)
- [ ] Estrategia de seguridad (auth, RLS, JWT)
- [ ] Estrategia de manejo de errores y resiliencia
- [ ] **Aprobación explícita del usuario**

**Artefactos requeridos**:
- `docs/architecture/adr/ADR-NNN.md`
- `docs/architecture/data-model-vN.md`
- `docs/architecture/api-contracts-vN.md`

---

## Gate 2: Task Readiness (Definition of Ready) ✅

**Propósito**: Cada task tiene contexto completo para implementación.

**Prerequisitos**: Gate 1b aprobado + Backlog con stories.

**Criterios de Salida (por cada Task)**:
- [ ] ID y título descriptivo
- [ ] Contexto y objetivo claros
- [ ] Archivos a crear/modificar listados
- [ ] Criterios de aceptación definidos (Acceptance Criteria)
- [ ] Especificación de pruebas TDD completa (test cases exactos)
- [ ] Schemas de entrada/salida con ejemplos concretos
- [ ] Dependencias identificadas y resueltas
- [ ] Sin ambigüedades — implementable sin preguntas adicionales

**Artefacto requerido**: `docs/sprints/sprint-NNN/tasks/TASK-NNN.md`

---

## Gate 3: Task Completion & User Approval ✅

**Propósito**: Task implementado, verificado y aprobado por el usuario.

**Prerequisitos**: Gate 2 aprobado para el task + implementación completada.

**Criterios de Salida**:
- [ ] Ciclo TDD completo (Red → Green → Refactor)
- [ ] Todos los tests pasan al 100%
- [ ] Cobertura de código ≥ 85%
- [ ] Linter clean (`ruff check .`)
- [ ] Formatter applied (`ruff format .`)
- [ ] Type check clean (`mypy`)
- [ ] Task actualizada con registro de implementación
- [ ] Resultados presentados al usuario
- [ ] **Aprobación explícita del usuario**

**Es estrictamente prohibido iniciar la siguiente Task sin la aprobación del usuario en Gate 3.**

---

## Resumen Visual

```
  Gate 0         Gate 1a        Gate 1b        Gate 2         Gate 3
  Discovery  →   PRD      →    ADR       →   Task DoR   →  Task DoD
  ─────────     ─────────     ──────────     ──────────     ──────────
  Notes         PRD           ADR            Task.md        Tests ✅
  Domain        Features      Data Model     TDD Spec       Code ✅
  Questions     NFRs          API Contracts  Schemas        Linter ✅
  Edge Cases    Personas      Security       Dependencies   User ✅
  ─────────     ─────────     ──────────     ──────────     ──────────
  👤 Approve    👤 Approve    👤 Approve    Auto-check     👤 Approve
```

---

## Gate Enforcement Rules

1. Gates are **sequential** — no gate can be passed without passing all previous gates
2. Gates are **mandatory** — no exceptions, no shortcuts
3. Gates require **explicit human approval** (except Gate 2 which is an automated checklist)
4. Failed gates produce **feedback** explaining what needs to be fixed
5. Gates are **recorded** in `docs/project-context.md` with date and status
