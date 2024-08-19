package com.google.mediapipe.examples.gesturerecognizer
//This file is for switching between Kotlin & Flutter, its configured along with the MainActivity file.



import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngineCache

class FlutterHostActivity: FlutterActivity() {
    // Channel for communicating between Flutter and native Android code.
    private val CHANNEL = "com.ASL/navigateToNative"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Store the FlutterEngine in the cache to use the same engine later on
        FlutterEngineCache.getInstance().put("FlutterEngine000", flutterEngine)


        // Creating a method channel and setting a call handler for it.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->

            if (call.method == "navigateToNativeScreen") {
                navigateToNativeScreen()
            } else {
                result.notImplemented()
            }
        }
    }

    private fun navigateToNativeScreen() {
        // Intent to start MainActivity.
        val intent = Intent(this, MainActivity::class.java)
        startActivity(intent)
    }
}
