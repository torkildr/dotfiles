#!/usr/bin/env zsh

zshrc="$HOME/.zshrc"

if [ -n "$ZSHRC_D_SOURCED" ]; then
  echo "zshrc.d already activated"
  exit 0
fi

echo "activating zshrc.d"
echo "using .zshrc: ${zshrc}"

cat << "EOF" >> $zshrc

# load .zshrc.d files
export ZSHRC_D_SOURCED=true
for file in ~/.zshrc.d/*;
do
  source "$file"
done
EOF

