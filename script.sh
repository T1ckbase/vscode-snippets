#!/usr/bin/env bash
set -euo pipefail

if [ ! -d "vscode/extensions/" ]; then
  echo "Error: vscode/extensions/ directory not found"
  exit 1
fi

rm -rf snippets
mkdir -p snippets

find vscode/extensions -type f -name '*.code-snippets' -print0 |
while IFS= read -r -d '' file; do
  cp -- "$file" "snippets/$(basename "${file%.code-snippets}").json"
done

tmp_snippets=$(mktemp)
trap 'rm -f "$tmp_snippets"' EXIT

find vscode/extensions/ -type f -name "package.json" -print0 |
while IFS= read -r -d '' pkg; do
  snippets=$(jq -c '
    (.contributes.snippets? // [])
    | if type == "array" then . else [.] end
    | map(if .path then .path |= sub("\\.code-snippets$"; ".json") else . end)
    | .[]
  ' "$pkg")

  if [ -n "$snippets" ]; then
    echo "Processing: $pkg"
    printf '%s\n' "$snippets" >> "$tmp_snippets"
  fi
done

all_snippets=$(jq -s '.' "$tmp_snippets")

jq -n --argjson contributes "$all_snippets" '{
  "name": "vscode-snippets",
  "version": "0.0.0",
  "description": "Snippets extracted from Visual Studio Code",
  "contributes": {
    "snippets": $contributes
  }
}' | jq -S . > package.json

echo "Final snippets count: $(echo "$all_snippets" | jq length)"
echo "Generated: package.json"
