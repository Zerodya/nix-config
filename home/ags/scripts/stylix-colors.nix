{ pkgs, lib, ... }:

let
  generateColorsScript = pkgs.writeScriptBin "generate-colors" ''
    #!/usr/bin/env bash

    GENERATED_JSON_PATH="$HOME/.config/stylix/generated.json"
    COLOR_SCSS_PATH="$HOME/.config/stylix/_colors.scss"
    FALLBACK_COLOR_SCSS_PATH="$HOME/.config/stylix/default_colors.scss"

    # Check if generated.json exists
    if [ -f "$GENERATED_JSON_PATH" ]; then
        # Read colors from the JSON file using jq
        background=$(jq -r '.base00' "$GENERATED_JSON_PATH")
        foreground=$(jq -r '.base05' "$GENERATED_JSON_PATH")
        background_alt=$(jq -r '.base01' "$GENERATED_JSON_PATH")
        background_light=$(jq -r '.base02' "$GENERATED_JSON_PATH")
        foreground_alt=$(jq -r '.base03' "$GENERATED_JSON_PATH")
        red=$(jq -r '.base08' "$GENERATED_JSON_PATH")
        green=$(jq -r '.base0B' "$GENERATED_JSON_PATH")
        yellow=$(jq -r '.base0A' "$GENERATED_JSON_PATH")
        blue=$(jq -r '.base0D' "$GENERATED_JSON_PATH")
        cyan=$(jq -r '.base0C' "$GENERATED_JSON_PATH")
        magenta=$(jq -r '.base0E' "$GENERATED_JSON_PATH")
        comment=$(jq -r '.base03' "$GENERATED_JSON_PATH")
        accent=$(jq -r '.base08' "$GENERATED_JSON_PATH")

        # Generate the _color.scss file
        cat <<EOL > "$COLOR_SCSS_PATH"
    /* Generated from Stylix Base16 colors */
    \$background: #$background;
    \$foreground: #$foreground;
    \$background-alt: #$background_alt;
    \$background-light: #$background_light;
    \$foreground-alt: #$foreground_alt;
    \$red: #$red;
    \$red-light: #$red;
    \$green: #$green;
    \$green-light: #$green;
    \$yellow: #$yellow;
    \$yellow-light: #$yellow;
    \$blue: #$blue;
    \$blue-light: #$blue;
    \$cyan: #$cyan;
    \$cyan-light: #$cyan;
    \$magenta: #$magenta;
    \$magenta-light: #$magenta;
    \$comment: #$comment;
    \$accent: #$accent;
    EOL

        echo "_colors.scss file updated with Base16 colors from generated.json."
    else
        # Fallback to default _colors.scss
        if [ -f "$FALLBACK_COLOR_SCSS_PATH" ]; then
            cp "$FALLBACK_COLOR_SCSS_PATH" "$COLOR_SCSS_PATH"
            echo "_colors.scss file copied from fallback default_colors.scss."
        else
            echo "Fallback default_colors.scss file not found in the current directory."
            exit 1
        fi
    fi
  '';
in
{
  home.activation.generateColors = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${generateColorsScript}
  '';
}
