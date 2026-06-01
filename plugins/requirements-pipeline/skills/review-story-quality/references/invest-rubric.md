# Story Quality Rubric

Score each story on the dimensions below. Use a simple 1-3 scale per dimension: 1 = fails, 2 = partial, 3 = meets. Always pair the score with a specific reason.

## INVEST

| Dimension | Meets (3) | Fails (1) |
|-----------|-----------|-----------|
| Independent | Can be built without waiting on unrelated stories | Tightly coupled; cannot start until several others finish |
| Negotiable | Describes intent, leaves room for the how | Over-specifies implementation, no room for conversation |
| Valuable | Clear value to a named persona or the business | Pure technical task with no stated value (unless a properly framed enabler) |
| Estimable | Team has enough to size it | Too vague or too large to estimate |
| Small | Fits in one iteration | Spans iterations; should be split |
| Testable | Acceptance criteria can become tests | "Works correctly" style, not verifiable |

## Acceptance criteria quality

- **Present**: the story has acceptance criteria at all.
- **Testable**: each criterion is observable and verifiable.
- **Unambiguous**: no vague terms ("fast", "user-friendly") without a measure.
- **Complete**: covers the main path plus the obvious edge and error cases.
- **Format**: Given / When / Then, one concern per criterion.

## Traceability and coverage

- **Forward traceability**: story references a REQ ID that exists in the spec. A story with no REQ ID, or a REQ ID not in the spec, is an orphan — flag it.
- **Backward coverage**: each REQ ID in the spec is covered by at least one story. Uncovered REQ IDs are gaps — list them.
- **NFR coverage**: each non-functional requirement is addressed by a story or an explicit acceptance criterion.
- **Duplication**: stories that overlap in scope should be merged or differentiated.

## Definition of Ready (per story)

- [ ] Clear persona and benefit
- [ ] Testable acceptance criteria
- [ ] Small enough for one iteration
- [ ] Dependencies identified
- [ ] Traces to a requirement
- [ ] No unresolved blocking open question

## Scoring guidance

- A story is **Ready** when it passes DoR and scores 3 on Testable and Valuable with no dimension at 1.
- A story is **Needs work** when any dimension scores 1 or acceptance criteria are not testable.
- Report an overall **coverage percentage**: covered REQ IDs / total REQ IDs.
