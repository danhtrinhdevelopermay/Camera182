#!/bin/bash

echo "🚀 FINAL PUSH SCRIPT - Camera181 Repository"
echo "============================================="

# Clean any git issues
rm -f .git/index.lock 2>/dev/null
rm -rf .git 2>/dev/null

# Initialize fresh git repository
echo "📁 Initializing git repository..."
git init
git branch -M main

# Configure git user
echo "👤 Setting up git configuration..."
git config user.name "Camera181 Developer"
git config user.email "developer@camera181.com"

# Add remote with new token
echo "🌐 Adding GitHub remote..."
git remote add origin https://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@github.com/danhtrinhdevelopermay/Camera181.git

# Stage all files
echo "📄 Adding all files..."
git add -A

# Check if there are files to commit
if git diff --staged --quiet; then
    echo "❌ No files to commit"
    exit 1
fi

# Create commit
echo "💾 Creating commit..."
git commit -m "Flutter iOS 18 Camera App
- Fixed Flutter SDK compatibility (3.0.0-4.0.0)
- Optimized GitHub Actions workflow
- Compatible package versions
- Ready for APK build automation"

# Attempt push
echo "🚀 Pushing to GitHub..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo "✅ SUCCESS! Repository pushed successfully!"
    echo "🔗 Repository URL: https://github.com/danhtrinhdevelopermay/Camera181"
    echo "🎯 GitHub Actions will now build APK automatically"
    echo "📱 Check Actions tab for APK download"
else
    echo "❌ PUSH FAILED!"
    echo "🔧 Try manual steps:"
    echo "1. Check token validity"
    echo "2. Verify repository exists"  
    echo "3. Check network connection"
fi