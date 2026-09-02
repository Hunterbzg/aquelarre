# Implement Workflow

Executes TDD implementation of the next ready Task in the active sprint.

## Prerequisites
- Active sprint exists
- At least one Task with Gate 2 (DoR) approved

## Steps

### Step 1: Identify Next Task
1. Read `docs/project-context.md` to get active sprint
2. Read sprint plan from `docs/sprints/sprint-NNN/sprint-plan.md`
3. Find the first task with status ⬜ Ready (not yet started)
4. If no tasks ready → inform user and recommend `/sprint-plan` for next sprint
5. Read the task file: `docs/sprints/sprint-NNN/tasks/TASK-NNN.md`

### Step 2: Validate DoR (Gate 2)
Activate the `coding-agent` skill. Verify the Task meets all DoR criteria:
- [ ] ID and descriptive title
- [ ] Clear context and objective
- [ ] Files to create/modify listed
- [ ] Acceptance criteria defined
- [ ] TDD test specification complete
- [ ] Input/output schemas with examples
- [ ] Dependencies resolved

If DoR is NOT complete → STOP and request Product Agent to complete the task spec.

### Step 3: Update Task Status
Update the task file status to 🔴 Red (Tests).
Update sprint plan to show task in progress.

### Step 4: Phase RED 🔴 — Write Tests First
Following `.agents/skills/coding-agent/resources/tdd-workflow.md`:

1. Read the TDD test specification from the task
2. Create test file(s) in `tests/` following the mirror structure
3. Write ALL test cases specified in the task
4. Run tests: `pytest tests/[path] -v`
5. **Confirm tests FAIL** — if they pass, tests are incorrect
6. Report RED phase results to user

### Step 5: Phase GREEN 🟢 — Minimum Implementation
1. Implement the minimum code to make all tests pass
2. Follow patterns from:
   - `.agents/skills/coding-agent/resources/fastapi-patterns.md`
   - `.agents/skills/coding-agent/resources/supabase-patterns.md` (if DB involved)
3. Run tests: `pytest tests/[path] -v`
4. **Confirm ALL tests PASS**
5. Report GREEN phase results to user

### Step 6: Phase REFACTOR ♻️ — Clean & Optimize
1. Review and improve code quality
2. Apply code standards from `.agents/skills/coding-agent/resources/code-standards.md`
3. Run: `ruff format .`
4. Run: `ruff check . --fix`
5. Run: `mypy app/[module]`
6. Run tests one final time: `pytest tests/[path] -v`
7. Run coverage: `pytest --cov=app/[module] tests/[path]`
8. **Confirm ALL tests still PASS**

### Step 7: Verify DoD (Pre-Gate 3)
Read `.agents/skills/coding-agent/resources/dod-checklist.md` and verify:
- [ ] TDD complete (Red → Green → Refactor)
- [ ] All tests pass (100% green)
- [ ] Coverage ≥ 85%
- [ ] Linter clean
- [ ] Formatter applied
- [ ] Type check clean
- [ ] Acceptance criteria met

### Step 8: Update Task File
Update the task file with:
- Status: ✅ Done (pending Gate 3)
- Implementation record:
  - Solution description
  - Verification commands executed
  - Test results, coverage, linter, type check results
- Mark acceptance criteria as completed

### Step 9: Present for Gate 3
Present complete results to user using the DoD format from `.agents/skills/coding-agent/resources/dod-checklist.md`.

Ask for explicit Gate 3 approval.

If approved:
- Mark task as ✅ Done in sprint plan
- Update `docs/project-context.md` with progress
- Check if there are more tasks → recommend `/implement` for next task
- If all tasks done → recommend `/review` for sprint review

If rejected:
- Document feedback
- Return to appropriate TDD phase
- Re-verify DoD
