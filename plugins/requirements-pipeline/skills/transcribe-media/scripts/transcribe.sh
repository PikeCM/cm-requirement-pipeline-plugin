#!/usr/bin/env bash
# Extract audio with ffmpeg and transcribe locally with faster-whisper.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_HOME="${CLOUDMASONRY_HOME:-$HOME/.cloudmasonry/requirements-pipeline}"

INPUT="${1:?usage: transcribe.sh <media-file> [model] [output-dir]}"
MODEL="${2:-small.en}"
OUTDIR="${3:-$(dirname "$INPUT")}"

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg not found. Run setup-toolchain.sh first." >&2; exit 1
fi
if [ -e "$DATA_HOME/venv/Scripts/python.exe" ]; then VPY="$DATA_HOME/venv/Scripts/python.exe";
elif [ -e "$DATA_HOME/venv/bin/python" ]; then VPY="$DATA_HOME/venv/bin/python";
else echo "Transcription venv missing. Run setup-toolchain.sh first." >&2; exit 1; fi

mkdir -p "$OUTDIR"
base="$(basename "${INPUT%.*}")"
wav="$OUTDIR/${base}.16k.wav"

echo "[1/2] Extracting mono 16 kHz audio -> $wav"
ffmpeg -y -loglevel error -i "$INPUT" -vn -ac 1 -ar 16000 "$wav"

echo "[2/2] Transcribing locally with faster-whisper (model=$MODEL, CPU). No data leaves this machine."
"$VPY" "$SCRIPT_DIR/transcribe_fw.py" "$wav" "$MODEL" "$OUTDIR/$base"

echo
echo "Done."
echo "  Transcript : $OUTDIR/${base}.txt"
echo "  Timestamps : $OUTDIR/${base}.srt"
