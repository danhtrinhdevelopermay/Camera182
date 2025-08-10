#!/bin/bash

echo "🌐 Alternative Push Method - GitHub API"
echo "====================================="

TOKEN="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"
REPO_NAME="Camera181"
GITHUB_USER="danhtrinhdevelopermay"

# Test token first
echo "🔑 Testing GitHub token..."
curl -H "Authorization: token $TOKEN" https://api.github.com/user

# Check if repository exists
echo "📋 Checking repository status..."
REPO_CHECK=$(curl -s -H "Authorization: token $TOKEN" \
    "https://api.github.com/repos/$GITHUB_USER/$REPO_NAME" | grep "\"name\"")

if [[ -z "$REPO_CHECK" ]]; then
    echo "📁 Creating repository..."
    curl -H "Authorization: token $TOKEN" \
         -H "Content-Type: application/json" \
         -d "{\"name\":\"$REPO_NAME\",\"description\":\"Flutter iOS 18 Camera App\",\"private\":false}" \
         https://api.github.com/user/repos
    sleep 2
fi

# Initialize git with proper authentication
rm -rf .git
git init
git branch -M main
git config user.name "Camera181"
git config user.email "camera181@github.com"

# Use token in URL format that doesn't trigger password prompt
git remote add origin https://$TOKEN@github.com/$GITHUB_USER/$REPO_NAME.git

git add .
git commit -m "Flutter iOS 18 Camera App - API Method Push"

# Push without interactive prompts
echo "🚀 Pushing to GitHub..."
git push -u origin main --quiet

if [ $? -eq 0 ]; then
    echo "✅ SUCCESS! Repository pushed!"
    echo "🔗 https://github.com/$GITHUB_USER/$REPO_NAME"
else
    echo "❌ Push failed. Trying alternative method..."
    
    # Alternative: Use git credential fill
    echo "url=https://github.com/$GITHUB_USER/$REPO_NAME.git
username=$TOKEN
password=x-oauth-basic" | git credential approve
    
    git push -u origin main
fi