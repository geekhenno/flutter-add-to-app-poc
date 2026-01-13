import UIKit
import Flutter

@main
class AppDelegate: FlutterAppDelegate {
    
    lazy var flutterEngine = FlutterEngine(name: "my flutter engine")
    var methodChannel: FlutterMethodChannel?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Runs the default Dart entrypoint with a default Flutter route.
        flutterEngine.run()
        
        // Set up MethodChannel for communication with Flutter
        setupMethodChannel()
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func setupMethodChannel() {
        guard let controller = flutterEngine.binaryMessenger as? FlutterBinaryMessenger else {
            return
        }
        
        methodChannel = FlutterMethodChannel(
            name: "com.example.flutter_module/channel",
            binaryMessenger: controller
        )
        
        methodChannel?.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }
            
            if call.method == "showDialog" {
                if let args = call.arguments as? [String: Any],
                   let message = args["message"] as? String {
                    // Show dialog on main thread
                    DispatchQueue.main.async {
                        self.showAlertDialog(message: message)
                    }
                    result("Dialog shown in iOS")
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT",
                                      message: "Message argument is required",
                                      details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    func showAlertDialog(message: String) {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        let alert = UIAlertController(
            title: "Message from Flutter",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        // Find the topmost presented view controller
        var topController = rootViewController
        while let presented = topController.presentedViewController {
            topController = presented
        }
        
        topController.present(alert, animated: true)
    }
}

