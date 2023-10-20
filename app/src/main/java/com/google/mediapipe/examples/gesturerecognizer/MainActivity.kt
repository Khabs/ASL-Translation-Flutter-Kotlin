package com.google.mediapipe.examples.gesturerecognizer

import android.content.Intent
import android.os.Bundle
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.navigation.fragment.NavHostFragment
import androidx.navigation.ui.setupWithNavController
import com.google.mediapipe.examples.gesturerecognizer.databinding.ActivityMainBinding
import com.google.android.material.bottomnavigation.BottomNavigationView
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel

class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding
    private val viewModel: MainViewModel by viewModels()
    private var methodChannel: MethodChannel? = null



    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        //Call the cached instance of flutter engine from FlutterHostActivity
        val flutterEngine = FlutterEngineCache.getInstance().get("flutterEngine")
            ?: throw IllegalStateException("FlutterEngine not found in cache.")

        methodChannel = MethodChannel(flutterEngine.dartExecutor, "com.ASL/KotlinNav")

        val navHostFragment = supportFragmentManager.findFragmentById(R.id.fragment_container) as NavHostFragment
        val navController = navHostFragment.navController
        binding.navigation.setupWithNavController(navController)



        //Logic to decide which index each menu item sends to flutter.
        val bottomNavigationView = findViewById<BottomNavigationView>(R.id.new_bottom_navigation)
        bottomNavigationView.setOnItemSelectedListener { item ->
            when (item.itemId) {
                R.id.new_nav_item1 -> {
                    navigateToFlutterScreen(0)
                    true
                }
                R.id.new_nav_item2 -> {
                    navigateToFlutterScreen(1)
                    true
                }
                R.id.new_nav_item3 -> {
                    navigateToFlutterScreen(2)
                    true
                }
                else -> false
            }
        }
    }

    private fun navigateToFlutterScreen(screenIndex: Int) {
        methodChannel?.invokeMethod("navigateToFlutterScreen", screenIndex)
        // Finish this activity (close the screen) This needs to be here or nav won't close native page.
        finish()
    }



    // TO DO: Not urgent, working as intended but deprecated method.
    override fun onBackPressed() {
        methodChannel?.invokeMethod("onBackPressed", null, object : MethodChannel.Result {
            override fun success(result: Any?) {

                if (result is Boolean) {
                    if (!result) {
                        super@MainActivity.onBackPressed()
                    }
                } else {
                    // Handle unexpected data from Flutter.
                    super@MainActivity.onBackPressed()
                }
            }

            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                super@MainActivity.onBackPressed()
            }

            override fun notImplemented() {
                super@MainActivity.onBackPressed()
            }
        }) ?: super.onBackPressed()
    }
}
