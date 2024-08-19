// /src/com/google/mediapipe/examples/gesturerecognizer/SplashScreenActivity.kt
package com.google.mediapipe.examples.gesturerecognizer

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import androidx.appcompat.app.AppCompatActivity

class SplashScreenActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash_screen)

        Handler().postDelayed({
            startActivity(Intent(this, FlutterHostActivity::class.java))
            finish()
        }, 4600) // Duration of animation
    }
}
