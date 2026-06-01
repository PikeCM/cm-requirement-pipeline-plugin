# Project Summary

A handoff document for continuing this work in a new Claude Code chat. Covers what exists today and the next project being planned.

## Part 1: What exists - the requirements-pipeline plugin

A Claude Code plugin that turns a meeting recording into a reviewed SAFe backlog, all local and on-device.

- **Repo (local)**: `C:\Users\Devel\cm-requirement-pipeline-plugin`
- **Repo (GitHub)**: `https://github.com/PikeCM/cm-requirement-pipeline-plugin` (private)
- **Marketplace id**: `cloudmasonry` (independent of the repo name)
- **Install**: `/plugin marketplace add <git-url>` then `/plugin install requirements-pipeline@cloudmasonry`

### The four skills (stages)
1. **transcribe-media** - extract a transcript from audio/video locally. Prefers an existing `.vtt`/`.srt` caption sidecar (faster, keeps speaker labels) over re-transcribing audio. Scripts: `setup-toolchain.sh`, `transcribe.sh`, `transcribe_fw.py`, `captions_to_transcript.py`.
2. **draft-specification** - transcript to a structured specification document. Assigns stable REQ-IDs, separates functional/non-functional, flags assumptions and open questions.
3. **generate-safe-stories** - spec to SAFe features, user stories, and enabler stories with REQ-ID traceability.
4. **review-story-quality** - grades stories on INVEST, acceptance-criteria quality, and two-way requirement coverage.

### Conventions (carry these forward)
- **Output root resolution**: explicit path in request, then `REQUIREMENTS_PIPELINE_OUTPUT_ROOT` env var, then the source's folder. Confirm if not explicit.
- **Output layout**: one folder named after the source file, three docs each with a type suffix (`- Specification.md`, `- User Stories.md`, `- Quality Review.md`).
- Documents cross-link with Obsidian `[[wikilinks]]`.
- Personal default set in `~/.claude/settings.json`: `REQUIREMENTS_PIPELINE_OUTPUT_ROOT` points to the Obsidian vault `Transcript Conversion` folder.

### Local transcription toolchain (installed, verified)
- **ffmpeg** 8.1.1 via winget (`Gyan.FFmpeg.Essentials`).
- **Python 3.12** via winget. Note: system Python is 3.14, too new for the transcription wheels, hence a dedicated 3.12.
- **faster-whisper** in a venv at `~/.cloudmasonry/requirements-pipeline/venv`. Models cache on first run.
- Native PowerShell `Rename-Item` works for folder renames where MSYS `mv` reports "busy".

## Part 2: What's next - local Obsidian project-research system

Goal: a local, file-based version of a project previously worked on in another Claude instance. Pull project data into Obsidian, generate research against a standard template, and store the research in Obsidian.

### Sources to ingest
- Local files: `.docx`/`.pdf` docs, `.csv`, `.xls`/`.xlsx`.
- Jira tickets.
- Future: Granola.ai and Slack.

### Proposed architecture (same shape as the requirements pipeline)
- Ingest from many sources, normalize each to a Markdown note in Obsidian (frontmatter + `[[wikilinks]]`), then generate research against a standard template.
- Likely a second plugin (for example `project-research`) in this same marketplace repo, reusing the Obsidian output conventions and the configurable output-root pattern.
- One ingestion skill per local source type (docs, CSV, XLS). Converting Office files to Markdown also solves Obsidian not showing non-Markdown files by default.
- A standard research template plus a research-generation skill (mirrors the spec template and draft-specification).

### Key shortcut
- Do not hand-roll API integrations for Jira, Slack, or Granola. This environment already has MCP connectors for Atlassian (Jira), Slack, and Granola. Use those connectors; only the local file ingestion needs new skills.

### Open decisions for the new chat
1. Same marketplace repo as a second plugin, or a new repo? (Recommend same repo; consider a broader marketplace name.)
2. Research template structure.
3. Which Jira project/board and which Granola/Slack scopes (minimum necessary access).

### Data handling
- This pulls client material into local Obsidian files. Keep confidential, keep out of git (`.gitignore` blocks docs/CSV/transcripts/media), and scope any connector to minimum necessary access.
