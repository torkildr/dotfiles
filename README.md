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

Files in `~/.zshrc.d` are sourced in glob order, once per shell, from whichever of
`~/.zprofile` (login) or `~/.zshrc` (interactive) runs first. Files needing an
interactive shell should guard themselves:

```zsh
[[ -o interactive ]] || return
```

The loader:
```zsh
# load .zshrc.d files (guarded)
if [[ -z "${_zshrc_d_loaded:-}" ]]; then
  _zshrc_d_loaded=1
  for file in ~/.zshrc.d/*(N); do
    source "$file"
  done
fi
```
