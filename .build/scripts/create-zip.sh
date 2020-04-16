#! /usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXERCISE_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

{
  cd "$EXERCISE_DIR"

  rm -rf "$EXERCISE_DIR/exercises.zip"

  find . -type f \( -not -path '*/.*' \) -and \( -not -path '*/node_modules/*' \) -print | zip "$EXERCISE_DIR/exercises.zip" -@
}

