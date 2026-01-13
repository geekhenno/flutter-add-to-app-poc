# Scrolling Solutions for Flutter Add-to-App

## The Problem

When presenting Flutter as a `.pageSheet` modal in iOS, scrolling doesn't work properly due to gesture conflicts between:
- iOS's native swipe-to-dismiss gesture
- Flutter's scroll gesture recognizers

## Solution 1: Full Screen Presentation (Current - RECOMMENDED)

**Pros:**
- ✅ Perfect scrolling performance
- ✅ No gesture conflicts
- ✅ Full screen real estate
- ✅ Works with `SystemNavigator.pop()`

**Implementation:**
```swift
flutterViewController.modalPresentationStyle = .fullScreen
```

**When to use:** 
- Scrollable content (lists, long forms)
- Complex UIs
- When you need reliable scrolling

## Solution 2: PageSheet with Disabled Swipe Dismiss

If you want the card-style pageSheet presentation:

```swift
let flutterViewController = FlutterViewController(
    engine: flutterEngine,
    nibName: nil,
    bundle: nil
)

flutterViewController.modalPresentationStyle = .pageSheet

// Disable swipe-to-dismiss to prevent gesture conflicts
flutterViewController.isModalInPresentation = true

present(flutterViewController, animated: true)
```

**Pros:**
- ✅ Modern iOS card-style UI
- ✅ Scrolling works perfectly

**Cons:**
- ❌ Can't swipe down to dismiss
- ❌ Must use back button only

## Solution 3: Custom Sheet with Detents (iOS 15+)

For the best of both worlds:

```swift
let flutterViewController = FlutterViewController(
    engine: flutterEngine,
    nibName: nil,
    bundle: nil
)

flutterViewController.modalPresentationStyle = .pageSheet

if let sheet = flutterViewController.sheetPresentationController {
    // Allow medium and large sizes
    sheet.detents = [.medium(), .large()]
    
    // Enable grabber (handle) at the top
    sheet.prefersGrabberVisible = true
    
    // Prevent dismiss when scrolling
    sheet.largestUndimmedDetentIdentifier = .large
}

present(flutterViewController, animated: true)
```

**Pros:**
- ✅ Beautiful iOS 15+ sheet UI
- ✅ Draggable handle
- ✅ Can dismiss by dragging handle
- ✅ Scrolling works in content area

**Cons:**
- ❌ Requires iOS 15+

## Solution 4: Navigation Controller (Traditional)

For a traditional navigation flow:

```swift
let flutterViewController = FlutterViewController(
    engine: flutterEngine,
    nibName: nil,
    bundle: nil
)

let navController = UINavigationController(rootViewController: flutterViewController)
navController.modalPresentationStyle = .fullScreen

present(navController, animated: true)
```

## Flutter Side: Ensure Proper Scrolling

Always use these settings in Flutter for scrollable content:

```dart
ListView(
  // Force scrolling even when content is smaller than viewport
  physics: const AlwaysScrollableScrollPhysics(),
  
  // Add padding for better touch targets
  padding: const EdgeInsets.all(16),
  
  children: [
    // Your content
  ],
)
```

### Alternative: SingleChildScrollView

For simple scrollable content:

```dart
body: SingleChildScrollView(
  physics: const AlwaysScrollableScrollPhysics(),
  padding: const EdgeInsets.all(16),
  child: Column(
    children: [
      // Your content
    ],
  ),
)
```

## Debugging Scrolling Issues

### Check 1: Physics
```dart
// BAD - Might not scroll on pageSheet
physics: const ClampingScrollPhysics(),

// GOOD - Always scrollable
physics: const AlwaysScrollableScrollPhysics(),

// ALSO GOOD - Default bounce on iOS
physics: const BouncingScrollPhysics(),
```

### Check 2: Gesture Conflicts

If you have custom gestures in Flutter:
```dart
// Wrap with RawGestureDetector
RawGestureDetector(
  gestures: {
    VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<
        VerticalDragGestureRecognizer>(
      () => VerticalDragGestureRecognizer(),
      (instance) {
        instance.onUpdate = (details) {
          // Handle drag
        };
      },
    ),
  },
  child: ListView(...),
)
```

### Check 3: iOS Presentation

In Xcode console, if you see:
```
[warning] Gesture recognizer conflict detected
```

This means there's a gesture conflict. Use Solution 1 (fullScreen) or Solution 2 (disable swipe dismiss).

## Current Implementation

**File:** `ios_host_app/ViewController.swift`
```swift
flutterViewController.modalPresentationStyle = .fullScreen
```

**File:** `flutter_module/lib/main.dart`
```dart
body: ListView(
  padding: const EdgeInsets.all(16),
  physics: const AlwaysScrollableScrollPhysics(),
  children: [...],
)
```

## Quick Comparison

| Solution | Scrolling | Swipe Dismiss | iOS Version | Complexity |
|----------|-----------|---------------|-------------|------------|
| **Full Screen** | ✅ Perfect | ❌ No | iOS 13+ | ⭐ Easy |
| **PageSheet + isModalInPresentation** | ✅ Perfect | ❌ No | iOS 13+ | ⭐ Easy |
| **Sheet with Detents** | ✅ Perfect | ✅ Yes (via handle) | iOS 15+ | ⭐⭐ Medium |
| **Navigation Controller** | ✅ Perfect | ❌ No | All | ⭐⭐ Medium |

## Recommendation

For this POC with scrollable content:
- ✅ **Use Full Screen** (current implementation)
- Simple, reliable, works everywhere
- Perfect scrolling performance

If you want modern iOS sheet UI:
- ✅ **Use Sheet with Detents** (iOS 15+)
- Beautiful native feel
- Best user experience

---

**Current Status:** ✅ Scrolling Fixed (Full Screen Mode)  
**Updated:** 2026-01-12

