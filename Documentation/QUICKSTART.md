# Quick Start Guide - Flutter Add-to-App POC

## 🚀 Get Started in 4 Steps

### Prerequisites

- **Flutter SDK**: 3.7.0 or higher
- **iOS**: Xcode 15+, CocoaPods 1.11+, iOS 16+
- **Android**: Android Studio, Gradle 8.2+, API 24+, **Java 17+** (required)

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/flutter-add-to-app-poc.git
cd flutter-add-to-app-poc
```

### 2️⃣ Set Up Flutter Module

**⚠️ CRITICAL STEP**: This generates the `.ios` and `.android` directories required by CocoaPods and Gradle.

```bash
cd flutter_module
flutter pub get
```

**What this does:**
- Downloads Flutter dependencies
- Generates `.ios/Flutter/podhelper.rb` (needed for CocoaPods)
- Generates `.android/` files (needed for Gradle)
- Creates Flutter framework configuration

### 3️⃣ Run iOS App

```bash
cd ../ios_host_app
pod install
open ios_host_app.xcworkspace
```

⚠️ **Important**: Open `.xcworkspace`, NOT `.xcodeproj`

**In Xcode:**
- Select a simulator (iPhone 15, iPhone 15 Pro, etc.)
- Press `⌘R` to run

### 4️⃣ Run Android App

```bash
cd ../android_host_app
# Open in Android Studio and click Run ▶️
# Or use command line:
./gradlew installDebug
```

## 🎯 What to Expect

### iOS Experience

1. **Native Screen**: White screen with SwiftUI interface
   - Title: "iOS Host App"
   - Button: "Open Flutter Module"
   - Another button: "Send Message to Flutter"

2. **Tap "Open Flutter Module"**: Opens Flutter in a sheet
   - App bar: "Flutter Module POC"
   - Flutter content with scrollable list
   - Counter with increment/decrement buttons

3. **Test Scrolling**: Scroll the Flutter content
   - ✅ Content scrolls smoothly
   - ✅ Top 50px allows drag-to-dismiss
   - ✅ No scroll conflicts!

4. **Test Communication**:
   - Tap "Send to iOS" in Flutter → Native iOS AlertDialog appears
   - Return to native, tap "Send Message to Flutter" → Flutter SnackBar appears

### Android Experience

1. **Native Screen**: Jetpack Compose Material 3 interface
   - Similar layout to iOS
   - Material Design components

2. **Tap "Open Flutter Module"**: Opens Flutter fullscreen
   - Same Flutter content as iOS
   - Perfect scrolling (no issues!)

3. **Test Communication**: Same bidirectional communication as iOS

## 📂 Project Structure

```
add_to_app_poc/
├── flutter_module/              # 🦋 Shared Flutter module
│   ├── lib/main.dart           # Flutter UI with counter & communication
│   ├── pubspec.yaml            # Flutter dependencies
│   ├── .ios/                   # Generated iOS integration (after flutter pub get)
│   └── .android/               # Generated Android integration (after flutter pub get)
│
├── ios_host_app/               # 📱 iOS host app (SwiftUI)
│   ├── ContentView.swift      # Main UI + gesture fix
│   ├── AppDelegate.swift      # FlutterEngine initialization
│   ├── Podfile                # CocoaPods configuration
│   └── ios_host_app.xcworkspace  # ← Open this in Xcode!
│
├── android_host_app/           # 🤖 Android host app (Jetpack Compose)
│   ├── MainActivity.kt        # Main UI + Flutter integration
│   └── build.gradle           # Gradle configuration
│
└── Documentation/              # 📚 Comprehensive guides
    ├── ARCHITECTURE_EXPLAINED.md
    ├── ANDROID_VS_IOS.md
    └── ...more
```

## 🐛 Common Issues

### Issue: "cannot load such file -- ../flutter_module/.ios/Flutter/podhelper.rb"

**Solution**: You forgot to run `flutter pub get` in the flutter_module!

```bash
cd flutter_module
flutter pub get
cd ../ios_host_app
pod install
```

### Issue: "Pod install fails"

**Solution**: Clean and reinstall

```bash
cd ios_host_app
rm -rf Pods Podfile.lock
pod install
```

### Issue: "Android build fails"

**Solution**: Clean and rebuild

```bash
cd android_host_app
./gradlew clean
./gradlew build
```

### Issue: "Unsupported class file major version 69"

**Problem**: Flutter's Gradle plugin requires Java 17+, but your system is using an older version.

**Check Java version:**
```bash
java -version
```

**Solution**: Use Java 17 or higher. The easiest way is to use Android Studio's bundled JDK:

```bash
# Add to ~/.zshrc or ~/.bash_profile:
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"

# Then reload:
source ~/.zshrc  # or source ~/.bash_profile
```

Or install Java 17 via Homebrew:
```bash
brew install openjdk@17
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
```

### Issue: "Flutter module not found"

**Solution**: Make sure you opened `.xcworkspace`, not `.xcodeproj`

### Issue: "iOS scroll doesn't work"

**Solution**: This project already includes the fix! Make sure you're running the latest code.

## 🔧 Make Changes

### Modify Flutter UI

1. Edit `flutter_module/lib/main.dart`
2. Hot reload (if using `flutter attach`)
3. Or rebuild the app

### Modify iOS UI

1. Edit `ios_host_app/ios_host_app/ContentView.swift`
2. Press `⌘R` in Xcode

### Modify Android UI

1. Edit `android_host_app/app/src/main/java/.../MainActivity.kt`
2. Click Run ▶️ in Android Studio

## 💡 Tips

- **First build**: Takes 1-2 minutes to compile Flutter
- **Subsequent builds**: Much faster (incremental compilation)
- **Hot restart**: Works if you run `flutter attach` while the app is running
- **Engine caching**: Flutter engine stays warm between launches

## 📚 Learn More

- **[README.md](../README.md)** - Main overview
- **[ARCHITECTURE_EXPLAINED.md](./ARCHITECTURE_EXPLAINED.md)** - Deep dive into architecture
- **[ANDROID_VS_IOS.md](./ANDROID_VS_IOS.md)** - Platform comparison
- **[PLATFORM_COMMUNICATION_GUIDE.md](./PLATFORM_COMMUNICATION_GUIDE.md)** - MethodChannel usage
- **Official Docs**: https://docs.flutter.dev/add-to-app

## ✨ This POC Demonstrates

✅ Flutter module integration in existing native apps  
✅ Bidirectional native-Flutter communication  
✅ iOS sheet scroll issue solution ([#164670](https://github.com/flutter/flutter/issues/164670))  
✅ Memory leak prevention with proper cleanup  
✅ Modern UI frameworks (SwiftUI + Jetpack Compose)  
✅ Production-ready architecture patterns  

Enjoy exploring Flutter's add-to-app capabilities! 🎉
