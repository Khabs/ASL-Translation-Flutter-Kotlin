package com.google.mediapipe.examples.gesturerecognizer

import android.content.Context
import android.util.Log

class PoseClassificationHelper(context: Context, csvFileName: String) {
    private val poseLandmarksList= ArrayList<PoseLandmarks>()

    init {
        val assetManager = context.assets
        context.assets.open(csvFileName).bufferedReader().use { reader ->
            reader.readLine() //Skip header row
            reader.forEachLine { line ->
                val values = line.split(",")
                val label = values[1]
                //Up to 25, only checks upper body. All 33, checks full pose
                val landmarks = DoubleArray(25 * 3) { i -> values[i + 2].toDouble() }
                poseLandmarksList.add(PoseLandmarks(label, landmarks))

            }
        }
    }

    fun classifyPose(detectedLandmarks: DoubleArray): String{
        var classifiedPose="unknown"
        var minDistance = Double.MAX_VALUE
        val tolerance =1.65 //tolerance level, higher more tolerable

        for(pose in poseLandmarksList){
            val distance = pose.calculateDistance(detectedLandmarks)
            Log.d("PoseClassifier","Distance to ${pose.label}: $distance")
            if(distance<minDistance){
                minDistance=distance
                classifiedPose=pose.label
            }
        }
        return if(minDistance <= tolerance) classifiedPose else "unknown"
    }

    //Utilize euc distance to calculate the distance between detected landmarks and csv landmark data. (x,y,z) of each of the 33 points.
    private class PoseLandmarks(val label:String, private val landmarks: DoubleArray){
        fun calculateDistance(detectedLandmarks: DoubleArray):Double{
            return kotlin.math.sqrt(landmarks.indices.sumOf{i->
                val diff=detectedLandmarks[i]-landmarks[i]
                diff* diff
            })
        }
    }
}