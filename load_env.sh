#!/bin/bash

# Define the path to your .env file
ENV_FILE=".env"

# Check if the .env file exists
if [ ! -f "$ENV_FILE" ]; then
  echo "Error: $ENV_FILE not found!"
  exit 1
fi

echo "Loading environment variables from $ENV_FILE (robustly)..."

# Read each line, filter comments and empty lines, then export
# Using grep to filter comments and empty lines, and xargs to export
# This method works well for simple KEY=VALUE pairs without complex quoting rules
# or embedded special characters that need more careful handling.
grep -v '^#' "$ENV_FILE" | grep -v '^$' | while IFS='=' read -r key value; do
  if [[ -n "$key" ]]; then # Ensure key is not empty
    # Trim whitespace from key and value (optional, but good practice)
    # Bash parameter expansion can remove leading/trailing spaces
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs)

    # Remove quotes from value if present (e.g., "my value" -> my value)
    # This is important if you define values like API_KEY="abc"
    value="${value%\"}" # Remove trailing "
    value="${value#\"}" # Remove leading "

    set +H
    export "$key=$value"
    set -H
    echo "Exported $key=$value"
  fi
done

echo "Environment variables loaded."

# Example usage:
# echo "The database host is: $DATABASE_HOST"
# echo "The API key is: $API_KEY"ause
