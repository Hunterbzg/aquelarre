# Architecture Workflow

Creates Architecture Decision Records, data model, and API contracts.

## Prerequisites
- Gate 1a (PRD) passed ✅
- PRD available in `docs/product/`

## Steps

### Step 1: Verify Prerequisites
1. Read `docs/project-context.md` and verify Gate 1a is passed
2. If Gate 1a is NOT passed → STOP and recommend running `/prd` first
3. Read PRD from `docs/product/prd-vN.md` (latest version)
4. Read discovery notes from `docs/discovery/`
5. Read domain model from `docs/product/domain-model-vN.md` (if exists)

### Step 2: Create ADR(s)
Activate the `product-agent` skill and use the ADR template from `.agents/skills/product-agent/resources/adr-template.md`.

Create ADRs for key architectural decisions:
- **ADR-001**: Overall architecture pattern (Clean Architecture, layering strategy)
- **ADR-002**: Database and persistence strategy (Supabase, RLS, migrations)
- **ADR-003**: Authentication and authorization strategy
- **ADR-004**: External API integration patterns
- **ADR-005+**: Additional domain-specific decisions as needed

Each ADR must include:
- Context and problem
- Decision with clear statement
- Alternatives considered with pros/cons
- Consequences (positive, negative, risks)

### Step 3: Design Data Model
Create `docs/architecture/data-model-v1.md` with:
- Table definitions (columns, types, constraints)
- Relationships (foreign keys, junction tables)
- Indexes
- RLS policies
- Mermaid ER diagram
- Migration strategy

### Step 4: Define API Contracts
Create `docs/architecture/api-contracts-v1.md` with:
- Endpoint list with HTTP methods, paths, descriptions
- Request/response schemas (JSON examples)
- Authentication requirements per endpoint
- Error response format
- Versioning strategy
- Pagination pattern

### Step 5: Present for Review
Present all architecture artifacts to the user. Highlight:
- Key decisions and their rationale
- Trade-offs accepted
- Data model structure
- API contract summary
- Any areas needing user input

### Step 6: Quality Gate 1b Review
Read `.agents/skills/product-agent/resources/quality-gates.md` and verify all Gate 1b criteria:
- [ ] ADR(s) complete with justified decisions and evaluated alternatives
- [ ] Data model with all tables and relationships
- [ ] API contracts with request/response schemas
- [ ] Architecture patterns selected and justified
- [ ] Security strategy defined (auth, RLS)
- [ ] Error handling and resilience strategy

### Step 7: Request Approval
Ask for explicit Gate 1b approval.
If approved:
- Update `docs/project-context.md` → Gate 1b: ✅ Passed with date
- Update artifact registry
- Recommend `/sprint-plan` as the next step

If feedback received:
- Update artifacts based on feedback → create new versions
- Re-run Gate 1b review
