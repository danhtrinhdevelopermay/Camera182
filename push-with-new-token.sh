#!/bin/bash

echo "=== Pushing Camera181 with New Token ==="

# Clean up any git locks
rm -f .git/index.lock 2>/dev/null

# Initialize git if needed
if [ ! -d .git ]; then
    git init
    git branch -M main
fi

# Remove existing remote
git remote remove origin 2>/dev/null

# Configure git
git config user.name "Camera181 Developer"
git config user.email "developer@camera181.com"

# Add remote with new token
git remote add origin https://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@github.com/danhtrinhdevelopermay/Camera181.git

# Add files
git add .

# Commit
git commit -m "Flutter iOS 18 Camera App - APK Build Ready $(date '+%Y-%m-%d %H:%M:%S')"

# Push
echo "Pushing to GitHub..."
git push -u origin main

echo "=== Push completed! ==="
echo "Repository: https://github.com/danhtrinhdevelopermay/Camera181"
echo "GitHub Actions will automatically build APK when code is pushed."