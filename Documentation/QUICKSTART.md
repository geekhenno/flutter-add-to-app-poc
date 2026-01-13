# Quick Start Guide - Flutter Add-to-App POC

## 🚀 Run the POC in 3 Steps

### Step 1: Open Xcode
```bash
cd /Users/henno/Desktop/pocs/ios_host_app
open ios_host_app.xcworkspace
```

⚠️ **Important**: Open `.xcworkspace`, NOT `.xcodeproj`

✅ **Note**: The Xcode project has been fixed and is ready to build!

### Step 2: Select a Device
In Xcode:
- Click on the device selector (top bar, next to the Run button)
- Choose any iPhone simulator (e.g., iPhone 15, iPhone 15 Pro)

### Step 3: Run
- Click the Run button (▶️) or press `Cmd + R`
- Wait for the app to build and launch

## 🎯 What to Expect

1. **Native iOS Screen**: You'll see a white screen with:
   - Title: "iOS Host App"
   - Description: "Tap the button to open Flutter Module"
   - Blue button: "Open Flutter Module"

2. **Tap the Button**: Opens the Flutter module

3. **Flutter Screen**: You'll see:
   - App bar: "Flutter Module POC"
   - Flutter Dash icon (blue)
   - "Welcome to Flutter Module!" text
   - Counter value display
   - Two buttons: "Decrease" and "Increase"

4. **Test It**: 
   - Tap Increase/Decrease to change the counter
   - Swipe down to dismiss and return to native iOS screen
   - Tap the button again - Flutter engine stays warm!

## 📂 Project Structure

```
/Users/henno/Desktop/pocs/
├── flutter_module/          ← Flutter module (single screen)
├── FlutterFrameworks/       ← Compiled Flutter frameworks
└── ios_host_app/           ← Native iOS app (opens Flutter)
```

## 🔧 Make Changes

### Modify Flutter UI
1. Edit `/Users/henno/Desktop/pocs/flutter_module/lib/main.dart`
2. Rebuild frameworks:
   ```bash
   cd /Users/henno/Desktop/pocs/flutter_module
   flutter build ios-framework --output=../FlutterFrameworks
   ```
3. Rebuild iOS app in Xcode (Cmd + B)
4. Run (Cmd + R)

### Modify iOS UI
1. Edit `/Users/henno/Desktop/pocs/ios_host_app/ios_host_app/ViewController.swift`
2. Run in Xcode (Cmd + R)

## 💡 Tips

- **First time building?** It might take 1-2 minutes to compile Flutter
- **Subsequent builds** are much faster (incremental compilation)
- **Can't find Flutter module?** Make sure you opened `.xcworkspace`
- **Need to start fresh?** See troubleshooting in the main README

## 📚 Learn More

- Main README: `/Users/henno/Desktop/pocs/ios_host_app/README.md`
- Flutter Module README: `/Users/henno/Desktop/pocs/flutter_module/README_MODULE.md`
- Official Docs: https://docs.flutter.dev/add-to-app

## ✨ This POC Demonstrates

✅ Flutter add-to-app integration  
✅ Flutter engine lifecycle management  
✅ Native-to-Flutter navigation  
✅ CocoaPods dependency management  
✅ Single screen/view Flutter module  
✅ Production-ready architecture patterns

Enjoy exploring Flutter's add-to-app capabilities! 🎉

