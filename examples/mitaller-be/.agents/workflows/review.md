# Review Workflow

Conducts a sprint review to validate completed work and plan next steps.

## Prerequisites
- Active sprint with completed tasks

## Steps

### Step 1: Load Sprint Context
1. Read `docs/project-context.md`
2. Read sprint plan from `docs/sprints/sprint-NNN/sprint-plan.md`
3. Read all completed task files from `docs/sprints/sprint-NNN/tasks/`
4. Count completed vs total stories and tasks

### Step 2: Sprint Summary
Generate a sprint review summary:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 SPRINT NNN REVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 Sprint Goal: [Goal]
📅 Duration: [Start] → [End]

📋 STORIES COMPLETED
  ✅ STORY-NNN: [Title] (X pts)
  ✅ STORY-NNN: [Title] (X pts)
  ⬜ STORY-NNN: [Title] (X pts) — Carried over

📊 METRICS
  Stories:  X/Y completed
  Tasks:    X/Y completed
  Points:   X/Y delivered
  Velocity: X pts

🧪 QUALITY
  Total Tests:    N
  Tests Passing:  N (100%)
  Avg Coverage:   XX.X%
  Linter Issues:  0
  Type Errors:    0

📝 TASKS DETAIL
  ✅ TASK-NNN: [Title] — [Brief solution]
  ✅ TASK-NNN: [Title] — [Brief solution]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Step 3: Run Full Test Suite
Execute the complete test suite to verify all implementations work together:
```bash
pytest -v --cov=app --cov-report=term-missing
ruff check .
mypy app/
```

Report results to user.

### Step 4: Identify Carryover
If there are incomplete stories or tasks:
- List them with reasons for incompletion
- Ask user if they should carry over to next sprint or go back to backlog

### Step 5: Update Project Context
Update `docs/project-context.md`:
- Sprint status: Complete
- Velocity recorded
- Gate statuses confirmed
- Artifact registry updated

### Step 6: Update Backlog
Update `docs/backlog/backlog.md`:
- Mark completed stories as ✅ Done
- Move carryover items back to backlog (if any)

### Step 7: Next Steps
Present options to the user:
1. **Start next sprint**: Recommend `/sprint-plan`
2. **More stories in backlog**: Show remaining backlog items
3. **Project complete**: If all epics are done, congratulate and summarize

### Step 8: Sprint Closure
Mark sprint as complete in `docs/sprints/sprint-NNN/sprint-plan.md`.
