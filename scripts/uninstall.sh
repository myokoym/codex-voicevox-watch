#!/usr/bin/env bash
set -euo pipefail

prefix="$HOME/.local"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --prefix)
      if [ "$#" -lt 2 ]; then
        echo "missing value for --prefix" >&2
        exit 2
      fi
      prefix="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: scripts/uninstall.sh [--prefix PREFIX]"
      exit 0
      ;;
    *)
      echo "unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

target="$prefix/bin/codex-voicevox-watch"
marker="# codex-voicevox-watch managed launcher"

if [ ! -e "$target" ]; then
  echo "not installed: $target"
  exit 0
fi

if ! grep -Fqx "$marker" "$target"; then
  echo "refusing to remove unmanaged file: $target" >&2
  exit 1
fi

rm "$target"
echo "removed: $target"
