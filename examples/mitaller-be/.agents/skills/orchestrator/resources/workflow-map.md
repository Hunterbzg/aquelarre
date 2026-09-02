# Workflow Map — AI SDLC Factory

> **Propósito**: Mapa visual de todos los workflows disponibles y su secuencia.

---

## Pipeline Completo

```
┌─────────────────────────────────────────────────────────────────┐
│                    AI SDLC FACTORY PIPELINE                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  /onboarding                                                    │
│  ┌──────────┐                                                   │
│  │ Setup    │ → Inicializar proyecto, estructura, dependencias  │
│  └────┬─────┘                                                   │
│       │                                                         │
│  /discovery                                                     │
│  ┌──────────┐    ┌──────────┐                                   │
│  │ Discover │ →  │ Gate 0   │ → 👤 User Approval               │
│  └────┬─────┘    └────┬─────┘                                   │
│       │               │                                         │
│  /prd │               │                                         │
│  ┌──────────┐    ┌──────────┐                                   │
│  │ PRD      │ →  │ Gate 1a  │ → 👤 User Approval               │
│  └────┬─────┘    └────┬─────┘                                   │
│       │               │                                         │
│  /architecture        │                                         │
│  ┌──────────┐    ┌──────────┐                                   │
│  │ ADR      │ →  │ Gate 1b  │ → 👤 User Approval               │
│  └────┬─────┘    └────┬─────┘                                   │
│       │               │                                         │
│  /sprint-plan         │                                         │
│  ┌──────────┐    ┌──────────┐                                   │
│  │ Stories  │ →  │ Gate 2   │ → Auto-check (DoR)                │
│  │ Tasks    │    │ per Task │                                    │
│  └────┬─────┘    └────┬─────┘                                   │
│       │               │                                         │
│  /implement           │   ┌──────────────────────┐              │
│  ┌──────────┐    ┌────┴───┐                      │              │
│  │ TDD      │ →  │ Gate 3 │ → 👤 User Approval ──┤              │
│  │ Red→Grn  │    │per Task│                      │              │
│  │ →Refactr │    └────┬───┘   Next Task ◄────────┘              │
│  └──────────┘         │                                         │
│                       │                                         │
│  /review              │                                         │
│  ┌──────────┐         │                                         │
│  │ Sprint   │ ←───────┘ (cuando todas las tasks están done)     │
│  │ Review   │                                                   │
│  └──────────┘                                                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Workflows Disponibles

| Comando | Agente | Gate | Descripción |
|:---|:---|:---|:---|
| `/onboarding` | Product Agent | - | Inicializar proyecto: estructura, deps, configuración |
| `/discovery` | Product Agent | Gate 0 | Sesión de discovery interactiva del dominio |
| `/prd` | Product Agent | Gate 1a | Generar PRD a partir de discovery notes |
| `/architecture` | Product Agent | Gate 1b | Crear ADRs, data model, API contracts |
| `/sprint-plan` | Product Agent | Gate 2 | Story mapping → Tasks con DoR |
| `/implement` | Coding Agent | Gate 3 | TDD implementation de siguiente Task |
| `/review` | Both | - | Sprint review y validación de quality |

---

## Reglas de Secuencia

1. `/onboarding` → solo una vez al inicio del proyecto
2. `/discovery` → requiere business context disponible
3. `/prd` → requiere Gate 0 aprobado
4. `/architecture` → requiere Gate 1a aprobado
5. `/sprint-plan` → requiere Gate 1b aprobado
6. `/implement` → requiere Gate 2 (DoR) para el task activo
7. `/review` → ejecutable cuando hay tasks completados para revisar

---

## Atajos Comunes

| Solicitud del Usuario | Workflow Recomendado |
|:---|:---|
| "Empecemos el proyecto" | `/onboarding` → `/discovery` |
| "¿Qué sigue?" | Consultar `orchestrator` skill |
| "Trabajemos en la siguiente tarea" | `/implement` (siguiente Task en sprint) |
| "Revisemos el sprint" | `/review` |
| "Planifiquemos el siguiente sprint" | `/sprint-plan` |
