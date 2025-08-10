#!/bin/bash

echo "=== Testing Flutter Build Locally ==="

# Navigate to Flutter project
cd ios_camera_flutter_app || {
    echo "Error: ios_camera_flutter_app directory not found"
    exit 1
}

echo "=== Project Structure ==="
ls -la

echo "=== Checking pubspec.yaml ==="
if [ -f "pubspec.yaml" ]; then
    cat pubspec.yaml
else
    echo "Error: pubspec.yaml not found"
    exit 1
fi

echo "=== Flutter Doctor ==="
flutter doctor || {
    echo "Flutter not installed. Install Flutter first:"
    echo "https://docs.flutter.dev/get-started/install"
    exit 1
}

echo "=== Flutter Clean ==="
flutter clean

echo "=== Flutter Pub Get ==="
flutter pub get || {
    echo "Error: flutter pub get failed"
    exit 1
}

echo "=== Building APK ==="
flutter build apk --release --verbose || {
    echo "Error: APK build failed"
    echo "Check errors above"
    exit 1
}

echo "=== Build Success! ==="
echo "APK location: build/app/outputs/flutter-apk/app-release.apk"

if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    ls -la build/app/outputs/flutter-apk/
    echo "✅ APK built successfully!"
    echo "File size: $(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)"
else
    echo "❌ APK file not found after build"
    exit 1
fi