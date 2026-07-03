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
      echo "Usage: scripts/install.sh [--prefix PREFIX]"
      exit 0
      ;;
    *)
      echo "unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
repo_root="$(CDPATH= cd -- "$script_dir/.." && pwd)"
target_dir="$prefix/bin"
target="$target_dir/codex-voicevox-watch"
source="$repo_root/bin/codex-voicevox-watch"
marker="# codex-voicevox-watch managed launcher"

mkdir -p "$target_dir"

if [ -e "$target" ] && ! grep -Fqx "$marker" "$target"; then
  echo "refusing to overwrite unmanaged file: $target" >&2
  exit 1
fi

cat > "$target" <<EOF
#!/usr/bin/env bash
set -euo pipefail
$marker
exec "$source" "\$@"
EOF

chmod +x "$target"
echo "installed: $target"
