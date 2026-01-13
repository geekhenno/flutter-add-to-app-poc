# Troubleshooting Guide

## ✅ Issue Fixed: Unable to load xcfilelist files

**Problem**: Xcode was showing errors about missing xcfilelist files:
```
Unable to load contents of file list: '.../Pods-ios_host_app-frameworks-Debug-input-files.xcfilelist'
Unable to load contents of file list: '.../Pods-ios_host_app-frameworks-Debug-output-files.xcfilelist'
```

**Root Cause**: The manually created Xcode project had incorrect build phase scripts that expected files which aren't generated when using `use_frameworks!` with Flutter modules.

**Solution Applied**: 
1. Removed the incorrect `[CP] Embed Pods Frameworks` build phase
2. Ran `pod install` to let CocoaPods properly integrate Flutter's build scripts
3. CocoaPods automatically added the correct scripts:
   - `[CP-User] Run Flutter Build flutter_module Script`
   - `[CP-User] Embed Flutter Build flutter_module Script`

## How to Build Now

1. **Open the Workspace** (Important!):
   ```bash
   cd /Users/henno/Desktop/pocs/ios_host_app
   open ios_host_app.xcworkspace
   ```

2. **Select a Device**: Choose any iOS simulator from the device menu in Xcode

3. **Build & Run**: Click Run (▶️) or press `Cmd + R`

The project should now build successfully! 🎉

## Common Issues & Solutions

### 1. "No such module 'Flutter'"
- Make sure you opened `.xcworkspace` not `.xcodeproj`
- Clean build folder: `Product > Clean Build Folder` (Cmd + Shift + K)
- Run `pod install` again

### 2. Build failures after Flutter changes
```bash
# Rebuild Flutter frameworks
cd /Users/henno/Desktop/pocs/flutter_module
flutter clean
flutter build ios-framework --output=../FlutterFrameworks

# Clean and rebuild iOS app
cd /Users/henno/Desktop/pocs/ios_host_app
pod install
# Then rebuild in Xcode
```

### 3. "FlutterEngine not found" or similar runtime errors
- Verify Flutter frameworks exist:
  ```bash
  ls -la /Users/henno/Desktop/pocs/FlutterFrameworks/Debug
  ```
- Check that Podfile is correctly pointing to flutter_module
- Verify `.ios` folder exists in flutter_module:
  ```bash
  ls -la /Users/henno/Desktop/pocs/flutter_module/.ios/Flutter/
  ```

### 4. Signing Issues
- Go to Xcode > Signing & Capabilities
- Select your development team
- Or use "Automatically manage signing"

### 5. Simulator Not Found
- Open Xcode > Window > Devices and Simulators
- Add a new simulator if needed
- Or use `xcrun simctl list` to see available simulators

## Complete Reset (Nuclear Option)

If nothing works, start fresh:

```bash
# Clean Flutter
cd /Users/henno/Desktop/pocs/flutter_module
flutter clean
flutter pub get

# Rebuild frameworks
flutter build ios-framework --output=../FlutterFrameworks

# Clean iOS
cd /Users/henno/Desktop/pocs/ios_host_app
rm -rf Pods Podfile.lock
pod install

# Clean Xcode derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Then open and build in Xcode
open ios_host_app.xcworkspace
```

## Verify Everything Works

Run these commands to verify your setup:

```bash
# Check Flutter setup
cd /Users/henno/Desktop/pocs/flutter_module
flutter doctor
flutter pub get

# Verify frameworks exist
ls -la /Users/henno/Desktop/pocs/FlutterFrameworks/Debug/
# Should show App.xcframework and Flutter.xcframework

# Verify podhelper exists
ls -la .ios/Flutter/podhelper.rb
# Should exist

# Check iOS project
cd /Users/henno/Desktop/pocs/ios_host_app
ls -la Pods/
# Should show Flutter and FlutterPluginRegistrant folders
```

## Build Logs

If you encounter build errors, check these locations:
- **Xcode Console**: View > Debug Area > Show Debug Area
- **Detailed logs**: Product > Build > Show the Report Navigator (Cmd + 9)
- **Terminal logs**: When running `flutter build` or `pod install`

## Success Indicators

When everything is working:
- ✅ `pod install` completes without errors
- ✅ Xcode shows no build phase script errors  
- ✅ Build succeeds (might take 1-2 min first time)
- ✅ App launches in simulator
- ✅ Tapping "Open Flutter Module" shows Flutter screen
- ✅ Counter buttons work in Flutter screen

## Need More Help?

1. Check the main README: `/Users/henno/Desktop/pocs/ios_host_app/README.md`
2. Flutter docs: https://docs.flutter.dev/add-to-app/ios
3. Run `flutter doctor` to check Flutter installation
4. Check CocoaPods version: `pod --version` (should be 1.11+)

---

**Status**: ✅ Fixed - Ready to build!  
**Last Updated**: 2026-01-12

