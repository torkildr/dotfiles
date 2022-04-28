Dotfiles
--------

## Usage

It should mostly be enough to run the `update.sh` script on changes. Everything assumes a `zsh` shell.

## zshrc.d

The supplied `zshrc.sh` script will add `.zshrc.d` loading to your `.zshrc`-file.

Files in the `.zshrc.d` directory will then be loaded in search order, from across
the different modules.

```
.zshrc.d/
├── 10-foo -> ../dotfiles/a/.zshrc.d/10-foo
└── 99-bar -> ../dotfiles/b/.zshrc.d/99-bar
```

This makes it possible and easy to make partial zshrc-scripts that only
include the module-specific parts. This system will also make sure that you can,
in a deterministic manner, load scripts that are dependent on each other.

The crux of the loading is very simple
```bash
for file in ~/.zshrc.d/*;
do
  source "$file"
done
```

