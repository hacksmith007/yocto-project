#!/bin/bash

CONFIG_FILE="submodules.config"

if [[ ! -f $CONFIG_FILE ]]; then
  echo "❌ $CONFIG_FILE not found."
  exit 1
fi

echo "🔁 Checking out submodules..."

while read -r line; do
  if [[ $line == \[*] ]]; then
    path=$(echo "$line" | sed 's/\[//;s/\]//')
  elif [[ $line == branch* ]]; then
    branch=$(echo "$line" | cut -d'=' -f2 | xargs)
    echo "🌿 $path => branch: $branch"
    cd "$path" || { echo "❌ Failed to cd into $path"; exit 1; }
    git fetch origin
    git checkout "$branch"
    git pull origin "$branch"
    cd - > /dev/null
  elif [[ $line == tag* ]]; then
    tag=$(echo "$line" | cut -d'=' -f2 | xargs)
    echo "🏷️ $path => tag: $tag"
    cd "$path" || { echo "❌ Failed to cd into $path"; exit 1; }
    git fetch --tags
    git checkout "tags/$tag"
    cd - > /dev/null
  fi
done < "$CONFIG_FILE"

echo "✅ Done checking out all submodules!"