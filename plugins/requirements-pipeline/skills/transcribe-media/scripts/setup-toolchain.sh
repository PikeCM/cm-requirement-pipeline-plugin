#!/usr/bin/env bash
# Idempotent setup for the transcribe-media skill: ffmpeg + a local
# faster-whisper virtual environment. Everything runs on-device.
set -euo pipefail

DATA_HOME="${CLOUDMASONRY_HOME:-$HOME/.cloudmasonry/requirements-pipeline}"
VENV="$DATA_HOME/venv"
mkdir -p "$DATA_HOME"

echo "== 1/3 ffmpeg =="
if command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg present: $(ffmpeg -version 2>/dev/null | head -1)"
else
  echo "ffmpeg not found. Installing via winget..."
  if command -v winget >/dev/null 2>&1; then
    winget install --id Gyan.FFmpeg.Essentials -e --accept-source-agreements --accept-package-agreements \
      || { echo "ERROR: winget could not install ffmpeg. Install it manually, then re-run." >&2; exit 1; }
    echo "ffmpeg installed. You may need to open a new shell for PATH to update."
  else
    echo "ERROR: winget unavailable. Install ffmpeg manually, then re-run." >&2
    exit 1
  fi
fi

echo "== 2/3 locating a compatible Python (<= 3.12) =="
PY_BIN=""
ver_ok() {
  # returns 0 if $1 is a python with version <= 3.12 and >= 3.9
  "$1" -c 'import sys; sys.exit(0 if (3,9) <= sys.version_info[:2] <= (3,12) else 1)' >/dev/null 2>&1
}
for cand in python3.12 python3.11 python3.10 python3 python; do
  if command -v "$cand" >/dev/null 2>&1 && ver_ok "$cand"; then PY_BIN="$(command -v "$cand")"; break; fi
done
# Windows py launcher
if [ -z "$PY_BIN" ] && command -v py >/dev/null 2>&1; then
  if py -3.12 -c 'import sys' >/dev/null 2>&1; then PY_BIN="py -3.12"; fi
fi
# Last resort: install Python 3.12 via winget
if [ -z "$PY_BIN" ]; then
  echo "No compatible Python found. Attempting to install Python 3.12 via winget..."
  if command -v winget >/dev/null 2>&1; then
    winget install --id Python.Python.3.12 -e --accept-source-agreements --accept-package-agreements \
      || { echo "ERROR: could not install Python 3.12. Install it manually, then re-run." >&2; exit 1; }
    echo "Python 3.12 installed. Open a NEW shell and re-run this script so it is on PATH."
    exit 0
  else
    echo "ERROR: no compatible Python and no winget. Install Python 3.12 manually." >&2
    exit 1
  fi
fi
echo "Using Python: $PY_BIN ($($PY_BIN --version 2>&1))"

echo "== 3/3 creating venv and installing faster-whisper =="
if [ ! -e "$VENV/Scripts/python.exe" ] && [ ! -e "$VENV/bin/python" ]; then
  $PY_BIN -m venv "$VENV"
fi
if [ -e "$VENV/Scripts/python.exe" ]; then VPY="$VENV/Scripts/python.exe"; else VPY="$VENV/bin/python"; fi
"$VPY" -m pip install --upgrade pip >/dev/null
"$VPY" -m pip install faster-whisper

echo
echo "Setup complete."
echo "  venv python : $VPY"
echo "  data home   : $DATA_HOME"
echo "Models download on first transcription and are cached under your home directory."
