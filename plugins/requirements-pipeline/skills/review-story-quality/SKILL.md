---
name: review-story-quality
description: This skill should be used when the user wants to assess or score the quality of user stories against a specification. It is stage four of the requirements pipeline, analyzing the generated stories and the spec together to grade INVEST compliance, acceptance-criteria quality, and two-way traceability coverage, then producing a scored review with concrete rewrite suggestions.
version: 0.1.0
---

# Review Story Quality

Grade a set of user stories against a defined rubric and against the specification they came from. Produce a report the architect can act on, not a pass/fail black box.

## When to use this skill

After stories exist (typically from `generate-safe-stories`) and the user wants to know whether they are good. Requires two inputs: the stories file and the specification.

## What to evaluate

Use the rubric at `${CLAUDE_PLUGIN_ROOT}/skills/review-story-quality/references/invest-rubric.md`. Three layers:

1. **INVEST per story.** Score each of Independent, Negotiable, Valuable, Estimable, Small, Testable. Flag the weakest dimension with a specific reason, not just a number.
2. **Acceptance-criteria quality.** Are criteria present, testable, unambiguous, and complete? A story whose criteria cannot become a test fails Testable regardless of how well it reads.
3. **Traceability and coverage — both directions.**
   - Forward: every story maps to a REQ ID that exists in the spec (no orphan stories).
   - Backward: every REQ ID in the spec maps to at least one story (no coverage gaps).
   - Also flag duplicate or overlapping stories, and any non-functional requirement (NFR) with no story behind it.

## How to produce the review

1. Read the specification and the stories file in full.
2. Build the two-way traceability matrix first. Coverage gaps are often the most consequential finding and are easy to compute from the REQ IDs.
3. Score each story on INVEST and acceptance-criteria quality. Be specific about why a dimension is weak.
4. For every story that scores poorly, give a concrete rewrite suggestion, not just a flag.
5. Apply a Definition of Ready check per story.
6. Use the template at `${CLAUDE_PLUGIN_ROOT}/skills/review-story-quality/templates/quality-report-template.md`.

## Judgment, not automation

Present findings as input to the architect's decision. Where a story is borderline, say so and explain the tradeoff rather than forcing a verdict. The goal is to sharpen the human's review, not replace it.

## Output

Write the review into the **same source-named folder as the specification and stories** (derive it from their location; do not create a new folder), named `<source name> - Quality Review.md`. If that location is not known, resolve the output root the same way `draft-specification` does (explicit request, then `REQUIREMENTS_PIPELINE_OUTPUT_ROOT`, then fallback) and confirm before writing. Cross-link to the spec and stories with Obsidian-style `[[wikilinks]]` in the frontmatter. Then summarize: overall coverage percentage, count of stories below threshold, the top issues, and the highest-priority rewrites.
