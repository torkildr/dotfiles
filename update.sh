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
# loads once per shell (guard var not exported). interactive shells defer to
# .zshrc, since /etc/zshrc runs after .zprofile and resets the prompt.
marker="# load .zshrc.d files (v2)"
install_loader() {
  local rc="$1" cond="$2"
  grep -qF "$marker" "$rc" 2>/dev/null && return
  if grep -qF '.zshrc.d/*' "$rc" 2>/dev/null; then
    echo "WARNING: old loader in $rc, remove it"
  fi
  cat << EOF >> "$rc"

$marker
if [[ -z "\${_zshrc_d_loaded:-}" ]]$cond; then
  _zshrc_d_loaded=1
  for file in ~/.zshrc.d/*(N); do
    source "\$file"
  done
fi
EOF
  echo "added loader to $rc"
}
install_loader "$HOME/.zprofile" ' && [[ ! -o interactive ]]'
install_loader "$HOME/.zshrc" ''

echo "==> updating submodules"
git submodule sync --quiet
# no --recursive: nested submodules are only upstream test deps
git submodule update --init --remote --jobs 8

echo "==> stowing configs"
# restow logs UNLINK + LINK per entry; unchanged ones end as "reverts previous action"
stow_log="$(stow -v -d "$dir" -t "$HOME" --restow configs 2>&1)" || { echo "$stow_log"; exit 1; }
n_unlink=$(grep -c '^UNLINK:' <<< "$stow_log" || true)
n_kept=$(grep -c '^LINK:.*reverts previous action' <<< "$stow_log" || true)
n_link=$(grep -c '^LINK:' <<< "$stow_log" || true)
echo "stow: $(( n_link - n_kept )) linked, $(( n_unlink - n_kept )) unlinked, $n_kept unchanged"

if [[ -n "$(git status --porcelain)" ]]; then
  echo "==> local changes"
  git status --short
fi

echo "done"
