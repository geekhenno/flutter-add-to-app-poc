import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Module POC',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const FlutterModuleScreen(),
    );
  }
}

class FlutterModuleScreen extends StatefulWidget {
  const FlutterModuleScreen({super.key});

  @override
  State<FlutterModuleScreen> createState() => _FlutterModuleScreenState();
}

class _FlutterModuleScreenState extends State<FlutterModuleScreen> {
  int _counter = 0;
  String _messageFromIOS = 'No message yet';

  // Create a MethodChannel for communication with iOS
  static const platform = MethodChannel('com.example.flutter_module/channel');

  @override
  void initState() {
    super.initState();
    // Listen for messages from iOS
    platform.setMethodCallHandler(_handleMethodCall);
  }

  // Handle method calls from iOS
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'showMessage':
        final String message = call.arguments as String;
        setState(() {
          _messageFromIOS = message;
        });
        // Show snackbar in Flutter
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Message from iOS: $message'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return 'Message received in Flutter';
      default:
        throw MissingPluginException();
    }
  }

  // Send message to iOS
  Future<void> _sendMessageToIOS() async {
    try {
      final String result = await platform.invokeMethod('showDialog', {
        'message': 'Hello from Flutter! Counter: $_counter',
      });
      print('Response from iOS: $result');
    } on PlatformException catch (e) {
      print("Failed to send message: '${e.message}'.");
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,  // AppBar stays at top
            title: const Text('Flutter Module POC'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
          const Center(
            child: Icon(Icons.flutter_dash, size: 100, color: Colors.blue),
          ),
          const SizedBox(height: 20),
          const Text(
            'Welcome to Flutter Module!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Counter Value:',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          Text(
            '$_counter',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _decrementCounter,
                icon: const Icon(Icons.remove),
                label: const Text('Decrease'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: _incrementCounter,
                icon: const Icon(Icons.add),
                label: const Text('Increase'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ],
          ),

          ...List.generate(4, (index) {
            return Column(
              children: [
                const SizedBox(height: 40),
                const Divider(),
                const SizedBox(height: 20),
                const Text(
                  'Platform Communication',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _sendMessageToIOS,
                    icon: const Icon(Icons.message),
                    label: const Text('Send to iOS (Show Dialog)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Last message from iOS:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _messageFromIOS,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
