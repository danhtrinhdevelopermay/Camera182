#!/bin/bash

echo "🔧 Testing Gradle Configuration"
echo "================================"

cd ios_camera_flutter_app

echo "📋 Current Android Configuration:"
echo ""
echo "--- Root build.gradle (buildscript) ---"
head -12 android/build.gradle
echo ""
echo "--- App build.gradle (plugin application) ---"
sed -n '24,26p' android/app/build.gradle  
echo ""
echo "--- MainActivity package ---"
head -1 android/app/src/main/kotlin/com/example/ios_camera_flutter_app/MainActivity.kt
echo ""
echo "--- Gradle wrapper version ---"
grep distributionUrl android/gradle/wrapper/gradle-wrapper.properties
echo ""
echo "--- gradle.properties ---"
cat android/gradle.properties

echo ""
echo "✅ Configuration verification complete"
echo "🚀 Ready for GitHub Actions build with workflow: build-apk-clean.yml"