#!/bin/sh

for file in $*; do
  # replace tabs with 4 spaces
  cat "$file" | sed -e "s/\t/    /g" > tmp
  # add missing CR at end of file
  cat tmp | sed -e "$ s/\(.\)$/\\1\\n/" > "$file"
done
