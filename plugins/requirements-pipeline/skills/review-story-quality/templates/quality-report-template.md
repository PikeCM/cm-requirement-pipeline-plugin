# Story Quality Review: <Project / Session Name>

| Field | Value |
|-------|-------|
| Specification | <spec file> |
| Stories | <stories file> |
| Reviewed by | <name> |
| Date | <YYYY-MM-DD> |

## Summary
- Requirement coverage: **<x>%** (<covered>/<total> REQ IDs)
- Stories reviewed: <n>
- Stories Ready: <n> | Needs work: <n>
- Top issues: <one-line list>

## 1. Coverage matrix (backward: spec to stories)
| REQ ID | Requirement (short) | Covered by | Status |
|--------|---------------------|-----------|--------|
| REQ-001 | | F1-S1 | Covered |
| REQ-002 | | — | GAP |

List every uncovered REQ ID and every NFR without a story.

## 2. Orphan check (forward: stories to spec)
| Story | Claims REQ | Exists in spec? |
|-------|-----------|-----------------|
| F1-S1 | REQ-001 | Yes |

## 3. Per-story scores
| Story | I | N | V | E | S | T | AC testable? | Verdict |
|-------|---|---|---|---|---|---|--------------|---------|
| F1-S1 | 3 | 3 | 3 | 2 | 3 | 3 | Yes | Ready |

(I/N/V/E/S/T scored 1-3 per the rubric.)

## 4. Findings and rewrites
For each story that needs work:

### <Story ID>: <title>
- **Weakest dimension(s)**: <e.g., Testable (1)> — <reason>
- **Suggested rewrite**:
  > As a <persona>, I want <goal>, so that <benefit>.
  > - Given <context>, when <action>, then <outcome>.

## 5. Duplicates and overlaps
<stories that should be merged or differentiated>

## 6. Recommended next actions
Prioritized list: gaps to close first, then the highest-impact rewrites.
