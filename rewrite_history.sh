#!/bin/bash
# Rewrite git history and fix all CRLF.
# This is useful when importing old projects (SVN) with bad style.

git filter-branch --tree-filter 'bash ~/bash_scripts/fixcrlf.sh' HEAD

exit 0
git filter-branch --tree-filter 'find . -path "./.git" -prune -o \( -name "*.cpp" -o -name "*.h" -o -name "*.rc" \)
-type f -exec dos2unix \{} \;' HEAD

