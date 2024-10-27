#!/bin/bash

# File: tree-md.sh
# Purpose: Generate a tree structure in Markdown format for the directory, ignoring .gitignore entries

# Base directory
DIR=${1:-$(pwd)}

# Read .gitignore patterns and convert them to a format compatible with `tree`
if [ -f "$DIR/.gitignore" ]; then
    IGNORES=$(sed '/^#/d;/^$/d' "$DIR/.gitignore" | sed ':a;N;$!ba;s/\n/,/g')
else
    IGNORES=""
fi

# Generate tree structure while excluding .gitignore patterns
tree=$(tree -tf --noreport -I "$IGNORES" --charset ascii "$DIR" |
       sed -e 's/| \+/  /g' -e 's/[|`]-\+/ */g' -e 's:\(* \)\(\(.*/\)\([^/]\+\)\):\1[\4](\2):g')

# Output the result to README.md file in the specified format
printf "# Project tree\n\n${tree}" > "$DIR/README.md"
