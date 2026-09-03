# Aquelarre

Harness portable de agentes de IA para unificar el workflow de desarrollo en todos tus proyectos.

## ¿Qué es?

**Aquelarre** es tu ejército personal de agentes: un solo repositorio que descargas e integras en cualquier proyecto para tener discovery, arquitectura, UX, organización tipo Scrum, gates de calidad, desarrollo con TDD, testing automático y aprobación humana — en **Cursor** y **Antigravity**.

## Stacks soportados (objetivo)

- **Móvil / Tablet:** Flutter + Bitrise (CI/CD desde el inicio)
- **Web:** React + Docker
- **Backend:** Python (FastAPI) o Node.js + Docker
- **Infra / Datos:** Supabase
- **CI/CD:** Bitrise (móvil/tablet) · Docker (web/backend)
- **IDEs con agentes:** Cursor + Antigravity (soporte dual en el paquete)
- **Diseño:** Material Design 3

## Estructura del repo

```
aquelarre/
├── skills/          ← fuente canónica de skills (23 skills listos)
├── docs/            ← visión, spec workflow, inventarios
├── templates/       ← plantillas TASK, ADR, UX, DISCOVERY, …
├── rules/           ← rules Cursor (Gate 0)
├── install/         ← install.ps1 / install.sh (dual IDE)
├── examples/        ← referencias (mitaller-skills, BMAD, …)
└── README.md
```

## Documentación

- **[Skills (fuente canónica)](skills/README.md)** — 23 skills `aquelarre-*` listos para instalar.
- **[Visión y contexto completo](docs/VISION.md)** — Documento maestro del harness.
- **[Spec del workflow](docs/AI_WORKFLOW_SKILLS_SPEC.md)** — Gates, routing, apéndices YAML.
- **[Instalador](install/README.md)** — `.\install\install.ps1 -Dest <ruta-proyecto> -Ide all`
- **[Plantillas](templates/README.md)** — TASK, DISCOVERY, ADR, UX, TEST, …

- **[Inventario mitaller-skills (Flutter)](docs/MITALLER_SKILLS_INVENTORY.md)** — Harness app móvil: qué es genérico vs Mi Taller.
- **[Inventario mitaller-be (Backend)](docs/MITALLER_BE_INVENTORY.md)** — Harness Antigravity FastAPI: comparación con Aquelarre.

Proyecto en fase de diseño (v0.2). **Catálogo de skills completo (20/20)** en `skills/`. Spec y plantillas en `docs/` y `templates/`. Referencias en `examples/`:

- `examples/mitaller-skills/` — Skills v0 del proyecto Mi Taller (Flutter)
- `examples/mitaller-be/` — AI SDLC Factory Antigravity (backend FastAPI, solo `.agents/`)
- `examples/BMAD-METHOD-main/` — Referencia de metodología multi-agente
- `examples/skills-main/` — Referencia de formato de skills Flutter

## Principios clave

1. **No code before task** — Sin TASK, no hay desarrollo.
2. **Artefactos antes de código** — Discovery, requerimientos, arquitectura y UX según aplique.
3. **Gates verificables** — PASS/FAIL explícito en cada transición.
4. **TDD por defecto** — El agente sabe si va bien porque los tests lo dicen.
5. **Humano en el loop** — Solo tú autorizas que algo esté terminado.
