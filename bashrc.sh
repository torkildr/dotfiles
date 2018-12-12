#!/usr/bin/env bash

bashrc_files=(~/.bashrc ~/.profile ~/.bash_profile)
bashrc=

if [ -n "$BASHRC_D_SOURCED" ]; then
  echo "bashrc.d already activated"
  exit 0
fi

echo "activating bashrc.d"

for f in "${bashrc_files[@]}"
do
  if [ -f "$f" ]; then
    bashrc="$f"
    break
  fi
done

if [ -z "$bashrc" ]; then
  echo "unable to find any valid bashrc-file:"
  printf '%s\n' "${bashrc_files[@]}"
  echo
  exit 1
fi

echo "using bashrc: ${bashrc}"

cat << "EOF" >> $bashrc

# load .bashrc.d files
export BASHRC_D_SOURCED=true
for file in ~/.bashrc.d/*;
do
  source "$file"
done
EOF

