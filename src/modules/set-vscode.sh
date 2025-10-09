#!/bin/bash

#DEPENDENCY=jq

# Path to the extensions.json file
EXTENSIONS_FILE="$HOME/.vscode/extensions/extensions.json"

# Check if extensions.json exists
if [[ ! -f $EXTENSIONS_FILE ]]; then
  echo "Error: $EXTENSIONS_FILE not found. Please place it in the current directory."
  exit 1
fi

# Extract extension IDs from the JSON file
echo "Extracting extension IDs from $EXTENSIONS_FILE..."
EXTENSIONS=$(jq -r '.[].identifier.id' "$EXTENSIONS_FILE")

# Check if jq is installed
if ! command -v jq &>/dev/null; then
  echo "Error: jq is not installed. Please install it to parse JSON files."
  exit 1
fi

# Install each extension
echo "Installing extensions..."
for EXTENSION in $EXTENSIONS; do
  echo "Installing $EXTENSION..."
  code --install-extension "$EXTENSION"
done

echo "All extensions have been installed!"
