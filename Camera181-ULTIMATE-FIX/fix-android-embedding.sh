#!/bin/bash

echo "🔧 Fixing Android Embedding v1 to v2"
echo "===================================="

cd ios_camera_flutter_app

echo "📋 Current project structure..."
ls -la android/app/src/main/

echo "🗑️ Cleaning old build..."
flutter clean

echo "🔄 Recreating Android project with v2 embedding..."
# This will regenerate Android project with proper v2 embedding
flutter create --org com.iosCamera --project-name ios_camera_flutter_app --platforms android .

echo "📦 Restoring dependencies..."
flutter pub get

echo "🛠️ Building APK..."
flutter build apk --release --verbose

if [ $? -eq 0 ]; then
    echo "✅ APK built successfully!"
    echo "📍 Location: build/app/outputs/flutter-apk/app-release.apk"
    ls -la build/app/outputs/flutter-apk/
else
    echo "❌ APK build failed"
    echo "🔍 Checking flutter doctor..."
    flutter doctor -v
fi