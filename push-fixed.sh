#!/bin/bash

echo "=== Push to Camera181 Repository (Fixed Authentication) ==="

# Remove git lock if exists
rm -f .git/index.lock 2>/dev/null

# Check if git is initialized
if [ ! -d .git ]; then
    echo "Initializing git..."
    git init
    git branch -M main
fi

# Remove existing origin if any
git remote remove origin 2>/dev/null

# Set up git user
git config user.name "Camera181 Developer"
git config user.email "developer@camera181.com"

# Add all files
echo "Adding files..."
git add .

# Check if there are changes
if git diff --staged --quiet; then
    echo "No changes to commit"
    exit 0
fi

# Commit changes
echo "Committing changes..."
git commit -m "Flutter camera app - Clean build setup $(date '+%Y-%m-%d %H:%M:%S')"

echo ""
echo "========================================"
echo "MANUAL PUSH REQUIRED"
echo "========================================"
echo ""
echo "Your token may have expired. Please try these options:"
echo ""
echo "OPTION 1 - Use GitHub CLI (recommended):"
echo "gh auth login"
echo "gh repo create Camera181 --public"
echo "git remote add origin https://github.com/danhtrinhdevelopermay/Camera181.git"
echo "git push -u origin main"
echo ""
echo "OPTION 2 - Generate new token:"
echo "1. Go to: https://github.com/settings/tokens"
echo "2. Generate new token with 'repo' permissions"
echo "3. Use: git remote add origin https://NEW_TOKEN@github.com/danhtrinhdevelopermay/Camera181.git"
echo "4. Run: git push -u origin main"
echo ""
echo "OPTION 3 - Use SSH (if configured):"
echo "git remote add origin git@github.com:danhtrinhdevelopermay/Camera181.git"
echo "git push -u origin main"
echo ""
echo "Repository is ready to push!"