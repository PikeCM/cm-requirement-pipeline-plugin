"""Local transcription with faster-whisper. Writes .txt and .srt next to outbase.
Usage: transcribe_fw.py <audio.wav> [model] [outbase]
"""
import os
import sys

from faster_whisper import WhisperModel


def fmt_ts(t: float) -> str:
    h = int(t // 3600)
    m = int((t % 3600) // 60)
    s = int(t % 60)
    ms = int(round((t - int(t)) * 1000))
    return f"{h:02d}:{m:02d}:{s:02d},{ms:03d}"


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: transcribe_fw.py <audio.wav> [model] [outbase]", file=sys.stderr)
        return 2
    audio = sys.argv[1]
    model_size = sys.argv[2] if len(sys.argv) > 2 else "small.en"
    outbase = sys.argv[3] if len(sys.argv) > 3 else os.path.splitext(audio)[0]

    # int8 keeps it light on CPU; good enough for meeting audio.
    model = WhisperModel(model_size, device="cpu", compute_type="int8")
    segments, info = model.transcribe(audio, vad_filter=True)

    txt_path = outbase + ".txt"
    srt_path = outbase + ".srt"
    with open(txt_path, "w", encoding="utf-8") as ft, open(srt_path, "w", encoding="utf-8") as fs:
        for i, seg in enumerate(segments, 1):
            text = seg.text.strip()
            ft.write(text + "\n")
            fs.write(f"{i}\n{fmt_ts(seg.start)} --> {fmt_ts(seg.end)}\n{text}\n\n")
            # stream progress so the caller sees it working
            print(f"[{fmt_ts(seg.start)}] {text}", flush=True)

    print(
        f"\nDONE language={info.language} ({info.language_probability:.2f}) "
        f"duration={info.duration:.1f}s -> {txt_path}",
        flush=True,
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
