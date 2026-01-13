import Flutter
import Foundation

class FlutterDependencies: ObservableObject {
    let flutterEngine: FlutterEngine
    var methodChannel: FlutterMethodChannel?
    
    init() {
        // Get the shared Flutter engine from AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.flutterEngine = appDelegate.flutterEngine
            self.methodChannel = appDelegate.methodChannel
        } else {
            // Fallback: create a new engine if AppDelegate is not available
            self.flutterEngine = FlutterEngine(name: "fallback engine")
            self.flutterEngine.run()
        }
    }
}

