# CloudMasonry Claude Code Plugins

Internal Claude Code plugin marketplace for CloudMasonry Salesforce delivery work.

## Plugins

### requirements-pipeline
Takes a meeting recording all the way to a reviewed SAFe backlog, in four stages:
1. **transcribe-media** - extract a transcript from audio or video, locally and on-device (prefers existing `.vtt`/`.srt` captions when present).
2. **draft-specification** - turn the transcript into a structured specification document.
3. **generate-safe-stories** - turn the reviewed spec into SAFe features, user stories, and enabler stories with traceability.
4. **review-story-quality** - grade the stories against INVEST, acceptance-criteria quality, and two-way requirement coverage.

See [`plugins/requirements-pipeline/README.md`](plugins/requirements-pipeline/README.md) for details.

## Install

From this repository (once pushed):

```
/plugin marketplace add <git-url>
/plugin install requirements-pipeline@cloudmasonry
```

Or from a local clone:

```
/plugin marketplace add <path-to-clone>
/plugin install requirements-pipeline@cloudmasonry
```

## Transcription toolchain

`transcribe-media` needs ffmpeg and a local faster-whisper environment. Run the one-time setup after install:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/skills/transcribe-media/scripts/setup-toolchain.sh"
```

All transcription is local and on-device.

## Data handling

Do not commit client recordings, transcripts, specifications, or generated stories to this repository. The `.gitignore` blocks common media and caption files as a safeguard, but treat all client artifacts as confidential and keep them out of version control.

## Repository layout

```
.claude-plugin/
  marketplace.json          # marketplace manifest (name: cloudmasonry)
plugins/
  requirements-pipeline/
    .claude-plugin/plugin.json
    README.md
    skills/
      transcribe-media/
      draft-specification/
      generate-safe-stories/
      review-story-quality/
```
