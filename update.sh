#!/usr/bin/env zsh

set -e

echo "checking .zshrd.c activation"
./zshrc.sh

git submodule update --init --recursive --remote

stow_modules=($(echo */ | sed 's/\///g'))

while true
do
  echo "------------"
  echo "stow module:"

  # list modules
  i=1
  for module in "${stow_modules[@]}"
  do
    echo "${i}) ${module}"
    let "i++"
  done
  echo "q) quit"

  echo
  read n

  if [[ "$n" == "" || $n == "q" ]]; then
    echo "All done"
    exit 0
  fi

  choice="${stow_modules[n]}"
  echo "stowing \"${choice}\""
  echo
  stow "$choice"

done

