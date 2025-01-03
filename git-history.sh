#!/bin/zsh
# Script to simulate incremental git history for an existing project
# Usage: Run from the project root

set -e

# Step 1: Initialize git repo
if [ ! -d .git ]; then
    git init
fi

# Step 2: Create a temp directory to hold files
TMPDIR=".git-history-tmp"
mkdir -p "$TMPDIR"

# Step 3: Move all files except .git and the script itself to TMPDIR
for f in * .*; do
    if [[ "$f" != ".git" && "$f" != "." && "$f" != ".." && "$f" != "$0" ]]; then
        mv "$f" "$TMPDIR/" 2>/dev/null || true
    fi
done

# Step 4: Add files back in logical stages
# You can customize the stages below

# Stage 1: README and docs
mv "$TMPDIR/README.md" . 2>/dev/null || true
mv "$TMPDIR/docs" . 2>/dev/null || true
mv "$TMPDIR/resource-groups.md" . 2>/dev/null || true
git add README.md docs resource-groups.md 2>/dev/null || true
git commit -m "Add README and documentation"

# Stage 2: Terraform foundation
mv "$TMPDIR/terraform" . 2>/dev/null || true
git add terraform 2>/dev/null || true
git commit -m "Add Terraform modules and configuration"

# Stage 3: Applications
mv "$TMPDIR/applications" . 2>/dev/null || true
git add applications 2>/dev/null || true
git commit -m "Add application code (FastAPI, React, microservices)"

# Stage 4: Scripts
mv "$TMPDIR/scripts" . 2>/dev/null || true
git add scripts 2>/dev/null || true
git commit -m "Add deployment and cleanup scripts"

# Stage 5: Miscellaneous
mv "$TMPDIR/key.pem" . 2>/dev/null || true
git add key.pem 2>/dev/null || true
git commit -m "Add key file"

# Cleanup
rm -rf "$TMPDIR"

echo "Incremental git history created."
