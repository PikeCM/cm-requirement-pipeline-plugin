---
name: generate-safe-stories
description: This skill should be used when the user wants to generate user stories from a specification document using SAFe (Scaled Agile Framework) structure. It is stage three of the requirements pipeline, taking a reviewed specification and producing features, user stories, and enabler stories with traceability back to requirement IDs.
version: 0.1.0
---

# Generate SAFe Stories

Turn a reviewed specification into a SAFe-structured backlog: features, user stories, and enabler stories, each traceable to the requirements they satisfy.

## When to use this skill

After a specification exists and the user has reviewed it. This is stage three. The output feeds `review-story-quality`.

## Prerequisite

Confirm the specification has been reviewed. Generating stories from an unconfirmed spec hardens guesses. If open questions in the spec block specific requirements, generate the affected stories but mark them blocked and reference the open question.

## SAFe structure to follow

Read the reference at `${CLAUDE_PLUGIN_ROOT}/skills/generate-safe-stories/references/safe-story-guide.md` for the hierarchy, formats, and enabler guidance. In short:

- **Feature**: a service that delivers stakeholder value, with a benefit hypothesis and acceptance criteria. Group stories under features.
- **User story**: "As a [persona], I want [goal], so that [benefit]," with acceptance criteria in Given / When / Then form and a story-point placeholder.
- **Enabler story**: technical work with no direct user-facing value (architecture, data migration, security model, integration scaffolding). On Salesforce engagements these are often half the backlog. Generate them as first-class items; do not skip them.

## Rules

1. **Traceability is mandatory.** Every story and feature carries the REQ ID(s) it satisfies. Use the IDs exactly as written in the spec.
2. **Personas come from the spec**, section 2, verbatim. Do not invent new personas.
3. **One concern per story.** Split stories that bundle multiple behaviors so they stay small and testable.
4. **Acceptance criteria must be testable.** Concrete, observable Given / When / Then. Avoid "works correctly" style criteria.
5. **Cover NFRs.** Each non-functional requirement needs a story or an explicit acceptance criterion on a related story. Do not let NFRs fall through.
6. **Salesforce default.** Where the spec implies a Salesforce solution, prefer declarative (Flow, validation rules, reports) and note where code is genuinely required. Reflect that in enabler stories.

## How to produce it

1. Read the full specification, especially the requirements tables and open questions.
2. Map requirements to features, then features to stories. Keep a running coverage check so no REQ ID is left without a story.
3. Use the template at `${CLAUDE_PLUGIN_ROOT}/skills/generate-safe-stories/templates/story-template.md` for each story.
4. Write the backlog into the **same source-named folder as the specification** (derive it from the spec file's own location; do not create a new folder), named `<source name> - User Stories.md`, grouped by feature. If the spec location is not known, resolve the output root the same way `draft-specification` does (explicit request, then `REQUIREMENTS_PIPELINE_OUTPUT_ROOT`, then fallback) and confirm before writing. Cross-link to the spec with an Obsidian-style `[[wikilink]]` in the frontmatter.

## Output and hand-off

Summarize: feature count, user-story count, enabler-story count, and any REQ IDs not yet covered (with the reason). Then offer to continue with `review-story-quality`, passing both the spec and the stories file.
