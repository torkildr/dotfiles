Dotfiles
--------

## Usage

Should be put in place with GNU `stow` for each module, eg.

```
stow spacevim
```

## bashrc.d

Some of the modules uses its own system to load partial `.bashrc` scripts.

The supplied `bashrc.sh` script will add `bashrc.d` loading to your `.bashrc`-file
(it will look for, in order: `.bashrc`, `.profile` or `.bash_profile`).

Files in the `.bashrc.d` directory will then be loaded in search order, from across
the different modules.

```
.bashrc.d/
├── 20-mac -> ../dotfiles/mac/.bashrc.d/20-mac
└── 99-gitprompt -> ../dotfiles/gitprompt/.bashrc.d/99-gitprompt
```

This makes it possible and easy to make partial bashrc-scripts that only
include the module-specific parts. This system will also make sure that you can,
in a deterministic manner, load scripts that are dependent on each other.

