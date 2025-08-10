#!/bin/bash

echo "📦 Creating Camera181 Project Package"
echo "===================================="

# Create clean directory for packaging
rm -rf Camera181-Package
mkdir Camera181-Package

# Copy important files and directories
echo "📁 Copying Flutter project..."
cp -r ios_camera_flutter_app/ Camera181-Package/

echo "📁 Copying GitHub Actions..."
cp -r .github/ Camera181-Package/

echo "📄 Copying documentation..."
cp README.md Camera181-Package/
cp replit.md Camera181-Package/
cp SIMPLE-UPLOAD-GUIDE.md Camera181-Package/

echo "📸 Copying screenshots..."
cp -r attached_assets/ Camera181-Package/ 2>/dev/null || echo "No attached_assets found"

echo "🧹 Copying configuration files..."
cp .gitignore Camera181-Package/ 2>/dev/null || echo "No .gitignore found"

# Create zip package
echo "📦 Creating ZIP package..."
zip -r Camera181-Package.zip Camera181-Package/ -x "*.DS_Store" "*/.git/*" "*/node_modules/*" "*/build/*"

echo "✅ Package created successfully!"
echo "📦 File: Camera181-Package.zip"
echo "📏 Size: $(du -h Camera181-Package.zip | cut -f1)"
echo ""
echo "🚀 Next steps:"
echo "1. Download Camera181-Package.zip to your computer"
echo "2. Go to https://github.com/danhtrinhdevelopermay"
echo "3. Create new repository 'Camera181'"
echo "4. Upload the ZIP contents or drag & drop files"
echo "5. GitHub Actions will build APK automatically"

# List package contents
echo ""
echo "📋 Package contents:"
unzip -l Camera181-Package.zip | head -20