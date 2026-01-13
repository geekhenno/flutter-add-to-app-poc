package com.example.android_host_app

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class MainActivity : ComponentActivity() {
    private val FLUTTER_ENGINE_ID = "my_flutter_engine"
    private val CHANNEL = "com.example.flutter_module/channel"
    private lateinit var flutterEngine: FlutterEngine
    private lateinit var methodChannel: MethodChannel
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Initialize Flutter engine
        flutterEngine = FlutterEngine(this)
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )
        FlutterEngineCache
            .getInstance()
            .put(FLUTTER_ENGINE_ID, flutterEngine)
        
        // Set up MethodChannel
        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        )
        
        // Handle messages from Flutter
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "showDialog" -> {
                    val message = call.argument<String>("message") ?: ""
                    runOnUiThread {
                        showAlertDialog(message)
                    }
                    result.success("Dialog shown in Android")
                }
                else -> result.notImplemented()
            }
        }
        
        setContent {
            MaterialTheme {
                MainScreen(
                    onOpenFlutter = { openFlutterModule() },
                    onSendMessage = { sendMessageToFlutter() }
                )
            }
        }
    }
    
    private fun openFlutterModule() {
        startActivity(
            FlutterActivity
                .withCachedEngine(FLUTTER_ENGINE_ID)
                .build(this)
        )
    }
    
    private fun sendMessageToFlutter() {
        val message = "Hello from Android! Time: ${System.currentTimeMillis()}"
        methodChannel.invokeMethod("showMessage", message, object : MethodChannel.Result {
            override fun success(result: Any?) {
                println("Response from Flutter: $result")
            }
            
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                println("Error: $errorMessage")
            }
            
            override fun notImplemented() {
                println("Method not implemented")
            }
        })
    }
    
    private fun showAlertDialog(message: String) {
        androidx.appcompat.app.AlertDialog.Builder(this)
            .setTitle("Message from Flutter")
            .setMessage(message)
            .setPositiveButton("OK") { dialog, _ -> dialog.dismiss() }
            .show()
    }
    
    override fun onDestroy() {
        super.onDestroy()
        FlutterEngineCache.getInstance().remove(FLUTTER_ENGINE_ID)
    }
}

@Composable
fun MainScreen(
    onOpenFlutter: () -> Unit,
    onSendMessage: () -> Unit
) {
    Surface(
        modifier = Modifier.fillMaxSize(),
        color = MaterialTheme.colorScheme.background
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Text(
                text = "Android Host App",
                fontSize = 32.sp,
                fontWeight = FontWeight.Bold
            )
            
            Spacer(modifier = Modifier.height(16.dp))
            
            Text(
                text = "Tap the button to open Flutter Module",
                fontSize = 16.sp,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
            
            Spacer(modifier = Modifier.height(32.dp))
            
            Button(
                onClick = onOpenFlutter,
                modifier = Modifier
                    .width(250.dp)
                    .height(60.dp)
            ) {
                Text("Open Flutter Module", fontSize = 18.sp)
            }
            
            Spacer(modifier = Modifier.height(16.dp))
            
            Button(
                onClick = onSendMessage,
                modifier = Modifier
                    .width(250.dp)
                    .height(60.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = MaterialTheme.colorScheme.secondary
                )
            ) {
                Text("Send Message to Flutter", fontSize = 16.sp)
            }
        }
    }
}

