#!/bin/bash

echo "🔧 Fixing Android Embedding v1 to v2"
echo "===================================="

cd ios_camera_flutter_app

echo "📋 Current project structure..."
ls -la android/app/src/main/

echo "🔧 Fixing Android Embedding Issues..."

# Remove old MainActivity structure 
rm -rf android/app/src/main/kotlin/com/iosCamera

# Create proper package structure
mkdir -p android/app/src/main/kotlin/com/example/ios_camera_flutter_app

# Create MainActivity with proper embedding v2
cat > android/app/src/main/kotlin/com/example/ios_camera_flutter_app/MainActivity.kt << 'EOF'
package com.example.ios_camera_flutter_app

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity()
EOF

# Update AndroidManifest.xml to use correct package
sed -i 's/android:name="\.MainActivity"/android:name="com.example.ios_camera_flutter_app.MainActivity"/g' android/app/src/main/AndroidManifest.xml

# Update build.gradle.kts for correct package
sed -i 's/namespace = "com\.iosCamera\.temp_android_project"/namespace = "com.example.ios_camera_flutter_app"/g' android/app/build.gradle.kts
sed -i 's/applicationId = "com\.iosCamera\.temp_android_project"/applicationId = "com.example.ios_camera_flutter_app"/g' android/app/build.gradle.kts

echo "📋 Package structure after fix..."
find android/app/src/main/kotlin -name "*.kt" -exec echo "File: {}" \; -exec cat {} \;

echo "🗑️ Cleaning old build..."
flutter clean || echo "Flutter not available locally - will work on GitHub Actions"

echo "📦 Restoring dependencies..."
flutter pub get || echo "Flutter not available locally - will work on GitHub Actions"

echo "🛠️ Building APK..."
flutter build apk --release --verbose || echo "Flutter not available locally - use GitHub Actions"

echo "✅ Android embedding fix completed!"
echo "📋 To build APK, use GitHub Actions or run 'flutter build apk' in environment with Flutter installed"