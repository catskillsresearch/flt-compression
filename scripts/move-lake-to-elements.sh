#!/usr/bin/env bash
# Move only the Lean/Lake build cache from CRC_FUSION_LAB to Elements.
# The git repo stays on ~/Desktop/flt-compression; only .lake moves.
#
# Usage:
#   ./scripts/move-lake-to-elements.sh              # interactive
#   ./scripts/move-lake-to-elements.sh --yes        # no prompts
#   ./scripts/move-lake-to-elements.sh --dry-run    # rsync plan only
#
# End state:
#   ~/Desktop/flt-compression/.lake -> /media/catskills/Elements/flt-compression/.lake

set -euo pipefail

REPO="${REPO:-/home/catskills/Desktop/flt-compression}"
LAKE_LINK="${LAKE_LINK:-$REPO/.lake}"
LAKE_SRC="${LAKE_SRC:-/media/catskills/CRC_FUSION_LAB/flt-compression/.lake}"
LAKE_DEST="${LAKE_DEST:-/media/catskills/Elements/flt-compression/.lake}"
ELEMENTS_MOUNT="${ELEMENTS_MOUNT:-/media/catskills/Elements}"
HOME_DIR="${HOME_DIR:-$HOME}"
LOG="${LOG:-$HOME/flt-lake-move-$(date +%Y%m%d-%H%M%S).log}"

DRY_RUN=0
ASSUME_YES=0

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --yes|-y) ASSUME_YES=1 ;;
    -h|--help)
      sed -n '1,18p' "$0"
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      exit 2
      ;;
  esac
done

RSYNC=(rsync -aH --partial --inplace --info=progress2,stats2,name)
if [[ "$DRY_RUN" -eq 1 ]]; then
  RSYNC+=(--dry-run)
fi

log() {
  printf '[%s] %s\n' "$(date '+%F %T')" "$*" | tee -a "$LOG"
}

confirm() {
  if [[ "$ASSUME_YES" -eq 1 || "$DRY_RUN" -eq 1 ]]; then
    return 0
  fi
  local prompt=$1
  read -r -p "$prompt [y/N] " reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

require_mounted() {
  if ! mountpoint -q "$ELEMENTS_MOUNT"; then
    log "ERROR: $ELEMENTS_MOUNT is not mounted."
    exit 1
  fi
}

resolve_lake_src() {
  if [[ -L "$LAKE_LINK" ]]; then
    LAKE_SRC="$(readlink -f "$LAKE_LINK")"
    log "Current .lake symlink -> $LAKE_SRC"
  elif [[ -d "$LAKE_LINK" && ! -L "$LAKE_LINK" ]]; then
    LAKE_SRC="$LAKE_LINK"
    log ".lake is a real directory in the repo -> $LAKE_SRC"
  elif [[ -d "$LAKE_SRC" ]]; then
    log "Using default LAKE_SRC=$LAKE_SRC"
  else
    log "ERROR: cannot find .lake source (link or $LAKE_SRC)."
    exit 1
  fi

  if [[ "$LAKE_SRC" == "$LAKE_DEST" || "$(readlink -f "$LAKE_SRC" 2>/dev/null || true)" == "$(readlink -f "$LAKE_DEST" 2>/dev/null || true)" ]]; then
    log "Already on Elements; nothing to do."
    exit 0
  fi
}

stop_builds() {
  log "Stopping lake/lean for flt-compression..."
  if pgrep -f "$REPO" >/dev/null 2>&1; then
    pkill -f "$REPO" || true
    sleep 2
    if pgrep -f "$REPO" >/dev/null 2>&1; then
      log "ERROR: flt-compression build still running."
      pgrep -af "$REPO" | tee -a "$LOG"
      exit 1
    fi
  fi
  log "No active build processes."
}

check_space() {
  local need avail
  need=$(du -sb "$LAKE_SRC" | awk '{print $1}')
  avail=$(df -B1 --output=avail "$ELEMENTS_MOUNT" | tail -1 | tr -d ' ')
  log "Lake size:   $(du -sh "$LAKE_SRC" | awk '{print $1}') ($need bytes)"
  log "Elements free: $(df -h "$ELEMENTS_MOUNT" | awk 'NR==2 {print $4}') ($avail bytes)"
  if [[ "$DRY_RUN" -eq 0 && "$need" -gt "$avail" ]]; then
    log "ERROR: not enough space on Elements."
    exit 1
  fi
}

copy_lake() {
  log "=== Copy .lake to Elements ==="
  log "  from: $LAKE_SRC/"
  log "  to:   $LAKE_DEST/"
  mkdir -p "$(dirname "$LAKE_DEST")"
  mkdir -p "$LAKE_DEST"
  "${RSYNC[@]}" "$LAKE_SRC/" "$LAKE_DEST/" 2>&1 | tee -a "$LOG"
}

verify_lake() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "Dry run; skipping verification."
    return 0
  fi
  local src dest
  src=$(du -sb "$LAKE_SRC" | awk '{print $1}')
  dest=$(du -sb "$LAKE_DEST" | awk '{print $1}')
  log "Verify .lake bytes: src=$src dest=$dest"
  if (( dest * 100 < src * 99 )); then
    log "ERROR: destination .lake looks incomplete (<99% of source)."
    exit 1
  fi
  if [[ ! -d "$LAKE_DEST/build" ]]; then
    log "ERROR: $LAKE_DEST/build missing after copy."
    exit 1
  fi
  log "Copy verification passed."
}

update_symlinks() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "Would update: $LAKE_LINK -> $LAKE_DEST"
    return 0
  fi

  log "=== Update symlinks ==="

  if [[ -L "$LAKE_LINK" ]]; then
    log "  remove old link: $LAKE_LINK -> $(readlink "$LAKE_LINK")"
    rm "$LAKE_LINK"
  elif [[ -d "$LAKE_LINK" ]]; then
    log "ERROR: $LAKE_LINK is a real directory; not replacing automatically."
    exit 1
  fi

  ln -sfn "$LAKE_DEST" "$LAKE_LINK"
  log "  new link: $LAKE_LINK -> $(readlink "$LAKE_LINK")"

  # Fix any other symlinks under ~ that still point at the old CRC path.
  local old_path="/media/catskills/CRC_FUSION_LAB/flt-compression/.lake"
  local fixed=0
  while IFS= read -r link; do
    [[ "$link" == "$LAKE_LINK" ]] && continue
    log "  fix stale symlink: $link -> $old_path"
    ln -sfn "$LAKE_DEST" "$link"
    fixed=$((fixed + 1))
  done < <(find "$HOME_DIR" -maxdepth 6 -type l -lname "*CRC_FUSION_LAB/flt-compression/.lake" 2>/dev/null || true)

  if [[ "$fixed" -eq 0 ]]; then
    log "  no other stale .lake symlinks under $HOME_DIR"
  fi
}

offer_cleanup() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    return 0
  fi
  log ""
  log "Old cache still on CRC_FUSION_LAB: $LAKE_SRC"
  log "Reclaim ~398 GB after you confirm builds work:"
  log "  rm -rf /media/catskills/CRC_FUSION_LAB/flt-compression"
  log ""
  log "Resume build:"
  log "  cd $REPO"
  log "  export LEAN_NUM_THREADS=4"
  log "  lake build"
}

main() {
  log "=== Move flt-compression .lake to Elements ==="
  log "Log: $LOG"

  require_mounted
  [[ -d "$REPO" ]] || { log "ERROR: repo not found: $REPO"; exit 1; }
  resolve_lake_src
  stop_builds
  check_space

  if [[ -e "$LAKE_DEST" && "$DRY_RUN" -eq 0 ]]; then
    confirm "Destination $LAKE_DEST exists; rsync will merge into it. Continue?" || exit 1
  fi
  confirm "Copy .lake from CRC_FUSION_LAB to Elements?" || exit 1

  copy_lake
  verify_lake
  update_symlinks
  offer_cleanup

  log "=== Done ==="
}

main "$@"
