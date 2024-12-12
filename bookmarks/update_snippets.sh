#!/bin/bash

# Define the URL for the bookmarks file on GitHub
URL="https://raw.githubusercontent.com/krisyotam/voidrice/master/bookmarks/bookmarks"

# Define the path to the snippets file
SNIPPETS_FILE="$HOME/.local/share/larbs/snippets"

# Temp file to hold the downloaded content
TEMP_FILE=$(mktemp)

# Download the file from the URL
echo "Downloading the bookmarks file from GitHub..."
curl -s -L "$URL" -o "$TEMP_FILE"

# Check if the snippets file exists and create it if it doesn't
if [ ! -f "$SNIPPETS_FILE" ]; then
    echo "Snippets file does not exist. Creating it now..."
    touch "$SNIPPETS_FILE"
fi

# Compare the content of the snippets file and the downloaded file
NEW_CONTENT=$(diff "$SNIPPETS_FILE" "$TEMP_FILE")

# If there is new content to add
if [ -n "$NEW_CONTENT" ]; then
    echo "New content detected. Appending to snippets file..."
    cat "$TEMP_FILE" >> "$SNIPPETS_FILE"
    echo "Content appended to the snippets file."
else
    echo "No new changes detected. Nothing was added."
fi

# Clean up temporary file
rm "$TEMP_FILE"
