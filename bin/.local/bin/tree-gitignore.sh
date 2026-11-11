#!/bin/bash
set -euo pipefail

# Check if cloc is installed
if ! command -v cloc &> /dev/null; then
    echo "Error: 'cloc' is not installed (sudo pacman -S cloc)."
    exit 1
fi

# Tree logic (excludes files based on .gitignore)
if [ -f .gitignore ]; then
    IGNORE=$(printf ".git\n%s" "$(grep -vE '^\s*#|^\s*$' .gitignore)" | sed 's:/$::' | tr '\n' '|' | sed 's/|$//')
else
    IGNORE=".git"
fi

# Print tree
tree -a -I "$IGNORE" --dirsfirst

echo ""

# Run cloc silently (removes the banner/speed info)
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    cloc . --vcs=git --quiet
else
    cloc . --exclude-dir=.git --quiet
fi
