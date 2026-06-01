# SAFe Story Reference

A working reference for generating backlog items in SAFe (Scaled Agile Framework). This is a practical subset, not the full framework.

## The hierarchy

```
Epic           (large initiative, business or enabler; not generated here unless asked)
  Capability   (large-solution level; only in large multi-ART solutions)
    Feature    (delivers stakeholder value, fits within a Program Increment)
      Story    (small, fits within an iteration)
```

For most engagements you generate **Features** and the **Stories** beneath them. Generate Epics or Capabilities only when the spec scope clearly warrants them.

## Feature

A feature delivers value to a stakeholder and is sized to fit in a Program Increment (PI).

Each feature has:
- **Title**: short, value-oriented.
- **Benefit hypothesis**: the expected business outcome ("We believe X will result in Y, measured by Z").
- **Acceptance criteria**: feature-level conditions of satisfaction.
- **Traceability**: the REQ IDs the feature addresses.

## User Story

Format:

> As a **[persona]**, I want **[goal]**, so that **[benefit]**.

Each story has:
- **Acceptance criteria** in Given / When / Then form.
- **Story points** placeholder (estimated by the team; leave a suggested relative size if helpful).
- **Traceability**: REQ ID(s).

A good user story is vertical: it delivers a thin slice of observable value, not a technical layer.

## Enabler Story

Enablers support future business functionality and have no direct user-facing value. SAFe enabler types:
- **Architectural**: e.g., design the sharing model, define the object schema.
- **Infrastructure**: e.g., set up environments, CI, deployment pipeline.
- **Exploration**: spikes and research to resolve open questions.
- **Compliance**: e.g., audit trail, data retention, regulatory controls.

Write enablers with a clear definition of done and acceptance criteria, even though they are not phrased "As a user". On Salesforce work, enablers commonly include data migration, integration scaffolding, security and sharing configuration, and environment/release management.

## INVEST (write stories to pass this; the quality skill grades against it)

- **Independent**: minimal dependence on other stories.
- **Negotiable**: a placeholder for a conversation, not a rigid contract.
- **Valuable**: delivers value to a user or to the business.
- **Estimable**: enough clarity for the team to size it.
- **Small**: fits comfortably within one iteration.
- **Testable**: acceptance criteria can be turned into a test.

## Acceptance criteria pattern

```
Given <initial context>
When <action or event>
Then <observable outcome>
```

Prefer several focused criteria over one broad one. Each criterion should be independently verifiable.

## Definition of Ready (DoR) checklist

A story is ready to be pulled into an iteration when it: has a clear persona and benefit, has testable acceptance criteria, is small enough to fit an iteration, has dependencies identified, traces to a requirement, and has no unresolved blocking open questions.
