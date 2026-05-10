#!/bin/bash
# Script to copy generated AI assets from the brain folder into the game's assets folder
SRC_DIR="/home/samue/.gemini/antigravity/brain/f83cc780-d3c2-4b36-ab53-cfcf672e5de0"
DEST_DIR="$(dirname "$0")/assets"

mkdir -p "$DEST_DIR"

# Define the assets we want to copy
declare -A ASSETS=(
  ["bg_shire_"]="bg_shire.png"
  ["bg_forest_"]="bg_forest.png"
  ["bg_weathertop_"]="bg_weathertop.png"
  ["bg_moria_"]="bg_moria.png"
  ["bg_lothlorien_"]="bg_lothlorien.png"
  ["bg_pelennor_"]="bg_pelennor.png"
  ["bg_mountdoom_"]="bg_mountdoom.png"
  ["fantasy_gate_"]="fantasy_gate.png"
  ["rune_stone_"]="rune_stone.png"
  ["lore_book_"]="lore_book.png"
)

echo "Copying AI assets to $DEST_DIR..."

for PREFIX in "${!ASSETS[@]}"; do
    # Find the matching file in the source directory
    # We use ls -t to get the latest one if there are multiple
    FILE=$(ls -t "$SRC_DIR"/"$PREFIX"*.png 2>/dev/null | head -n 1)
    
    if [ -f "$FILE" ]; then
        cp "$FILE" "$DEST_DIR/${ASSETS[$PREFIX]}"
        echo "✓ Copied $(basename "$FILE") -> assets/${ASSETS[$PREFIX]}"
    else
        echo "✗ Error: Could not find file for $PREFIX in $SRC_DIR"
    fi
done

echo "Success! Your high-fidelity AI assets are now ready."
