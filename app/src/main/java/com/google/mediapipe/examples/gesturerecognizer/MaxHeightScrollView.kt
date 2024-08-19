package com.google.mediapipe.examples.gesturerecognizer

import android.content.Context
import android.util.AttributeSet
import android.widget.ScrollView

class MaxHeightScrollView @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0
) : ScrollView(context, attrs, defStyleAttr) {

    private val maxHeight = 250 // Max height in pixels

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        val maxHeightMeasureSpec = MeasureSpec.makeMeasureSpec(maxHeight, MeasureSpec.AT_MOST)
        super.onMeasure(widthMeasureSpec, maxHeightMeasureSpec)
    }
}
