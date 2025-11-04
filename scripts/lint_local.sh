#!/bin/bash
echo "Usage: lint_local.sh -lint-all [true or false] [path]"
LINTER_ENV_FILE="$HOME/cougars/scripts/super_linter.env"
VALIDATE_VAL="${2:-false}"
LINT_DIRECTORY="${3:-"$HOME/cougars"}"
touch "$LINTER_ENV_FILE"
# If the variable exists, replace it; otherwise, append it
if [[ "${1:-}" == "-lint-all" ]]; then
    if grep -q "^VALIDATE_ALL_CODEBASE=" "$LINTER_ENV_FILE"; then
        sed -i "s/^VALIDATE_ALL_CODEBASE=.*/VALIDATE_ALL_CODEBASE=$VALIDATE_VAL/" "$LINTER_ENV_FILE"
    else
        echo "VALIDATE_ALL_CODEBASE=$VALIDATE_VAL" >> "$LINTER_ENV_FILE"
    fi
fi
cd $LINT_DIRECTORY
docker run --rm     -e RUN_LOCAL=true     --env-file "$LINTER_ENV_FILE"     -v $(pwd):/tmp/lint     ghcr.io/super-linter/super-linter:latest