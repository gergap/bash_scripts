#!/bin/bash

# text files without extension
FILENAMES="CHANGES COPYING INSTALL README LICENSE Makefile Doxyfile"

find . -path './.git' -prune -o -type f -iregex ".*\.\(txt\|ini\|c\|cpp\|h\|cnf\|manifest\|bat\|pro\|pri\|shilka\|ui\|xml\|xsd\|tt2\|tt2pro\|vcproj\|sln\|htm\|html\|mak\|ts\|rc\|sh\|py\)$" -exec dos2unix {} \; 

for filename in $FILENAMES; do
  find . -path './.git' -prune -o -type f -iname $filename -exec dos2unix {} \;
done

exit 0

git filter-branch --tree-filter 'find . -path './.git' -prune -o -type f -exec dos2unix \{} \;' HEAD

