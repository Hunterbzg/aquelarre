# Project Status Template — AI SDLC Factory

> **Propósito**: Template para el dashboard de estado del proyecto generado por el Orchestrator.

---

## Dashboard Format

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 PROJECT STATUS — [Project Name]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🚪 QUALITY GATES
  Gate 0 (Discovery):    [⬜ Not Started | 🟡 In Progress | ✅ Passed]
  Gate 1a (PRD):         [⬜ | 🟡 | ✅]
  Gate 1b (Architecture):[⬜ | 🟡 | ✅]

📋 CURRENT SPRINT
  Sprint:     [Sprint NNN | N/A]
  Goal:       [Sprint goal]
  Stories:    [X/Y completed]
  Tasks:      [X/Y completed]
  Active:     [TASK-NNN: Title | None]

📁 ARTIFACTS
  Discovery:    [N documents in docs/discovery/]
  Product:      [N documents in docs/product/]
  Architecture: [N documents in docs/architecture/]
  Backlog:      [N epics, N stories in docs/backlog/]
  Sprints:      [N sprints in docs/sprints/]

▶️ NEXT STEP
  Recommended: [/workflow-command]
  Reason:      [Why this is the next step]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Status Detection Logic

### Gate Status Detection

| Gate | Status | Condition |
|:---|:---|:---|
| Gate 0 | ⬜ Not Started | No files in `docs/discovery/` |
| Gate 0 | 🟡 In Progress | Files exist but `project-context.md` shows Gate 0 not passed |
| Gate 0 | ✅ Passed | `project-context.md` shows Gate 0 passed with date |
| Gate 1a | ⬜ Not Started | No files in `docs/product/` |
| Gate 1a | 🟡 In Progress | PRD file exists but not approved |
| Gate 1a | ✅ Passed | `project-context.md` shows Gate 1a passed |
| Gate 1b | ⬜ Not Started | No files in `docs/architecture/` |
| Gate 1b | 🟡 In Progress | ADR files exist but not approved |
| Gate 1b | ✅ Passed | `project-context.md` shows Gate 1b passed |

### Sprint Status Detection

| Condition | Sprint Status |
|:---|:---|
| No `docs/sprints/` directory | No sprint active |
| Sprint plan exists, tasks pending | Sprint in progress |
| All tasks in sprint marked ✅ | Sprint complete, ready for review |
