#!/bin/bash

# 🚀 PUSH TO CAMERA181 REPOSITORY - Automated Script

echo "📤 Pushing iOS 18 Camera App to GitHub Repository: Camera181/Camera181"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Step 1: Initializing Git Repository...${NC}"
git init

echo -e "${BLUE}Step 2: Adding remote repository...${NC}"
git remote add origin https://github.com/Camera181/Camera181.git 2>/dev/null || {
    echo -e "${YELLOW}Remote already exists, updating URL...${NC}"
    git remote set-url origin https://github.com/Camera181/Camera181.git
}

echo -e "${BLUE}Step 3: Adding all files...${NC}"
git add .

echo -e "${BLUE}Step 4: Creating commit...${NC}"
git commit -m "iOS 18 Camera App - Flutter Android APK với 4 build workflows

✅ Features:
- Complete iOS 18 camera interface với blur effects
- Flutter native Android app
- 4 GitHub Actions workflows cho APK build
- Android embedding v2 fix
- Camera permissions configured
- Local build tested successfully

🚀 Workflows included:
- build-android.yml (auto-trigger)
- build-simple-apk.yml (auto-trigger)  
- build-final-fix.yml (auto-trigger)
- bypass-embedding-build.yml (manual trigger)

📱 Ready to build APK on GitHub Actions!"

echo -e "${BLUE}Step 5: Pushing to GitHub...${NC}"

# Method 1: Try standard push
echo -e "${YELLOW}Attempting standard push...${NC}"
if git push -u origin main; then
    echo -e "${GREEN}✅ Push successful!${NC}"
    echo -e "${GREEN}Repository updated: https://github.com/Camera181/Camera181${NC}"
    echo -e "${GREEN}Check GitHub Actions for APK builds!${NC}"
else
    echo -e "${YELLOW}Standard push failed, trying with token authentication...${NC}"
    
    # Method 2: Use token authentication
    if [ -n "$GITHUB_TOKEN" ]; then
        echo -e "${YELLOW}Using GitHub token for authentication...${NC}"
        git remote set-url origin https://Camera181:${GITHUB_TOKEN}@github.com/Camera181/Camera181.git
        
        if git push -u origin main; then
            echo -e "${GREEN}✅ Push successful with token authentication!${NC}"
            echo -e "${GREEN}Repository updated: https://github.com/Camera181/Camera181${NC}"
            echo -e "${GREEN}Check GitHub Actions for APK builds!${NC}"
        else
            echo -e "${RED}❌ Push failed with token. Check repository permissions.${NC}"
            echo -e "${YELLOW}Manual steps:${NC}"
            echo -e "1. Go to https://github.com/Camera181/Camera181"
            echo -e "2. Create repository if it doesn't exist"
            echo -e "3. Run: git push -u origin main"
            exit 1
        fi
    else
        echo -e "${RED}❌ No GitHub token found. Please provide authentication.${NC}"
        echo -e "${YELLOW}Try running: git push -u origin main${NC}"
        echo -e "${YELLOW}And provide your GitHub username and personal access token${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}🎉 PUSH COMPLETED SUCCESSFULLY!${NC}"
echo -e "${BLUE}Next steps:${NC}"
echo -e "1. Visit: https://github.com/Camera181/Camera181"
echo -e "2. Go to 'Actions' tab to see workflow builds"
echo -e "3. Download APK from workflow artifacts when ready"
echo -e "4. For manual trigger: Select 'BYPASS EMBEDDING - Direct APK Build' and click 'Run workflow'"