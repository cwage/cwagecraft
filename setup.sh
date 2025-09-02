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

for arg in "$@"; do
  case "$arg" in
    --upgrade) UPGRADE=1 ;;
    --export-mods) EXPORT=1 ;;
    -h|--help) usage; exit 0 ;;
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
declare -A IDX_MR IDX_CF IDX_SLUG

# Detect common transient network errors in command output
is_network_error() {
  local s="$1"
  [[ "$s" == *network* || "$s" == *connection* || "$s" == *TLS* || "$s" == *timeout* || "$s" == *SSL* ]]
}

build_index() {
  IDX_MR=(); IDX_CF=(); IDX_SLUG=()
  local f slug mr proj
  for f in "$PACK_DIR"/mods/*.pw.toml; do
    [[ -e "$f" ]] || continue
    slug="${f##*/}"; slug="${slug%.pw.toml}"
    read mr proj < <(awk '
        BEGIN{mr="";proj=""}
        /\[update.modrinth\]/{in_mr=1;next}
        /\[update.curseforge\]/{in_cf=1;next}
        /\[/{in_mr=0;in_cf=0}
        in_mr && /mod-id =/ {gsub(/.*= \"|\"/,"",$0);mr=$0}
        in_cf && /project-id =/ {gsub(/.*= /,"",$0);proj=$0}
        END{print mr, proj}
    ' "$f")
    [[ -n "$mr" ]] && IDX_MR["$mr"]="$f"
    [[ -n "$proj" ]] && IDX_CF["$proj"]="$f"
    IDX_SLUG["$slug"]="$f"
  done
}

find_mod_file_by_mr() { local mr_id="$1"; echo "${IDX_MR[$mr_id]:-}"; }
find_mod_file_by_cf() { local cf_proj="$1"; echo "${IDX_CF[$cf_proj]:-}"; }
find_mod_file_by_slug() { local slug="$1"; echo "${IDX_SLUG[$slug]:-}"; }

# Add a mod with retry; prefer Modrinth then CurseForge
add_mod_with_retry() {
  local name="$1"; local slug="$2"; local mr="$3"; local cf="$4"
  local max_attempts=2
  echo "Adding: $name ($slug)"
  local attempt output exit_code
  if [[ -n "$mr" ]]; then
    for ((attempt=1; attempt<=max_attempts; attempt++)); do
      [[ $attempt -gt 1 ]] && echo "    Retry MR $attempt/$max_attempts..." && sleep $((attempt-1))
      output=$($PW modrinth add "$mr" 2>&1); exit_code=$?
      if [[ $exit_code -eq 0 ]]; then
        echo "    ✓ MR"; return 0
      elif is_network_error "$output"; then
        continue
      else
        break
      fi
    done
  fi
  if [[ -n "$cf" ]]; then
    for ((attempt=1; attempt<=max_attempts; attempt++)); do
      [[ $attempt -gt 1 ]] && echo "    Retry CF $attempt/$max_attempts..." && sleep $((attempt-1))
      output=$($PW curseforge add "$cf" 2>&1); exit_code=$?
      if [[ $exit_code -eq 0 ]]; then
        echo "    ✓ CF (id)"; return 0
      elif is_network_error "$output"; then
        continue
      fi
      output=$($PW curseforge add "$slug" 2>&1); exit_code=$?
      if [[ $exit_code -eq 0 ]]; then
        echo "    ✓ CF (slug)"; return 0
      elif is_network_error "$output"; then
        continue
      else
        break
      fi
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
    build_index
  fi
  add_mod_with_retry "$name" "$slug" "$mr" "$cf"
  build_index
}

export_mods_yaml() {
  echo "mods:" > "$MODS_YAML"
  for f in "$PACK_DIR"/mods/*.pw.toml; do
    [[ -e "$f" ]] || continue
    local name slug mr cf proj
    name=$(grep -m1 '^name = ' "$f" | sed -E 's/^name = "?([^"]+)"?/\1/')
    slug="${f##*/}"; slug="${slug%.pw.toml}"
    read mr proj < <(awk '
        BEGIN{mr="";proj=""}
        /\[update.modrinth\]/{in_mr=1;next}
        /\[update.curseforge\]/{in_cf=1;next}
        /\[/{in_mr=0;in_cf=0}
        in_mr && /mod-id =/ {gsub(/.*= \"|\"/,"",$0);mr=$0}
        in_cf && /project-id =/ {gsub(/.*= /,"",$0);proj=$0}
        END{print mr, proj}
    ' "$f")
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
build_index
if command -v yq >/dev/null 2>&1; then
  # Robust YAML parsing if yq is available
  while IFS=$'\t' read -r name slug mr cf; do
    [[ -z "$name" || -z "$slug" ]] && continue
    process_mod "$name" "$slug" "${mr:-}" "${cf:-}"
  done < <(yq -r '.mods[] | [.name, .slug, (.mr // ""), (.cf // "")] | @tsv' "$MODS_YAML")
else
  # Fallback naive parser for constrained schema
  current_key=""; name=""; slug=""; mr=""; cf=""; have_record=0
  while IFS= read -r line || [[ -n "$line" ]]; do
    trimmed=${line#"${line%%[![:space:]]*}"}
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
    val=${val#"${val%%[![:space:]]*}"}
    val="${val#\"}"
    val="${val%\"}"
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
fi

echo "==> Refresh index"
$PW refresh

echo "==> Export Modrinth pack (.mrpack)"
set +e
$PW modrinth export --output "$MRPACK" --restrictDomains=false
export_exit=$?
set -e

if [[ $export_exit -ne 0 ]]; then
  echo "ERROR: packwiz export failed (exit $export_exit). See output above for details."
  if [[ -f "$MRPACK" ]]; then
    sz=$(stat -c%s "$MRPACK" 2>/dev/null || echo 0)
    echo "Note: current '$MRPACK' size=${sz} bytes"
  fi
  echo "Common causes:"
  echo " - CurseForge API/network errors (rate limiting or DNS)."
  echo " - Mods requiring manual download due to licensing."
  echo "Action: Re-run and review warnings above; set CURSEFORGE_API_KEY if applicable; or try again."
  exit $export_exit
fi

if [[ ! -s "$MRPACK" ]]; then
  echo "ERROR: '$MRPACK' is empty (0 bytes). Export did not complete successfully."
  echo "Check for licensing/manual download warnings or network/API errors above."
  exit 1
fi

echo
echo "==> Done."
echo "Import '$MRPACK' in PolyMC/Prism: Add Instance -> Import from zip (select the .mrpack)."
