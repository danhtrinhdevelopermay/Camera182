#!/bin/bash

echo "🔧 Khắc phục hoàn toàn Android Embedding và Gradle"
echo "=================================================="

cd ios_camera_flutter_app

echo "📋 1. Xóa tất cả build artifacts cũ"
rm -rf android/build
rm -rf android/.gradle  
rm -rf android/app/build
rm -rf build
rm -rf .dart_tool

echo "📋 2. Khắc phục Root build.gradle với buildscript"
cat > android/build.gradle << 'EOF'
buildscript {
    ext.kotlin_version = '1.7.10'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:7.3.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(':app')
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
EOF

echo "📋 3. Khắc phục App build.gradle"
cat > android/app/build.gradle << 'EOF'
def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

def flutterRoot = localProperties.getProperty('flutter.sdk')
if (flutterRoot == null) {
    throw new GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")
}

def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
if (flutterVersionCode == null) {
    flutterVersionCode = '1'
}

def flutterVersionName = localProperties.getProperty('flutter.versionName')
if (flutterVersionName == null) {
    flutterVersionName = '1.0'
}

apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"

android {
    compileSdkVersion flutter.compileSdkVersion
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {
        applicationId "com.example.ios_camera_flutter_app"
        minSdkVersion flutter.minSdkVersion
        targetSdkVersion flutter.targetSdkVersion
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }

    buildTypes {
        release {
            signingConfig signingConfigs.debug
        }
    }
}

flutter {
    source '../..'
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
}
EOF

echo "📋 4. Đảm bảo MainActivity đúng (Android embedding v2)"
mkdir -p android/app/src/main/kotlin/com/example/ios_camera_flutter_app
cat > android/app/src/main/kotlin/com/example/ios_camera_flutter_app/MainActivity.kt << 'EOF'
package com.example.ios_camera_flutter_app

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity()
EOF

echo "📋 5. Cập nhật gradle.properties"
cat > android/gradle.properties << 'EOF'
org.gradle.jvmargs=-Xmx1536M
android.useAndroidX=true
android.enableJetifier=true
EOF

echo "📋 6. Đảm bảo Gradle wrapper đúng phiên bản 7.5"
cat > android/gradle/wrapper/gradle-wrapper.properties << 'EOF'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip
EOF

chmod +x android/gradlew

echo "📋 7. Kiểm tra cấu hình cuối cùng"
echo ""
echo "--- Root build.gradle (buildscript) ---"
head -12 android/build.gradle
echo ""
echo "--- App build.gradle (plugin) ---" 
sed -n '24,26p' android/app/build.gradle
echo ""
echo "--- MainActivity ---"
head -1 android/app/src/main/kotlin/com/example/ios_camera_flutter_app/MainActivity.kt
echo ""
echo "--- Gradle wrapper ---"
grep distributionUrl android/gradle/wrapper/gradle-wrapper.properties

echo ""
echo "✅ HOÀN TẤT: Khắc phục Android embedding và Gradle configuration"
echo "🚀 Sẵn sàng build APK với cấu hình đã sửa!"
echo ""
echo "📝 Các workflow GitHub Actions có sẵn:"
echo "   - build-apk-ultimate-fix.yml (Java 11 + rebuild toàn bộ)"
echo "   - build-apk-clean.yml (xóa cache + force config)"
echo "   - build-apk-ready.yml (sử dụng config hiện tại)"