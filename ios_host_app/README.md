# iOS Host App - Flutter Add-to-App POC

This is a proof of concept (POC) demonstrating Flutter's add-to-app approach, integrating a Flutter module into a native iOS application.

## Project Structure

```
/Users/henno/Desktop/pocs/
├── flutter_module/          # Flutter module with one simple screen
│   ├── lib/
│   │   └── main.dart       # Flutter screen with counter functionality
│   └── pubspec.yaml
├── FlutterFrameworks/       # Compiled Flutter frameworks
│   ├── Debug/
│   ├── Profile/
│   └── Release/
└── ios_host_app/           # Native iOS host application
    ├── ios_host_app/
    │   ├── AppDelegate.swift
    │   ├── ViewController.swift
    │   └── SceneDelegate.swift
    └── Podfile
```

## Features

### Flutter Module
- Simple, clean single-screen UI
- Counter functionality with increment/decrement buttons
- Material Design 3 styling
- Flutter Dash icon

### iOS Host App
- Native Swift UIKit application
- Single button to launch Flutter module
- FlutterEngine integration for optimal performance
- Full-screen Flutter presentation

## How to Run

### Prerequisites
- Xcode 14.0 or later
- Flutter SDK installed
- CocoaPods installed

### Steps

1. **Open the iOS Project**
   ```bash
   cd /Users/henno/Desktop/pocs/ios_host_app
   open ios_host_app.xcworkspace  # Use .xcworkspace, NOT .xcodeproj
   ```

2. **Select a Simulator or Device**
   - Choose any iOS simulator or connected device from Xcode's device menu

3. **Run the App**
   - Click the Run button (▶️) in Xcode or press `Cmd + R`

4. **Test the Integration**
   - You'll see a native iOS screen with a button
   - Tap "Open Flutter Module" to launch the Flutter screen
   - Interact with the counter (increase/decrease buttons)
   - Swipe down or tap outside to dismiss the Flutter screen

## Rebuilding Flutter Module

If you make changes to the Flutter module, rebuild the frameworks:

```bash
cd /Users/henno/Desktop/pocs/flutter_module
flutter build ios-framework --output=../FlutterFrameworks
```

Then rebuild the iOS app in Xcode.

## Architecture

### Flutter Engine Lifecycle
- The Flutter engine is initialized once in `AppDelegate`
- The engine stays warm and ready for quick launches
- This approach minimizes startup time when opening Flutter screens

### Integration Method
- Uses CocoaPods for dependency management
- Flutter frameworks are embedded as dynamic frameworks
- Supports hot reload during development (see below)

## Development Tips

### Hot Reload (Optional)
For development with hot reload:

1. Run Flutter in debug mode:
   ```bash
   cd /Users/henno/Desktop/pocs/flutter_module
   flutter run -d <device-id>
   ```

2. Or attach to running app:
   ```bash
   flutter attach -d <device-id>
   ```

### Clean Build
If you encounter issues:

```bash
# Clean Flutter
cd /Users/henno/Desktop/pocs/flutter_module
flutter clean

# Rebuild frameworks
flutter build ios-framework --output=../FlutterFrameworks

# Clean iOS
cd /Users/henno/Desktop/pocs/ios_host_app
pod deintegrate
pod install
```

## Key Files

- **`flutter_module/lib/main.dart`**: Flutter UI implementation
- **`ios_host_app/ios_host_app/AppDelegate.swift`**: Flutter engine initialization
- **`ios_host_app/ios_host_app/ViewController.swift`**: Native iOS UI and Flutter integration
- **`ios_host_app/Podfile`**: CocoaPods configuration for Flutter

## Reference

Based on Flutter's official add-to-app documentation:
https://docs.flutter.dev/add-to-app

## Troubleshooting

### "No such module 'Flutter'"
- Make sure you're opening `.xcworkspace` and not `.xcodeproj`
- Run `pod install` again

### Build Failures
- Clean both projects and rebuild
- Ensure Flutter SDK path is correct in `Flutter/Generated.xcconfig`

### Flutter Screen Not Showing
- Check that Flutter engine is initialized in AppDelegate
- Verify Flutter frameworks are properly embedded (check Build Phases in Xcode)

## License

This is a proof of concept for educational purposes.

