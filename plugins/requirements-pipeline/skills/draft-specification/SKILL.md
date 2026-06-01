---
name: draft-specification
description: This skill should be used when the user wants to turn a meeting transcript, discovery notes, or raw requirements into a structured specification document. It is stage two of the requirements pipeline, taking a transcript (often from transcribe-media) and producing a spec that feeds generate-safe-stories.
version: 0.1.0
---

# Draft Specification

Turn a messy, conversational transcript into a structured specification document. The job is extraction and organization, not invention.

## When to use this skill

After a transcript or set of discovery notes exists and the user wants a specification. The output spec is the input to `generate-safe-stories`.

## Core rules

1. **Do not invent requirements.** Capture only what the source supports. Where the source is ambiguous, silent, or contradictory, record it under Open Questions rather than guessing.
2. **State assumptions explicitly.** Any requirement that depends on information not in the transcript gets an assumption noted against it.
3. **Give every requirement a stable ID** (REQ-001, REQ-002, ...). These IDs are the traceability spine. They flow into stories and into the quality review. Never renumber them later; append instead.
4. **Separate functional from non-functional.** Performance, security, data volume, compliance, and availability are non-functional requirements (NFRs) and are easy to miss in a transcript. Look for them actively.
5. **Flag the human checkpoint.** The specification is where errors compound. Tell the user plainly that they should review and confirm the spec before stories are generated.
6. **Match the audience and voice.** Plain English. Define Salesforce acronyms on first use. For Salesforce work, prefer platform-native, declarative framing and note declarative-versus-code tradeoffs where the source implies them.

## How to produce it

1. Read the transcript fully before writing anything.
2. Use the template at `${CLAUDE_PLUGIN_ROOT}/skills/draft-specification/templates/specification-template.md` as the structure.
3. Fill each section from the source. Leave a clear placeholder where the source is silent, and move the underlying uncertainty into Open Questions.
4. Tag each functional and non-functional requirement with a REQ ID and, where relevant, a priority (Must / Should / Could / Won't).
5. List the assumptions and open questions prominently. These are the most valuable part of the document for the reviewing architect.

## Output location convention

### Output root (where the files go)

The target directory is controlled. Resolve the output root in this order, and tell the user which was used:

1. **Explicit path in the request.** If the user names a directory (for example "output to `D:\Specs`"), use it. This always wins.
2. **Configured default.** Otherwise, if the environment variable `REQUIREMENTS_PIPELINE_OUTPUT_ROOT` is set, use that.
3. **Fallback.** Otherwise, use the directory containing the source transcript.

If the root came from option 2 or 3 (not given explicitly), confirm the resolved target with the user before writing anything. Never write outside the resolved output root.

### Folder and file names

Inside the output root, create one folder named exactly after the source file (base name, no extension), and write each document as the source name plus a type suffix:

- `<output root>/<source name>/<source name> - Specification.md`
- `<output root>/<source name>/<source name> - User Stories.md` (later stage)
- `<output root>/<source name>/<source name> - Quality Review.md` (later stage)

As the first stage, `draft-specification` creates the folder if it does not exist. Example with root `C:\Vault\Transcript Conversion` and source `2022-12-14 Sales Process Session 1`:
`C:\Vault\Transcript Conversion\2022-12-14 Sales Process Session 1\2022-12-14 Sales Process Session 1 - Specification.md`.

Cross-link the documents with Obsidian-style `[[wikilinks]]` in the frontmatter so they navigate together.

## Output

Write the specification to the source-named folder as `<source name> - Specification.md` per the convention above. Then summarize for the user: how many requirements were captured, how many open questions remain, and which sections were thin because the source did not cover them.

## Hand-off

Once the spec is reviewed and confirmed by the user, offer to continue with `generate-safe-stories`.
