#!/usr/bin/env bash
set -euo pipefail

PACK_NAME="cwagecraft"
MC_VERSION="1.20.1"
FORGE_VERSION="47.3.22"
AUTHOR="cwage"
OUT_DIR="$PWD"
PACK_DIR="$OUT_DIR/$PACK_NAME"
MRPACK="$OUT_DIR/${PACK_NAME}.mrpack"
PW="packwiz -y"
MODS_YAML="$OUT_DIR/mods.yaml"

UPGRADE=0
EXPORT=0

usage() {
  cat <<EOF
Usage: ./setup.sh [--upgrade] [--export-mods]

  --upgrade      Update all pinned mods to latest (re-adds each mod)
  --export-mods  Generate mods.yaml from currently installed mods and exit
EOF
}

for arg in "${@:-}"; do
  case "$arg" in
    --upgrade) UPGRADE=1 ;;
    --export-mods) EXPORT=1 ;;
    -h|--help) usage; exit 0 ;;
    "") ;;
    *) echo "Unknown arg: $arg"; usage; exit 1 ;;
  esac
done

echo "==> Reset"
rm -rf "$MRPACK"
mkdir -p "$PACK_DIR"
cd "$PACK_DIR"

if [[ ! -f "$PACK_DIR/pack.toml" ]]; then
    echo "==> Init pack ($MC_VERSION Forge $FORGE_VERSION)"
    init_success=false
    for attempt in 1 2; do
        if [[ $attempt -gt 1 ]]; then
            echo "    Init attempt $attempt/2 (network error, retrying...)"
            sleep 2
        fi
        if $PW init \
          --name "$PACK_NAME" \
          --author "$AUTHOR" \
          --version "1.0.0" \
          --mc-version "$MC_VERSION" \
          --modloader forge \
          --forge-version "$FORGE_VERSION"; then
            init_success=true
            break
        fi
    done
    if [[ "$init_success" != "true" ]]; then
        echo "ERROR: Failed to initialize pack after 2 attempts"
        exit 1
    fi
    echo "==> Accept MC $MC_VERSION family"
    $PW settings acceptable-versions --add 1.20
    $PW settings acceptable-versions --add 1.20.1
else
    echo "==> Pack already exists, skipping init"
fi

# Locate mod file by update id
find_mod_file_by_mr() {
  local mr_id="$1"
  grep -RIl --null -- "mod-id = \"$mr_id\"" "$PACK_DIR/mods" 2>/dev/null | tr -d '\0' | head -n1 || true
}

find_mod_file_by_cf() {
  local cf_proj="$1"
  grep -RIl --null -- "project-id = $cf_proj" "$PACK_DIR/mods" 2>/dev/null | tr -d '\0' | head -n1 || true
}

# Fallback: locate by slug filename
find_mod_file_by_slug() {
  local slug="$1"
  local cand="$PACK_DIR/mods/${slug}.pw.toml"
  [[ -f "$cand" ]] && echo "$cand" || true
}

# Add a mod with retry; prefer Modrinth then CurseForge
add_mod_with_retry() {
  local name="$1"; local slug="$2"; local mr="$3"; local cf="$4"
  local max_attempts=2
  echo "Adding: $name ($slug)"
  local attempt output exit_code
  if [[ -n "$mr" ]]; then
    for ((attempt=1; attempt<=max_attempts; attempt++)); do
      [[ $attempt -gt 1 ]] && echo "    Retry MR $attempt/$max_attempts..." && sleep $((attempt-1))
      output=$($PW modrinth add "$mr" 2>&1) && { echo "    ✓ MR"; return 0; } || exit_code=$?
      if [[ "$output" == *network* || "$output" == *connection* || "$output" == *TLS* || "$output" == *timeout* || "$output" == *SSL* ]]; then
        continue
      else
        break
      fi
    done
  fi
  if [[ -n "$cf" ]]; then
    for ((attempt=1; attempt<=max_attempts; attempt++)); do
      [[ $attempt -gt 1 ]] && echo "    Retry CF $attempt/$max_attempts..." && sleep $((attempt-1))
      output=$($PW curseforge add "$cf" 2>&1) && { echo "    ✓ CF (id)"; return 0; } || true
      output=$($PW curseforge add "$slug" 2>&1) && { echo "    ✓ CF (slug)"; return 0; } || true
    done
  fi
  return 0
}

process_mod() {
  local name="$1" slug="$2" mr="$3" cf="$4"
  local modfile=""
  if [[ -n "$mr" ]]; then
    modfile=$(find_mod_file_by_mr "$mr") || true
  fi
  if [[ -z "$modfile" && -n "$cf" ]]; then
    modfile=$(find_mod_file_by_cf "$cf") || true
  fi
  if [[ -z "$modfile" && -n "$slug" ]]; then
    modfile=$(find_mod_file_by_slug "$slug") || true
  fi
  if [[ -n "$modfile" && $UPGRADE -eq 0 ]]; then
    echo "    ✓ Present (pinned): $name"
    return 0
  fi
  if [[ -n "$modfile" && $UPGRADE -eq 1 ]]; then
    echo "    ~ Upgrading: $name"
    rm -f "$modfile"
  fi
  add_mod_with_retry "$name" "$slug" "$mr" "$cf"
}

export_mods_yaml() {
  echo "mods:" > "$MODS_YAML"
  for f in "$PACK_DIR"/mods/*.pw.toml; do
    [[ -e "$f" ]] || continue
    local name slug mr cf proj fileid
    name=$(grep -m1 '^name = ' "$f" | sed 's/^name = \"\(.*\)\"/\1/')
    slug=$(basename "$f" | sed 's/\.pw\.toml$//')
    mr=$(awk '/\[update.modrinth\]/{flag=1;next}/\[/{flag=0}flag && /mod-id =/{gsub(/.*= \"|\"/,"",$0);print $0}' "$f" || true)
    proj=$(awk '/\[update.curseforge\]/{flag=1;next}/\[/{flag=0}flag && /project-id =/{gsub(/.*= /,"",$0);print $0}' "$f" || true)
    fileid=$(awk '/\[update.curseforge\]/{flag=1;next}/\[/{flag=0}flag && /file-id =/{gsub(/.*= /,"",$0);print $0}' "$f" || true)
    cf="$proj"
    printf "  - name: \"%s\"\n    slug: %s\n    mr: %s\n    cf: %s\n" "$name" "$slug" "${mr:-}" "${cf:-}" >> "$MODS_YAML"
  done
  echo "==> Wrote $MODS_YAML"
}

if [[ $EXPORT -eq 1 ]]; then
  echo "==> Exporting installed mods to mods.yaml"
  export_mods_yaml
  exit 0
fi

if [[ ! -f "$MODS_YAML" ]]; then
  echo "ERROR: mods.yaml not found at $MODS_YAML"
  echo "Hint: run './setup.sh --export-mods' to bootstrap from current pack."
  exit 1
fi

echo "==> Ensuring mods from mods.yaml (upgrade=$UPGRADE)"
current_key=""; name=""; slug=""; mr=""; cf=""; have_record=0
while IFS= read -r line || [[ -n "$line" ]]; do
  trimmed="$(echo "$line" | sed 's/^\s*//')"
  [[ -z "$trimmed" ]] && continue
  [[ "$trimmed" =~ ^# ]] && continue
  if [[ "$trimmed" == -* ]]; then
    if [[ $have_record -eq 1 ]]; then
      process_mod "$name" "$slug" "$mr" "$cf"
    fi
    name=""; slug=""; mr=""; cf=""; have_record=1
    continue
  fi
  key="${trimmed%%:*}"
  val="${trimmed#*:}"
  val="$(echo "$val" | sed 's/^\s*//; s/^\"//; s/\"$//')"
  case "$key" in
    name) name="$val" ;;
    slug) slug="$val" ;;
    mr) mr="$val" ;;
    cf) cf="$val" ;;
  esac
done < "$MODS_YAML"
if [[ $have_record -eq 1 ]]; then
  process_mod "$name" "$slug" "$mr" "$cf"
fi

echo "==> Refresh index"
$PW refresh

echo "==> Export Modrinth pack (.mrpack)"
$PW modrinth export --output "$MRPACK" --restrictDomains=false

echo
echo "==> Done."
echo "Import '$MRPACK' in PolyMC/Prism: Add Instance -> Import from zip (select the .mrpack)."
