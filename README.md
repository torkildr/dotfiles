Dotfiles
--------

## Usage

```
./update.sh
```

Pulls, refreshes submodules to their remote branches, ensures the `.zshrc.d`
loader is in `~/.zprofile`, and restows `configs` into `$HOME`. Idempotent.
Everything assumes a `zsh` shell.

## zshrc.d

Files in `~/.zshrc.d` are sourced in glob order, once per shell: from `~/.zshrc`
for interactive shells, from `~/.zprofile` for non-interactive login shells
(`zsh -lc`). Interactive shells skip `.zprofile` because `/etc/zshrc` runs after
it and resets the prompt. Files needing an interactive shell should guard themselves:

```zsh
[[ -o interactive ]] || return
```

The loader (`.zprofile` adds `&& [[ ! -o interactive ]]`):
```zsh
# load .zshrc.d files (v2)
if [[ -z "${_zshrc_d_loaded:-}" ]]; then
  _zshrc_d_loaded=1
  for file in ~/.zshrc.d/*(N); do
    source "$file"
  done
fi
```
