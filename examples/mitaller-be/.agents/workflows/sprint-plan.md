# Sprint Plan Workflow

Breaks down PRD and architecture into Epics, Stories, and Tasks for a new sprint.

## Prerequisites
- Gate 1b (Architecture) passed ✅
- PRD and architecture artifacts available

## Steps

### Step 1: Verify Prerequisites
1. Read `docs/project-context.md` and verify Gate 1b is passed
2. If Gate 1b is NOT passed → STOP and recommend running `/architecture` first
3. Read PRD from `docs/product/prd-vN.md`
4. Read ADRs from `docs/architecture/adr/`
5. Read data model from `docs/architecture/data-model-vN.md`
6. Read API contracts from `docs/architecture/api-contracts-vN.md`
7. Read existing backlog from `docs/backlog/backlog.md` (if exists)

### Step 2: Create/Update Epics
Activate the `product-agent` skill. Use the epic template from `.agents/skills/product-agent/resources/epic-template.md`.

If no epics exist yet:
- Break down PRD features into Epics
- Each Epic = a coherent block of functionality
- Create individual epic files: `docs/backlog/epics/EPIC-NNN.md`

If epics already exist:
- Review and update as needed

### Step 3: Create/Update Stories
Use the story template from `.agents/skills/product-agent/resources/story-template.md`.

For each Epic selected for this sprint cycle:
- Break down into User Stories
- Each Story = a deliverable unit from user perspective
- Define acceptance criteria (Given/When/Then)
- Identify edge cases and error scenarios
- Estimate complexity (story points: 1, 2, 3, 5, 8, 13)
- Create individual story files: `docs/backlog/stories/STORY-NNN.md`

### Step 4: Update Backlog Index
Create or update `docs/backlog/backlog.md`:
- List all Epics with status
- List all Stories with priority, points, and status
- Total estimated points

### Step 5: Select Stories for Sprint
Present the prioritized backlog to the user and ask:
- Which stories should be included in this sprint?
- What is the sprint goal?
- Sprint duration (default: 2 weeks)

### Step 6: Decompose into Tasks
Use the task template from `.agents/skills/product-agent/resources/task-template.md`.

For each Story selected for the sprint:
- Break down into atomic Tasks
- Each Task = implementable unit for the Coding Agent
- Fill ALL DoR fields:
  - Context and objective
  - Files to create/modify
  - Acceptance criteria
  - TDD test specification (exact test cases)
  - Input/output schemas with examples
  - Dependencies
- Create task files: `docs/sprints/sprint-NNN/tasks/TASK-NNN.md`

### Step 7: Verify Gate 2 (DoR per Task)
For each task, verify all DoR criteria from `.agents/skills/product-agent/resources/quality-gates.md`:
- [ ] ID and descriptive title
- [ ] Clear context and objective
- [ ] Files to create/modify listed
- [ ] Acceptance criteria defined
- [ ] TDD test specification complete
- [ ] Input/output schemas with examples
- [ ] Dependencies identified and resolved
- [ ] No ambiguities

### Step 8: User Review of Task Specs
Present each task's key fields to the user for quick review:
- Acceptance criteria
- TDD test specification
- Input/output schemas

The user may:
- **Approve all** → proceed to sprint plan creation
- **Request changes** → update the specific task(s), re-verify Gate 2 for those tasks
- **Merge/split tasks** → adjust task granularity as needed

### Step 9: Create Sprint Plan
Create `docs/sprints/sprint-NNN/sprint-plan.md` using the template from `.agents/skills/product-agent/resources/sprint-plan-template.md`.

Fill in:
- Sprint number, dates, and goal
- All stories with their tasks and point estimates
- Sprint metrics (total stories, tasks, points)
- Task progress tracking table

### Step 10: Present & Approve
Present sprint plan to user for approval.
If approved:
- Update `docs/project-context.md`:
  - Current Phase: Implementation
  - Active Sprint info
  - Gate 2 status
- Recommend `/implement` to start working on TASK-001
