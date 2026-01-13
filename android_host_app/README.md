# Android Host App - Flutter Add-to-App POC

Modern Android app using **Kotlin + Jetpack Compose** that integrates a Flutter module.

## 🎯 Features

- ✅ **Jetpack Compose UI** - Modern declarative Android UI
- ✅ **Flutter Integration** - Cached FlutterEngine for performance
- ✅ **MethodChannel Communication** - Bidirectional data passing
- ✅ **Material 3 Design** - Latest Android design system
- ✅ **No Scroll Issues** - Android handles gestures cleanly!

## 📁 Project Structure

```
android_host_app/
├── app/
│   ├── build.gradle
│   └── src/main/
│       ├── AndroidManifest.xml
│       └── java/com/example/android_host_app/
│           └── MainActivity.kt
├── build.gradle
└── settings.gradle (includes Flutter module)
```

## 🚀 How to Run

### Prerequisites
- Android Studio (latest version)
- Flutter SDK installed
- Android SDK (API 24+)

### Steps

1. **Open in Android Studio**
   ```bash
   cd /Users/henno/Desktop/pocs/android_host_app
   # Open this folder in Android Studio
   ```

2. **Sync Gradle**
   - Android Studio will prompt to sync
   - Click "Sync Now"

3. **Run the App**
   - Select an emulator or connected device
   - Click Run (▶️) or press Shift + F10

4. **Test It**
   - Tap "Open Flutter Module" to see Flutter screen
   - Tap "Send Message to Flutter" to send data
   - Use the purple button in Flutter to send data back

## 🔧 Architecture

### Flutter Engine Initialization
```kotlin
// Create and cache Flutter engine
flutterEngine = FlutterEngine(this)
flutterEngine.dartExecutor.executeDartEntrypoint(...)
FlutterEngineCache.getInstance().put(ENGINE_ID, flutterEngine)
```

### MethodChannel Communication
```kotlin
// Android → Flutter
methodChannel.invokeMethod("showMessage", message)

// Flutter → Android
methodChannel.setMethodCallHandler { call, result ->
    when (call.method) {
        "showDialog" -> showAlertDialog(message)
    }
}
```

### Opening Flutter
```kotlin
startActivity(
    FlutterActivity
        .withCachedEngine(ENGINE_ID)
        .build(this)
)
```

## ✨ Advantages Over iOS

### Scrolling
- ✅ **No gesture conflicts** - Android doesn't have iOS sheet issues
- ✅ **Smooth scrolling** - Flutter ListView works perfectly
- ✅ **No workarounds needed** - Direct integration

### Integration
- ✅ **Simpler setup** - No CocoaPods, just Gradle
- ✅ **Better caching** - FlutterEngineCache built-in
- ✅ **Hot reload support** - Works out of the box

## 📊 Comparison: iOS vs Android

| Feature | iOS | Android |
|---------|-----|---------|
| **Scrolling** | Issues with pageSheet | ✅ Works perfectly |
| **Setup** | CocoaPods + Xcode | Gradle (simpler) |
| **UI Framework** | SwiftUI | Jetpack Compose |
| **Engine Caching** | Custom implementation | Built-in |
| **Gesture Conflicts** | Yes (iOS sheets) | No |

## 🎨 Jetpack Compose UI

The Android app uses modern Compose:

```kotlin
@Composable
fun MainScreen() {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text("Android Host App")
        Button(onClick = { openFlutter() }) {
            Text("Open Flutter Module")
        }
    }
}
```

## 🔍 Testing Communication

### Android → Flutter
1. Tap "Send Message to Flutter"
2. See green SnackBar in Flutter with message

### Flutter → Android
1. Open Flutter module
2. Tap purple "Send to iOS (Show Dialog)" button
3. See native Android AlertDialog

## 🐛 Troubleshooting

### Gradle Sync Failed
```bash
cd android_host_app
./gradlew clean
./gradlew build
```

### Flutter Module Not Found
```bash
# Ensure Flutter module is built
cd ../flutter_module
flutter pub get
flutter build aar
```

### Engine Not Starting
Check that `DartEntrypoint` is executed before caching

## 📚 Key Files

- **`MainActivity.kt`** - Main Android activity with Compose UI
- **`settings.gradle`** - Includes Flutter module
- **`app/build.gradle`** - Dependencies and Flutter integration

## 🎉 Success Indicators

When working correctly:
- ✅ App launches with Material 3 UI
- ✅ "Open Flutter Module" shows Flutter screen
- ✅ **Scrolling works smoothly** (no iOS issues!)
- ✅ Communication works bidirectionally
- ✅ Back button returns to Android

## 🆚 Why Android is Better for This

Android doesn't have the iOS pageSheet gesture conflict because:
1. Activities have separate touch handling
2. No modal sheet intercepting gestures
3. Flutter's gesture system works natively
4. Better framework integration

---

**Status**: ✅ Working perfectly!  
**Platform**: Android (API 24+)  
**UI**: Jetpack Compose + Material 3  
**Created**: 2026-01-12

