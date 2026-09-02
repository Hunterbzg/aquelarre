# Discovery Workflow

Conducts an interactive discovery session to understand the business domain, requirements, and constraints.

## Prerequisites
- Project initialized (onboarding completed)
- `docs/project-context.md` exists

## Steps

### Step 1: Load Context
1. Read `docs/project-context.md`
2. Read `docs/business_context.md` (if exists)
3. Read `docs/technical_and_workflow_spec.md` (if exists)
4. Read the discovery checklist from the product-agent skill: `.agents/skills/product-agent/resources/discovery-checklist.md`
5. Determine the artifact language from project-context.md

### Step 2: Conduct Discovery Session
Activate the `product-agent` skill and use the discovery checklist to guide an interactive conversation with the user. Cover all sections:

1. **Business Context** — Problem, impact, current solution, expected value
2. **Users & Stakeholders** — Primary users, roles, permissions
3. **Domain & Entities** — Key concepts, relationships, business rules
4. **Flows & Processes** — Happy paths, alternative flows, error flows
5. **External Integrations** — APIs, authentication, formats, rate limits
6. **Data & Persistence** — Storage needs, volume, retention, privacy
7. **Security** — Auth, authorization, RLS, encryption
8. **Non-Functional Requirements** — Performance, availability, scalability
9. **Constraints** — Technical, budget, timeline, regulatory
10. **Edge Cases** — Document each one discovered

Ask questions one section at a time. Wait for user response before moving to the next section.

### Step 3: Document Findings
Create the following artifacts in the project's artifact language:
- `docs/discovery/discovery-notes-v1.md` — Full session notes with answers to all questions
- `docs/discovery/domain-analysis-v1.md` — Domain model analysis (entities, relationships, bounded contexts)

### Step 4: Quality Gate 0 Review
Read `.agents/skills/product-agent/resources/quality-gates.md` and verify all Gate 0 criteria:
- [ ] No remaining ambiguous business questions
- [ ] Domain fully understood
- [ ] Stakeholders identified
- [ ] External constraints documented
- [ ] Edge cases documented

Present the gate review results to the user.

### Step 5: Request Approval
Ask the user for explicit Gate 0 approval.
If approved:
- Update `docs/project-context.md` → Gate 0: ✅ Passed with date
- Update artifact registry with discovery documents
- Recommend `/prd` as the next step

If not approved:
- Document what's missing
- Continue the discovery session on those areas
- Re-run Gate 0 review
