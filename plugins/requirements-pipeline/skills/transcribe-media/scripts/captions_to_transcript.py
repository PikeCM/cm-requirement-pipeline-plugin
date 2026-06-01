"""Convert a .vtt or .srt caption file into a clean, speaker-attributed transcript.

Caption sidecar files (often exported by Teams, Zoom, Webex) are usually a
better transcript source than re-transcribing audio, because they already
carry speaker labels. This strips cue numbers, timestamps, and the WEBVTT
header, then merges each speaker's consecutive cues into readable turns.

Usage: captions_to_transcript.py <input.vtt|input.srt> [output.txt]
"""
import os
import re
import sys

TS_RE = re.compile(r"-->")
# "Speaker Name: text" where the name is short and looks like a name
SPEAKER_RE = re.compile(r"^([^:]{1,40}):\s+(.*)$")


def is_cue_index(line: str) -> bool:
    return line.strip().isdigit()


def looks_like_speaker(prefix: str) -> bool:
    words = prefix.strip().split()
    return 1 <= len(words) <= 4


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: captions_to_transcript.py <input.vtt|.srt> [output.txt]", file=sys.stderr)
        return 2
    src = sys.argv[1]
    out = sys.argv[2] if len(sys.argv) > 2 else os.path.splitext(src)[0] + ".transcript.txt"

    turns = []  # list of [speaker, text]
    with open(src, encoding="utf-8-sig") as f:
        for raw in f:
            line = raw.strip()
            if not line or line == "WEBVTT" or TS_RE.search(line) or is_cue_index(line):
                continue
            if line.startswith("NOTE"):
                continue
            speaker, text = None, line
            m = SPEAKER_RE.match(line)
            if m and looks_like_speaker(m.group(1)):
                speaker, text = m.group(1).strip(), m.group(2).strip()
            if turns and turns[-1][0] == speaker:
                turns[-1][1] += " " + text
            else:
                turns.append([speaker, text])

    with open(out, "w", encoding="utf-8") as fo:
        for speaker, text in turns:
            if speaker:
                fo.write(f"{speaker}: {text}\n\n")
            else:
                fo.write(f"{text}\n\n")

    speakers = sorted({s for s, _ in turns if s})
    print(f"Wrote {out}")
    print(f"Turns: {len(turns)} | Speakers detected: {len(speakers)}")
    if speakers:
        print("Speakers: " + ", ".join(speakers))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
