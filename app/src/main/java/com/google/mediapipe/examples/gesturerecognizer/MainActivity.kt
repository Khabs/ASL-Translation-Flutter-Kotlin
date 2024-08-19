// /path/to/MainActivity.kt
package com.google.mediapipe.examples.gesturerecognizer

import android.os.Bundle
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.navigation.fragment.NavHostFragment
import androidx.navigation.ui.setupWithNavController
import com.google.mediapipe.examples.gesturerecognizer.databinding.ActivityMainBinding
import com.google.android.material.bottomnavigation.BottomNavigationView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log
import android.widget.ImageButton
import io.flutter.embedding.engine.FlutterEngineCache

class MainActivity : AppCompatActivity() {
    private lateinit var activityMainBinding: ActivityMainBinding
    private val viewModel: MainViewModel by viewModels()

    // Declare the MethodChannel
    private lateinit var methodChannel: MethodChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        activityMainBinding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(activityMainBinding.root)



        val navHostFragment = supportFragmentManager.findFragmentById(R.id.fragment_container) as NavHostFragment
        val navController = navHostFragment.navController
        activityMainBinding.navigation.setupWithNavController(navController)


        //Connect the button listener from main view model
        val btnRecord = findViewById<ImageButton>(R.id.btnRecord)


        // Inside onCreate or after you have initialized your views and ViewModel
        viewModel.isTranslationEnabled.observe(this) { isEnabled ->
            updateButtonIcon(isEnabled)
        }

        btnRecord.setOnClickListener {
            Log.d("MainActivity", "Button clicked")
            viewModel.toggleTranslationEnabled()
        }






        // Get the existing FlutterEngine from the cache
        val flutterEngine = FlutterEngineCache.getInstance().get("FlutterEngine000")


        // Initialize the MethodChannel with the existing engine with null handler
        methodChannel = flutterEngine?.let {
            MethodChannel(it.dartExecutor.binaryMessenger, "com.ASL/navigateToFlutter")
        }!!


        //Navigation index to send to rootNav on flutterside. (index should match the flutter rootnav)
        val newBottomNavigation = findViewById<BottomNavigationView>(R.id.new_bottom_navigation)



        newBottomNavigation.setOnItemSelectedListener { item ->
            when (item.itemId) {
                R.id.new_nav_item0 -> {
                    navigateToFlutterScreen(0)
                    true
                }
                R.id.new_nav_item1 -> {
                    navigateToFlutterScreen(1)
                    true
                }
                R.id.new_nav_item2 -> {
                    navigateToFlutterScreen(2)
                    true
                }
                R.id.new_nav_item3 -> {
                    navigateToFlutterScreen(3)
                    true
                }
                else -> false
            }
        }


    }

    private fun navigateToFlutterScreen(screenIndex: Int) {
        // Use the method channel to send a message to Flutter
        methodChannel.invokeMethod("navigateToScreen", screenIndex)
        finish()
    }

    //Define the drawable icon buttons for starting and pausing translation of words.
    private fun updateButtonIcon(isEnabled: Boolean) {
        val btnRecord = findViewById<ImageButton>(R.id.btnRecord)
        if (isEnabled) {
            btnRecord.setImageResource(R.drawable.record_icon_active) //  "active" icon
        } else {
            btnRecord.setImageResource(R.drawable.record_icon) //  "inactive" or default icon
        }
    }

    override fun onBackPressed() {
        finish()
    }
}
