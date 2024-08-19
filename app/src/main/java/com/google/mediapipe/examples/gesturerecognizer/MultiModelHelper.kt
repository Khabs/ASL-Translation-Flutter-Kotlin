package com.google.mediapipe.examples.gesturerecognizer

import android.util.Log
import com.google.mediapipe.tasks.vision.gesturerecognizer.GestureRecognizerResult
import com.google.mediapipe.tasks.vision.poselandmarker.PoseLandmarkerResult

class MultiModelHelper {

    var currentPoseLabel: String = ""
    var currentGestureLabel: String = ""
    private var prevResultLabel: String = ""
    val currentResultLabelList = mutableListOf<String>()
    var updateListener: UpdateListener? = null

    var isTranslationEnabled: Boolean = false



    //Method called from the pose landmarker to fetch the current pose label
    fun updatePoseLabel(poseLabel: String) {
        currentPoseLabel = poseLabel
        Log.d("MultiModelHelper", "Received Pose Label: $poseLabel")
        checkIfGestureDataReady()
    }

    //Method called from gesture landmarker, to fetch the current gesture label
    fun updateGestureLabel(gestureLabel: String) {
        currentGestureLabel = gestureLabel
        Log.d("MultiModelHelper", "Received Gesture Label: $gestureLabel")
        checkIfGestureDataReady()
    }

    //Check if both a gesture and a pose label have been fetched before starting the translation.
    private fun checkIfGestureDataReady() {
        if (isTranslationEnabled && currentPoseLabel.isNotEmpty() && currentGestureLabel.isNotEmpty()) {
            // prevResultLabel = getCurrentResult()
            checkForTranslation()
            currentPoseLabel = ""
            currentGestureLabel = ""
        }
    }


    //Checking for matching combinations. Logic can be moved to database.
    //Some words were disabled for the presentation.
    private fun checkForTranslation() {
        val resultLabel = when {
            matches("salute", "B") -> "Hello"
            /* matches("b_hand_infront_chest", "thumbs_up")-> "How"
            (matches("hand_pose_a", "G") || matches("hand_pose_b", "P")|| matches("hand_pose_b", "Q")) && prevResultMatches  ("How") -> "are you?"*/
            matches("hand_pose_b", "one") && !prevResultMatches ( "Where") -> "Where"
            ( matches("hand_pose_b", "N") ||matches("hand_pose_b", "T")) && prevResultMatches( "Where") -> "is the bathroom?"
            (matches("hand_pose_b", "N")||matches("hand_pose_b", "T")) && !prevResultMatches("Where", "is the bathroom?" )-> "Bathroom"
            matches("hand_pose_b", "L") && prevResultMatches( "Where") -> "is the library?"
            matches("hand_pose_b", "L") && !prevResultMatches("Where", "is the library?")-> "Library"
            matches("hand_pose_a", "five") && !prevResultMatches ( "Thank you" )-> "Thank you"
            matches("hand_pose_b", "H") && !prevResultMatches ("See") -> "See"
            matches("hand_pose_b", "P") && prevResultMatches( "See" )-> "you later!"
            matches("pres_pose", "A") && !prevResultMatches ("President") -> "President"
            /*matches("hand_pose_b", "G") && !prevResultMatches ( "I'm good ") -> "I'm good"*/

            else -> return
        }
        Log.d("updating ResultLabel", "to: $resultLabel")
        updateResultLabel(resultLabel)
        prevResultLabel = resultLabel
    }


    //Checks if the input matches the current labels
    private fun matches(pose: String, gesture: String) = currentPoseLabel == pose && currentGestureLabel == gesture

    //Checks if an input matches the previous label, ignoring case sensitivity.
    private fun prevResultMatches(vararg labels: String) = labels.any { it.equals(prevResultLabel, ignoreCase = true) }

    //Fetches the last item in the label list.
    private fun getCurrentResult() = if (currentResultLabelList.isEmpty()) "" else currentResultLabelList.last()

    //Updates the result label list listener which in turn updates the UI.
    private fun updateResultLabel(newLabel: String) {
        val label = if (currentResultLabelList.isEmpty()) {
            newLabel.capitalize()
        } else {
            // Check if the last character of the last label in the list is "." or "?"
            val lastLabel = currentResultLabelList.lastOrNull()
            val lastChar = lastLabel?.lastOrNull()

            // Capitalize the new label if the last character of the last label is "." or "?"
            if (lastChar == '.' || lastChar == '?') {
                newLabel.capitalize()
            } else {
                newLabel.toLowerCase()
            }
        }

        if (currentResultLabelList.isEmpty() || !currentResultLabelList.last().equals(label, ignoreCase = true)) {
            currentResultLabelList.add(label)
            updateListener?.onResultLabelListUpdated()
        }
    }

    //Method to update the listener.
    interface UpdateListener {
        fun onResultLabelListUpdated()
    }
}
