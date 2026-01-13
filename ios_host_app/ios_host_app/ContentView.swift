import SwiftUI
import Flutter
import UIKit

// ⭐ Custom Gesture Recognizer - Solution from GitHub Issue #164670
// This controls iOS sheet's dismiss gesture to allow Flutter scrolling
final class FlutterDismissControlRecognizer: UIGestureRecognizer {
  
  enum DismissStrategy {
    case topRegion      // Allow dismiss only from top 50px
    case prohibited     // Completely disable gesture dismiss
  }
  
  private let strategy: DismissStrategy
  
  private var beganLocation: CGPoint = .zero
  private weak var dismissRecognizer: UIGestureRecognizer? = nil  // weak to avoid retain cycle
  
  init(strategy: DismissStrategy) {
    self.strategy = strategy
    super.init(target: nil, action: nil)
    
    delegate = self
  }
  
  private func setDismissRecognizerEnabled(location: CGPoint) {
    // Only enable sheet dismiss if touch is in top 50 pixels
    dismissRecognizer?.isEnabled = location.y <= 50
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    guard let touch = touches.first else { return }
    beganLocation = touch.location(in: view)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
    state = .failed
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
    state = .cancelled
  }
}

extension FlutterDismissControlRecognizer: UIGestureRecognizerDelegate {
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, 
                        shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
  
    // Find and control the iOS sheet's background dismiss recognizer
    if (dismissRecognizer == nil && otherGestureRecognizer.isBackgroundDismissRecognizer) {
      dismissRecognizer = otherGestureRecognizer
      
      switch strategy {
      case .topRegion:
        // Only allow dismiss from top region
        setDismissRecognizerEnabled(location: beganLocation)
      case .prohibited:
        // Completely disable gesture dismiss
        dismissRecognizer?.isEnabled = false
      }
    }
    return false
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, 
                        shouldReceive touch: UITouch) -> Bool {
    switch strategy {
    case .topRegion:
      // Dynamically enable/disable based on touch location
      setDismissRecognizerEnabled(location: touch.location(in: touch.view))
    case .prohibited:
      break
    }
    return true
  }
}

fileprivate extension UIGestureRecognizer {
  var isBackgroundDismissRecognizer: Bool {
    // Detect iOS sheet's internal dismiss gesture recognizer
    return name?.hasSuffix("UISheetInteractionBackgroundDismissRecognizer") ?? false
  }
}

struct ContentView: View {
    @EnvironmentObject var flutterDependencies: FlutterDependencies
    @State private var showFlutter = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                // Title
                Text("iOS Host App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Description
                Text("Tap the button to open Flutter Module")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 16) {
                    // Open Flutter Button
                    Button(action: {
                        showFlutter = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.up.forward.app")
                            Text("Open Flutter Module")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 250, height: 60)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    
                    // Send Message to Flutter Button
                    Button(action: {
                        sendMessageToFlutter()
                    }) {
                        HStack {
                            Image(systemName: "paperplane.fill")
                            Text("Send Message to Flutter")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 250, height: 60)
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showFlutter) {
            FlutterSheetView(flutterEngine: flutterDependencies.flutterEngine)
        }
    }
    
    private func sendMessageToFlutter() {
        guard let channel = flutterDependencies.methodChannel else {
            print("Method channel not available")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        let dateString = dateFormatter.string(from: Date())
        
        let message = "Hello from iOS! Time: \(dateString)"
        channel.invokeMethod("showMessage", arguments: message) { result in
            if let response = result as? String {
                print("Response from Flutter: \(response)")
            } else if let error = result as? FlutterError {
                print("Error: \(error.message ?? "Unknown error")")
            }
        }
    }
}

// SwiftUI wrapper for Flutter with custom gesture control
struct FlutterSheetView: UIViewControllerRepresentable {
    let flutterEngine: FlutterEngine
    
    func makeUIViewController(context: Context) -> FlutterSheetViewController {
        return FlutterSheetViewController(flutterEngine: flutterEngine)
    }
    
    func updateUIViewController(_ uiViewController: FlutterSheetViewController, context: Context) {
        // Nothing to update
    }
}

// Custom wrapper that applies the gesture recognizer solution
class FlutterSheetViewController: UIViewController {
    private let flutterEngine: FlutterEngine
    private var flutterViewController: FlutterViewController!
    private var dismissControlRecognizer: FlutterDismissControlRecognizer?
    
    init(flutterEngine: FlutterEngine) {
        self.flutterEngine = flutterEngine
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get or create Flutter view controller
        if let existing = flutterEngine.viewController as? FlutterViewController {
            flutterViewController = existing
        } else {
            flutterViewController = FlutterViewController(
                engine: flutterEngine,
                nibName: nil,
                bundle: nil
            )
        }
        
        // Add Flutter as child
        addChild(flutterViewController)
        view.addSubview(flutterViewController.view)
        flutterViewController.view.frame = view.bounds
        flutterViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        flutterViewController.didMove(toParent: self)
        
        // ⭐ THE KEY FIX: Add custom gesture recognizer
        // This prevents the sheet from consuming scroll gestures
        // Solution from: https://github.com/flutter/flutter/issues/164670
        dismissControlRecognizer = FlutterDismissControlRecognizer(strategy: .topRegion)
        if let recognizer = dismissControlRecognizer {
            view.addGestureRecognizer(recognizer)
        }
    }
    
    // ⭐ MEMORY LEAK FIX: Clean up when dismissed
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Remove gesture recognizer to break retain cycles
        if let recognizer = dismissControlRecognizer {
            view.removeGestureRecognizer(recognizer)
            dismissControlRecognizer = nil
        }
        
        // Note: We don't remove the FlutterViewController from parent here
        // because the FlutterEngine is cached and reused
        // The engine is managed by AppDelegate and cleaned up there
    }
    
    deinit {
        // Final cleanup
        if let recognizer = dismissControlRecognizer {
            view.removeGestureRecognizer(recognizer)
        }
        print("FlutterSheetViewController deallocated - no memory leak")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FlutterDependencies())
    }
}
