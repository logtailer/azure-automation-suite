#!/bin/bash
set -euo pipefail
for dir in terraform/*/; do
  if [ -f "$dir/variables.tf" ]; then
    echo "Generating docs for $dir..."
    terraform-docs markdown table --output-file README.md "$dir" 2>/dev/null || true
  fi
done
echo "Done."
