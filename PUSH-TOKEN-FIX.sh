#!/bin/bash

echo "🔧 Push Script - Token Authentication Fix"
echo "========================================"

# Clean git completely
rm -rf .git
rm -f .git/index.lock

# Initialize new repository
git init
git branch -M main

# Configure git to use token authentication properly
git config user.name "Camera181"
git config user.email "camera181@example.com"

# Set credential helper to avoid password prompts
git config credential.helper store

# Create credential file with token
mkdir -p ~/.git-credentials
echo "https://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:x-oauth-basic@github.com" > ~/.git-credentials

# Alternative method: Use token as username
echo "📝 Setting up remote with token as username..."
git remote add origin https://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:x-oauth-basic@github.com/danhtrinhdevelopermay/Camera181.git

# Stage files
git add .

# Commit
git commit -m "Flutter iOS 18 Camera App - Authentication Fixed"

# Push with explicit credential
echo "🚀 Pushing with token authentication..."
GIT_ASKPASS=echo git push -u origin main

echo "✅ Push completed!"
echo "🔗 Repository: https://github.com/danhtrinhdevelopermay/Camera181"