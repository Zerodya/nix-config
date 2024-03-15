#!/usr/bin/env bash

# Generate JSON dynamically using matugen command
json=$(matugen --dry-run image "$1" --json hex)

# Extract dark colors from the JSON
dark_colors=$(echo "$json" | jq -r '.colors.dark | to_entries | map("$" + .key + ": " + .value + ";") | join("\n")')

# Save dark colors to _colors.scss file
echo "/* dark */" > _colors.scss
echo "$dark_colors" >> _colors.scss
