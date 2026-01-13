# Flutter Add-to-App POC

A comprehensive proof-of-concept demonstrating Flutter's add-to-app approach with native iOS (SwiftUI) and Android (Jetpack Compose) host applications.

## 🎯 What This Project Demonstrates

- ✅ **Flutter Module** integration in existing native apps
- ✅ **Bidirectional communication** between native and Flutter
- ✅ **iOS + Android** native host apps
- ✅ **Modern UI frameworks** (SwiftUI + Jetpack Compose)
- ✅ **iOS scroll issue solution** from [Flutter Issue #164670](https://github.com/flutter/flutter/issues/164670)
- ✅ **Memory leak prevention** with proper cleanup
- ✅ **Platform comparison** (iOS vs Android integration)

## 📁 Project Structure

```
add_to_app_poc/
├── flutter_module/              # 🦋 Shared Flutter module
│   ├── lib/main.dart           # Flutter UI with counter & communication
│   └── pubspec.yaml            # Flutter dependencies
│
├── ios_host_app/               # 📱 iOS host app (SwiftUI)
│   ├── ContentView.swift      # Main UI + gesture fix
│   ├── AppDelegate.swift      # FlutterEngine initialization
│   └── Podfile                # CocoaPods configuration
│
├── android_host_app/           # 🤖 Android host app (Jetpack Compose)
│   ├── MainActivity.kt        # Main UI + Flutter integration
│   └── build.gradle           # Gradle configuration
│
└── Documentation/              # 📚 Comprehensive guides
    ├── ARCHITECTURE_EXPLAINED.md
    ├── ANDROID_VS_IOS.md
    ├── MEMORY_LEAK_FIX.md
    └── ...more
```

## 🚀 Quick Start

### Prerequisites

- **Flutter SDK**: 3.7.0 or higher
- **iOS**: Xcode 15+, CocoaPods 1.11+, iOS 16+
- **Android**: Android Studio, Gradle 8.2+, API 24+

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/flutter-add-to-app-poc.git
cd flutter-add-to-app-poc
```

### 2️⃣ Set Up Flutter Module

```bash
cd flutter_module
flutter pub get
```

### 3️⃣ Run iOS App

```bash
cd ../ios_host_app
pod install
open ios_host_app.xcworkspace

# In Xcode: Select simulator and press ⌘R
```

### 4️⃣ Run Android App

```bash
cd ../android_host_app
# Open in Android Studio and click Run ▶️
# Or use command line:
./gradlew installDebug
```

## ✨ Features

### Flutter Module

- **Counter** with increment/decrement
- **CustomScrollView** with pinned SliverAppBar
- **MethodChannel** for platform communication
- **SnackBar** for displaying messages from native
- **Back navigation** to return to native

### iOS Host App

- **SwiftUI** modern interface
- **FlutterEngine caching** for performance
- **Custom gesture recognizer** solving iOS sheet scroll issue
- **Memory leak prevention** with proper cleanup
- **MethodChannel** for bidirectional communication
- **Native AlertDialog** triggered from Flutter

### Android Host App

- **Jetpack Compose** declarative UI
- **Material 3** design system
- **FlutterEngineCache** built-in
- **Perfect scrolling** (no iOS-like issues!)
- **MethodChannel** for bidirectional communication
- **Native AlertDialog** triggered from Flutter

## 🎓 Key Learnings

### The iOS Scroll Problem

**Problem**: iOS `UISheetPresentationController` intercepts scroll gestures, preventing Flutter content from scrolling properly.

**Solution**: Custom gesture recognizer that controls the sheet's dismiss gesture, only enabling it in the top 50 pixels. This is the [official solution](https://github.com/flutter/flutter/issues/164670) from the Flutter team.

```swift
// The fix:
let dismissControlRecognizer = FlutterDismissControlRecognizer(strategy: .topRegion)
view.addGestureRecognizer(dismissControlRecognizer)
```

**Result**: 
- ✅ Top 50px → Drag to dismiss sheet
- ✅ Rest of screen → Flutter scrolling works perfectly

### iOS vs Android Integration

| Aspect | iOS | Android |
|--------|-----|---------|
| **Scrolling** | Requires custom fix | ✅ Works perfectly |
| **Setup** | CocoaPods + Xcode | Gradle (simpler) |
| **Build System** | Multiple steps | Unified Gradle |
| **Gesture Handling** | Complex (sheet conflicts) | ✅ Clean |
| **Engine Caching** | Custom implementation | Built-in |

## 📊 Communication Flow

### Native → Flutter

```swift
// iOS
methodChannel.invokeMethod("showMessage", arguments: "Hello from iOS!")
```

```kotlin
// Android
methodChannel.invokeMethod("showMessage", message)
```

```dart
// Flutter receives
platform.setMethodCallHandler((call) async {
  if (call.method == 'showMessage') {
    // Show SnackBar
  }
});
```

### Flutter → Native

```dart
// Flutter
platform.invokeMethod('showDialog', {'message': 'Hello from Flutter!'});
```

```swift
// iOS receives
methodChannel.setMethodCallHandler { (call, result) in
  if call.method == "showDialog" {
    // Show AlertDialog
  }
}
```

```kotlin
// Android receives
methodChannel.setMethodCallHandler { call, result ->
  when (call.method) {
    "showDialog" -> {
      // Show AlertDialog
    }
  }
}
```

## 📚 Documentation

Comprehensive guides included:

- **[ARCHITECTURE_EXPLAINED.md](./Documentation/ARCHITECTURE_EXPLAINED.md)** - Deep dive into how everything works
- **[ANDROID_VS_IOS.md](./Documentation/ANDROID_VS_IOS.md)** - Platform comparison and insights
- **[MEMORY_LEAK_FIX.md](./ios_host_app/MEMORY_LEAK_FIX.md)** - iOS memory management
- **[SCROLL_FIX_SOLUTION.md](./ios_host_app/SCROLL_FIX_SOLUTION.md)** - iOS scroll problem solution
- **[QUICKSTART.md](./Documentation/QUICKSTART.md)** - Quick setup guide
- **[PLATFORM_COMMUNICATION_GUIDE.md](./Documentation/PLATFORM_COMMUNICATION_GUIDE.md)** - MethodChannel usage

## 🐛 Troubleshooting

### iOS: Build Errors

```bash
cd ios_host_app
pod deintegrate
pod install
# Clean build folder in Xcode (⇧⌘K)
```

### Android: Gradle Sync Failed

```bash
cd android_host_app
./gradlew clean
./gradlew build --refresh-dependencies
```

### Flutter: Module Not Found

```bash
cd flutter_module
flutter pub get
flutter build ios-framework --output=../FlutterFrameworks  # iOS
flutter build aar                                          # Android
```

## 🎯 Testing

### Test Scrolling (iOS)

1. Open iOS app
2. Tap "Open Flutter Module"
3. Try scrolling content - Should work smoothly ✅
4. Try dragging from top - Sheet dismisses ✅

### Test Communication

1. Open Flutter module
2. Tap "Send to iOS/Android" - Native dialog appears ✅
3. Return to native
4. Tap "Send Message to Flutter" - Flutter SnackBar appears ✅

### Test Memory Leaks (iOS)

1. Open/close Flutter module 10 times
2. Check Xcode console for: `"FlutterSheetViewController deallocated"` ✅
3. Use Memory Graph debugger - No accumulating instances ✅

## 🛠️ Technology Stack

- **Flutter**: 3.7.0+
- **iOS**: Swift 5.5+, SwiftUI, iOS 16+
- **Android**: Kotlin 1.9+, Jetpack Compose, API 24+
- **Build Tools**: CocoaPods 1.11+, Gradle 8.2+

## 🌟 Highlights

### iOS Achievements

- ✅ Solved the notorious iOS sheet scroll problem
- ✅ Implemented official Flutter team solution
- ✅ Memory leak prevention with proper cleanup
- ✅ Modern SwiftUI architecture

### Android Achievements

- ✅ Clean integration with no scroll issues
- ✅ Modern Jetpack Compose UI
- ✅ Simpler build system than iOS
- ✅ Perfect out-of-the-box experience

## 📖 References

- **Flutter Add-to-App**: https://docs.flutter.dev/add-to-app
- **GitHub Issue #164670**: https://github.com/flutter/flutter/issues/164670
- **Platform Channels**: https://docs.flutter.dev/platform-integration/platform-channels

## 🤝 Contributing

This is a proof-of-concept project. Feel free to:
- Open issues for questions
- Submit PRs for improvements
- Use as a reference for your own projects

## 📄 License

MIT License - Feel free to use this code in your projects.

## ⭐ Key Takeaways

1. **Flutter add-to-app is production-ready** for both iOS and Android
2. **iOS sheets require special handling** for scrollable Flutter content
3. **Android integration is simpler** and more straightforward
4. **Memory management matters** - proper cleanup prevents leaks
5. **Platform channels enable powerful** native-Flutter communication

---

**Created**: January 2026  
**Purpose**: Educational POC for Flutter add-to-app integration  
**Status**: ✅ Fully working with documented solutions

**⚡ The bottom line**: Flutter add-to-app works great, but iOS sheets need the custom gesture recognizer fix. Android works perfectly out of the box!
