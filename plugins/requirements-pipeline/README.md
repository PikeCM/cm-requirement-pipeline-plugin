# requirements-pipeline

A CloudMasonry Claude Code plugin that takes a meeting recording all the way to a reviewed SAFe backlog, in four stages:

1. **transcribe-media** — extract a transcript from audio or video, locally and on-device.
2. **draft-specification** — turn the transcript into a structured specification document.
3. **generate-safe-stories** — turn the reviewed spec into SAFe features, user stories, and enabler stories with traceability.
4. **review-story-quality** — grade the stories against INVEST, acceptance-criteria quality, and two-way requirement coverage.

The stages are independent skills. Claude invokes the relevant one based on what you ask, so you can also start in the middle (for example, run `draft-specification` on a transcript you already have).

## Output layout

All three documents for one recording go into a single folder named after the source file, each distinguished by a type suffix:

```
<source name>/
  <source name> - Specification.md
  <source name> - User Stories.md
  <source name> - Quality Review.md
```

`draft-specification` creates the folder; the later stages write into it. Documents cross-link with Obsidian-style `[[wikilinks]]`.

### Controlling the output location

The output root (where that source-named folder is created) is resolved in this order:

1. An explicit path given in the request ("output to ...").
2. The environment variable `REQUIREMENTS_PIPELINE_OUTPUT_ROOT`, if set.
3. Fallback: the directory containing the source transcript.

To set a personal default, add the variable to your Claude Code settings `env` block, for example:

```json
{
  "env": {
    "REQUIREMENTS_PIPELINE_OUTPUT_ROOT": "C:\\Users\\you\\OneDrive\\Documents\\Obsidian Vault\\Transcript Conversion"
  }
}
```

Each team member sets their own path; do not hardcode a path into the plugin.

## The traceability spine

Every requirement gets a stable ID (REQ-001, ...) in stage 2. Those IDs flow into stories in stage 3 and are checked both ways in stage 4: no orphan stories, no uncovered requirements. Do not renumber requirement IDs once assigned.

## Human checkpoints

The pipeline is built to amplify the architect, not replace them. Review and confirm the specification (after stage 2) before generating stories, because errors there compound. The quality review presents findings as input to your judgment, not a verdict.

## Transcription toolchain

`transcribe-media` needs ffmpeg and a local faster-whisper environment. Run the one-time setup:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/skills/transcribe-media/scripts/setup-toolchain.sh"
```

All transcription is local. No audio or transcript content leaves the machine, which is the default for confidential client recordings.

## Data handling

Treat transcripts, specs, and stories as client-confidential. Keep them in controlled locations and do not paste client specifics into external services.
