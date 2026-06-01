# Backlog: <Project / Session Name>

Source specification: `<spec file>`

---

## Feature F1: <title>
- **Benefit hypothesis**: We believe <change> will result in <outcome>, measured by <metric>.
- **Traceability**: REQ-XXX, REQ-YYY
- **Feature acceptance criteria**:
  - [ ] <condition>
  - [ ] <condition>

### Story F1-S1: <short title>
> As a **<persona from spec section 2>**, I want **<goal>**, so that **<benefit>**.

- **Type**: User story
- **Traceability**: REQ-XXX
- **Suggested size**: <XS / S / M / L — team estimates points>
- **Acceptance criteria**:
  - Given <context>, when <action>, then <outcome>.
  - Given <context>, when <action>, then <outcome>.
- **Blocked by**: <open question #, if any — else None>

### Story F1-S2: <short title> (Enabler)
- **Type**: Enabler — <Architectural / Infrastructure / Exploration / Compliance>
- **Traceability**: REQ-XXX
- **Description**: <technical work and why it is needed>
- **Definition of done**:
  - [ ] <condition>
  - [ ] <condition>

---

## Coverage check
| REQ ID | Covered by | Status |
|--------|-----------|--------|
| REQ-001 | F1-S1 | Covered |
| REQ-NFR-001 | F1-S2 | Covered |

List any REQ IDs with no story and the reason.
