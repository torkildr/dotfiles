#!/usr/bin/env zsh
#
# Pull, refresh submodules and (re)stow configs. Safe to re-run.
#
#   ./update.sh            full update
#   ./update.sh --no-pull  skip git pull (used internally after self-update)

set -euo pipefail

dir="${0:A:h}"
cd "$dir"

if [[ "${1:-}" != "--no-pull" ]]; then
  echo "==> pulling"
  git pull --ff-only
  # re-exec in case this script changed
  exec "$dir/update.sh" --no-pull
fi

echo "==> ensuring .zshrc.d loader in ~/.zprofile and ~/.zshrc"
# guard var is not exported: loads once per shell, whichever rc file runs first
marker="# load .zshrc.d files (guarded)"
for rc in "$HOME/.zprofile" "$HOME/.zshrc"; do
  grep -qF "$marker" "$rc" 2>/dev/null && continue
  if grep -qF '.zshrc.d/*' "$rc" 2>/dev/null; then
    echo "WARNING: unguarded loader in $rc, remove it to avoid double loading"
  fi
  cat << EOF >> "$rc"

$marker
if [[ -z "\${_zshrc_d_loaded:-}" ]]; then
  _zshrc_d_loaded=1
  for file in ~/.zshrc.d/*(N); do
    source "\$file"
  done
fi
EOF
  echo "added loader to $rc"
done

echo "==> updating submodules"
git submodule sync --recursive --quiet
git submodule update --init --recursive --remote --jobs 8

echo "==> stowing configs"
stow -d "$dir" -t "$HOME" --restow configs

if [[ -n "$(git status --porcelain)" ]]; then
  echo "==> local changes"
  git status --short
fi

echo "done"
