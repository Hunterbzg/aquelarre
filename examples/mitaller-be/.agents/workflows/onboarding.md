# Onboarding Workflow

Initializes a new backend project with the AI SDLC Factory structure.

## Steps

### Step 1: Project Identity
Ask the user:
1. What is the project name?
2. Brief description of the project (1-2 sentences)
3. Preferred language for artifacts (Spanish / English)
4. Repository URL (if exists)

### Step 2: Read Existing Context
Check if these files exist and read them:
- `docs/business_context.md`
- `docs/technical_and_workflow_spec.md`

If they exist, extract relevant information for the project context.

### Step 3: Initialize Directory Structure
Create the following directory structure (create placeholder `.gitkeep` files for empty directories):

```
docs/
├── project-context.md        (update with project identity)
├── discovery/
│   └── .gitkeep
├── product/
│   └── .gitkeep
├── architecture/
│   └── .gitkeep
│   └── adr/
│       └── .gitkeep
├── backlog/
│   ├── .gitkeep
│   ├── epics/
│   │   └── .gitkeep
│   └── stories/
│       └── .gitkeep
└── sprints/
    └── .gitkeep
```

### Step 4: Initialize Python Project
Create the base project files:

1. **`pyproject.toml`** — Use the base template from the coding-agent's `code-standards.md` resource. Customize the project name and description.

2. **`.env.example`** — Create with placeholder environment variables:
   ```
   APP_NAME=ProjectName
   DEBUG=true
   API_V1_PREFIX=/api/v1
   SUPABASE_URL=
   SUPABASE_ANON_KEY=
   SUPABASE_SERVICE_ROLE_KEY=
   ```

3. **`.gitignore`** — Create a Python-specific gitignore.

4. **`app/__init__.py`** — Create empty init file.

5. **`tests/__init__.py`** — Create empty init file.

6. **`tests/conftest.py`** — Create with base async test fixtures from the coding-agent's `tdd-workflow.md` resource (async_client fixture using httpx ASGITransport).

### Step 5: Update Project Context
Update `docs/project-context.md` with all the information gathered:
- Project Identity (name, description, language, date)
- Stack Técnico confirmed
- Workflow Status: all gates as "Not Started"
- Current Phase: "Onboarding Complete — Ready for Discovery"

### Step 6: Summary & Next Step
Present to the user:
- Summary of what was created
- The project structure
- Recommend running `/discovery` as the next step
