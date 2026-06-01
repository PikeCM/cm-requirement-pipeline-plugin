---
name: transcribe-media
description: This skill should be used when the user wants to transcribe, "rip the text out of", or extract a transcript from an audio or video file (mp4, mov, m4a, mp3, wav, mkv) such as a meeting or discovery-session recording. Performs local, on-device speech-to-text. It is the first stage of the requirements pipeline that feeds draft-specification.
version: 0.1.0
---

# Transcribe Media

Convert a recorded meeting (audio or video) into a plain-text transcript, entirely on the local machine. No audio leaves the device, which matters for confidential client recordings under SOC 2 handling.

## When to use this skill

Use it when the user wants a transcript out of a media file, or points at an mp4/mov/m4a/mp3 and asks to extract the speech. This is stage one of the pipeline. The output transcript is the input to the `draft-specification` skill.

## Before transcribing: prefer existing captions

Transcription is the fallback. If a caption source already exists, use it instead. It is faster, and platform-exported captions usually include speaker labels, which whisper cannot produce.

**Sidecar caption file (best case).** If a `.vtt` or `.srt` file sits next to the media (common from Teams, Zoom, or Webex exports), convert it directly into a clean, speaker-attributed transcript:

```bash
python "${CLAUDE_PLUGIN_ROOT}/skills/transcribe-media/scripts/captions_to_transcript.py" "<file.vtt>" "<output.transcript.txt>"
```

This strips the WebVTT header, cue numbers, and timestamps, and merges each speaker's consecutive cues into readable turns. Skim the speaker list it reports for any parse artifacts.

**Embedded track.** Some recordings carry a usable caption/subtitle track inside the container. Probe it first:

```bash
ffprobe -v error -show_entries stream=index,codec_type,codec_name -of default=noprint_wrappers=1 "<media-file>"
```

If a real subtitle/caption stream is present (not a 1-sample placeholder), extract it directly:

```bash
ffmpeg -i "<media-file>" -map 0:s:0 "<output>.srt"
```

Otherwise transcribe the audio (below).

## One-time toolchain setup

The skill needs ffmpeg (audio extraction) and a local whisper engine (faster-whisper in a dedicated Python virtual environment). If either is missing, run the setup script. It is idempotent.

```bash
bash "${CLAUDE_PLUGIN_ROOT}/skills/transcribe-media/scripts/setup-toolchain.sh"
```

Notes:
- On Windows the system Python may be too new (3.13+) for the transcription wheels. The setup script detects this and uses or installs a compatible Python (3.12).
- The transcription model downloads on first run and is cached. Default is `small.en`. Use `medium` for multi-speaker or noisy audio at the cost of speed.

## Transcribe

```bash
bash "${CLAUDE_PLUGIN_ROOT}/skills/transcribe-media/scripts/transcribe.sh" "<media-file>" [model] [output-dir]
```

- `model` (optional): `tiny.en`, `base.en`, `small.en` (default), `medium`, `large-v3`. English-only `.en` models are faster and more accurate on English audio.
- `output-dir` (optional): defaults to the media file's folder.

Outputs, next to the media file (or in `output-dir`):
- `<name>.txt` — plain transcript, one segment per line.
- `<name>.srt` — timestamped segments, useful for jumping back to the recording.

## Important limits to state to the user

- Whisper transcribes speech but does not label who is speaking. There is no speaker separation (diarization) here. If the specification needs "who said what", that is a separate step and should be flagged as an assumption.
- Transcription is approximate. Proper nouns, product names, and acronyms are the most error-prone. Skim the transcript before treating it as ground truth.
- CPU transcription of a long recording takes a while. A 40-minute file on `small.en` is typically several minutes; `medium` is noticeably longer.

## Hand-off

Once the transcript exists, offer to continue with the `draft-specification` skill, passing the `.txt` file as input.
