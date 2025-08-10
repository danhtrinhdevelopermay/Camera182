#!/bin/bash

# Thiết lập environment variables
export JAVA_HOME=/nix/store/$(ls /nix/store | grep openjdk-21 | head -1)
export ANDROID_HOME=/home/runner/workspace/android-sdk  
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# Chuyển vào thư mục dự án
cd /home/runner/workspace/ios_camera_flutter_app

echo "🚀 Bắt đầu build APK..."
echo "JAVA_HOME: $JAVA_HOME"
echo "ANDROID_HOME: $ANDROID_HOME"

# Kiểm tra Android SDK
if [ ! -d "$ANDROID_HOME" ]; then
    echo "❌ Android SDK không tìm thấy tại $ANDROID_HOME"
    exit 1
fi

# Clean build cache
echo "🧹 Cleaning build cache..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build APK debug
echo "📱 Building debug APK..."
flutter build apk --debug --no-tree-shake-icons

# Kiểm tra APK đã build thành công
if [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
    echo "✅ APK build thành công!"
    echo "📍 APK location: build/app/outputs/flutter-apk/app-debug.apk"
    ls -la build/app/outputs/flutter-apk/
else
    echo "❌ APK build thất bại"
    exit 1
fi