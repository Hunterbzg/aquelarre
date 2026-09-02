# PRD Workflow

Generates a Product Requirements Document from discovery notes and business context.

## Prerequisites
- Gate 0 (Discovery) passed ✅
- Discovery notes available in `docs/discovery/`

## Steps

### Step 1: Verify Prerequisites
1. Read `docs/project-context.md` and verify Gate 0 is passed
2. If Gate 0 is NOT passed → STOP and recommend running `/discovery` first
3. Read all discovery artifacts from `docs/discovery/`
4. Read `docs/business_context.md` (if exists)

### Step 2: Generate PRD
Activate the `product-agent` skill and use the PRD template from `.agents/skills/product-agent/resources/prd-template.md`.

Generate the PRD with all sections:
1. Executive Summary
2. Problem definition
3. Vision and measurable objectives
4. Users and personas
5. Features prioritized with MoSCoW (Must/Should/Could/Won't)
6. Non-functional requirements with targets
7. External dependencies
8. Constraints and assumptions
9. Out of scope

### Step 3: Generate Domain Model (if needed)
If the domain is complex, also create `docs/product/domain-model-v1.md` with:
- Entity list with attributes
- Relationships diagram (mermaid)
- State machines for key entities
- Ubiquitous language glossary

### Step 4: Present for Review
Present the generated PRD to the user. Highlight:
- Feature priorities (MoSCoW)
- Non-functional requirements
- Any assumptions or trade-offs made
- Open questions (if any)

### Step 5: Quality Gate 1a Review
Read `.agents/skills/product-agent/resources/quality-gates.md` and verify all Gate 1a criteria:
- [ ] PRD complete with all template sections
- [ ] Features prioritized with MoSCoW
- [ ] Non-functional requirements defined with measurable targets
- [ ] Personas and user flows documented
- [ ] External dependencies identified
- [ ] Out of scope clearly defined

### Step 6: Request Approval
Ask for explicit Gate 1a approval.
If approved:
- Update `docs/project-context.md` → Gate 1a: ✅ Passed with date
- Update artifact registry
- Recommend `/architecture` as the next step

If feedback received:
- Update PRD based on feedback → create new version `prd-v2.md`
- Re-run Gate 1a review
