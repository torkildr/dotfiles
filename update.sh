#!/usr/bin/env bash

set -e

#git submodule init
#git pull --recurse-submodules

modules=($(echo */ | sed 's/\///g'))

while true
do
  echo "------------"
  echo "stow module:"

  # list modules
  i=1
  for module in "${modules[@]}"
  do
    echo "${i}) ${module}"
    let "i++"
  done
  echo "q) quit"

  echo
  read n

  if [ -z "$n" -o "$n" == "q" ]; then
    echo "All done"
    exit 0
  fi

  choice="${modules[n-1]}"
  echo "stowing \"${choice}\""
  echo
  stow "$choice"

done

