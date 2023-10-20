package com.google.mediapipe.examples.gesturerecognizer

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel

class FlutterHostActivity: FlutterActivity() {
    // Channel for communicating between Flutter and native Android code.
    private val CHANNEL = "com.ASL/navigateToNative"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Cache the FlutterEngine so it can be used by other Activities.
        FlutterEngineCache
            .getInstance()
            .put("flutterEngine", flutterEngine)

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
