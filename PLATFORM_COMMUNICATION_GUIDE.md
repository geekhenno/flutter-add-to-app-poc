# Platform Communication Guide

## 🎯 Overview

This POC now demonstrates **bidirectional communication** between iOS and Flutter using **MethodChannel**.

## ✨ Features Implemented

### 1. iOS → Flutter Communication
- **Send messages** from iOS to Flutter
- **Show SnackBar** in Flutter when receiving messages
- **Update UI** in Flutter with received data

### 2. Flutter → iOS Communication
- **Send messages** from Flutter to iOS
- **Show Alert Dialog** in iOS when receiving messages
- **Pass data** like counter values

## 🚀 How to Test

### Step 1: Build and Run
```bash
cd /Users/henno/Desktop/pocs/ios_host_app
open ios_host_app.xcworkspace
```
Then press `Cmd + R` to run

### Step 2: Test iOS → Flutter
1. On the iOS home screen, tap **"Send Message to Flutter"**
2. **Result**: 
   - Flutter module opens automatically (if not already open)
   - A **green SnackBar** appears at the bottom with "Message from iOS: ..."
   - The message displays in the gray box under "Last message from iOS:"

### Step 3: Test Flutter → iOS
1. Open the Flutter module (tap "Open Flutter Module")
2. Tap the purple **"Send to iOS (Show Dialog)"** button
3. **Result**:
   - An **iOS Alert Dialog** appears with the message from Flutter
   - The message includes the current counter value

### Step 4: Test Data Flow
1. In Flutter, change the counter (tap Increase/Decrease)
2. Tap "Send to iOS (Show Dialog)"
3. Notice the dialog shows the updated counter value
4. Go back to iOS (swipe down or tap back button)
5. Tap "Send Message to Flutter" again
6. Open Flutter - see the new timestamp in the message

## 📋 Architecture

### MethodChannel
Both platforms use the same channel name: `com.example.flutter_module/channel`

### Methods

| Method Name | Direction | Parameters | Response | Action |
|------------|-----------|------------|----------|--------|
| `showMessage` | iOS → Flutter | `String` message | `String` confirmation | Shows SnackBar in Flutter |
| `showDialog` | Flutter → iOS | `Map` with message | `String` confirmation | Shows Alert Dialog in iOS |

## 🔧 Code Structure

### Flutter Side (`lib/main.dart`)

```dart
// 1. Create MethodChannel
static const platform = MethodChannel('com.example.flutter_module/channel');

// 2. Listen for messages from iOS
platform.setMethodCallHandler(_handleMethodCall);

// 3. Handle incoming messages
Future<dynamic> _handleMethodCall(MethodCall call) async {
  if (call.method == 'showMessage') {
    // Show SnackBar
    ScaffoldMessenger.of(context).showSnackBar(...);
  }
}

// 4. Send messages to iOS
await platform.invokeMethod('showDialog', {'message': '...'});
```

### iOS Side

**AppDelegate.swift:**
```swift
// 1. Create MethodChannel
methodChannel = FlutterMethodChannel(
    name: "com.example.flutter_module/channel",
    binaryMessenger: controller
)

// 2. Handle messages from Flutter
methodChannel?.setMethodCallHandler { (call, result) in
    if call.method == "showDialog" {
        // Show UIAlertController
    }
}
```

**ViewController.swift:**
```swift
// Send message to Flutter
channel.invokeMethod("showMessage", arguments: message) { result in
    // Handle response
}
```

## 🎨 UI Elements

### iOS Screen
- **Title**: "iOS Host App"
- **Button 1**: "Open Flutter Module" (blue) - Opens Flutter
- **Button 2**: "Send Message to Flutter" (green) - Sends message

### Flutter Screen
- **AppBar**: With back button
- **Counter Section**: Flutter Dash icon + counter with +/- buttons
- **Divider**
- **Communication Section**:
  - "Platform Communication" title
  - Purple button: "Send to iOS (Show Dialog)"
  - Gray box: Shows last message from iOS

## 💡 Use Cases

### Real-World Applications

1. **Authentication**: iOS handles login, passes token to Flutter
2. **Navigation**: Flutter can trigger iOS navigation
3. **Native Features**: Access iOS-specific features from Flutter
4. **Data Sync**: Share data between native and Flutter screens
5. **Analytics**: Report events from Flutter to iOS analytics
6. **Payments**: Flutter UI, iOS handles payment processing
7. **Push Notifications**: iOS receives, Flutter updates UI

## 🔄 Data Flow Examples

### Example 1: Send User Data
**iOS → Flutter:**
```swift
channel.invokeMethod("updateUser", arguments: [
    "name": "John Doe",
    "email": "john@example.com"
])
```

**Flutter receives:**
```dart
case 'updateUser':
  final Map data = call.arguments;
  setState(() {
    userName = data['name'];
    userEmail = data['email'];
  });
```

### Example 2: Request Native Action
**Flutter → iOS:**
```dart
final result = await platform.invokeMethod('shareContent', {
  'text': 'Check out this app!',
  'url': 'https://example.com'
});
```

**iOS handles:**
```swift
if call.method == "shareContent" {
    // Show iOS share sheet
    let activityVC = UIActivityViewController(...)
    present(activityVC, animated: true)
    result("Shared successfully")
}
```

## 🐛 Debugging Tips

### Check Channel Connection
**Flutter:**
```dart
print('Sending message to iOS...');
await platform.invokeMethod('test');
print('Message sent!');
```

**iOS:**
```swift
print("Received message from Flutter")
```

### Common Issues

**1. "MissingPluginException"**
- Channel names don't match
- Fix: Verify both use `com.example.flutter_module/channel`

**2. "Method not implemented"**
- iOS handler not set up
- Fix: Check `setMethodCallHandler` in AppDelegate

**3. Messages not received**
- FlutterEngine not running
- Fix: Ensure engine is started in AppDelegate

**4. UI not updating**
- Not using `setState` in Flutter
- Not on main thread in iOS
- Fix: Use `DispatchQueue.main.async` in iOS, `setState` in Flutter

## 📚 Extending the POC

### Add More Methods

**Flutter:**
```dart
case 'newMethod':
  // Handle new method
  return 'Success';
```

**iOS:**
```swift
if call.method == "newMethod" {
    // Handle new method
    result("Success")
}
```

### Pass Complex Data

**Use JSON:**
```swift
// iOS
let data = ["items": ["apple", "banana"], "count": 2]
channel.invokeMethod("updateList", arguments: data)
```

```dart
// Flutter
case 'updateList':
  final Map data = call.arguments;
  final List items = data['items'];
  final int count = data['count'];
```

## ✅ Testing Checklist

- [ ] iOS can send messages to Flutter
- [ ] Flutter shows SnackBar when receiving messages
- [ ] Flutter can send messages to iOS
- [ ] iOS shows Alert Dialog when receiving messages
- [ ] Counter value is passed correctly
- [ ] Messages persist and update
- [ ] Back navigation works
- [ ] Multiple open/close cycles work

## 🎉 Success!

You now have a fully functional bidirectional communication system between iOS and Flutter!

---

**Built**: 2026-01-12  
**Channel**: `com.example.flutter_module/channel`  
**Methods**: `showMessage`, `showDialog`

