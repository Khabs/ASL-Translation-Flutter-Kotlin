/*
 * Copyright 2022 The TensorFlow Authors. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *             http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.google.mediapipe.examples.gesturerecognizer

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

class MainViewModel : ViewModel() {

    //Variables for gesture
    private var _delegate: Int = GestureRecognizerHelper.DELEGATE_CPU

    private var _minHandDetectionConfidence: Float =
        GestureRecognizerHelper.DEFAULT_HAND_DETECTION_CONFIDENCE

    private var _minHandTrackingConfidence: Float = GestureRecognizerHelper
        .DEFAULT_HAND_TRACKING_CONFIDENCE

    private var _minHandPresenceConfidence: Float = GestureRecognizerHelper
        .DEFAULT_HAND_PRESENCE_CONFIDENCE


    //Variables for pose
    private var _model = PoseLandmarkerHelper.MODEL_POSE_LANDMARKER_FULL
    private var _delegatePose: Int = PoseLandmarkerHelper.DELEGATE_CPU
    private var _minPoseDetectionConfidence: Float =
        PoseLandmarkerHelper.DEFAULT_POSE_DETECTION_CONFIDENCE
    private var _minPoseTrackingConfidence: Float = PoseLandmarkerHelper
        .DEFAULT_POSE_TRACKING_CONFIDENCE
    private var _minPosePresenceConfidence: Float = PoseLandmarkerHelper
        .DEFAULT_POSE_PRESENCE_CONFIDENCE

    val currentDelegatePose: Int get() = _delegatePose

    val currentModel: Int get() = _model

    val currentMinPoseDetectionConfidence: Float
        get() =
            _minPoseDetectionConfidence
    val currentMinPoseTrackingConfidence: Float
        get() =
            _minPoseTrackingConfidence
    val currentMinPosePresenceConfidence: Float
        get() =
            _minPosePresenceConfidence



    //Mutable live data to enable toggling of the button in multimodel helper
    private val _isTranslationEnabled = MutableLiveData<Boolean>()
    val isTranslationEnabled: LiveData<Boolean> = _isTranslationEnabled

    // Initialize with default value if necessary
    init {
        _isTranslationEnabled.value = false
    }

    fun toggleTranslationEnabled() {
        _isTranslationEnabled.value = !(_isTranslationEnabled.value ?: false)

    }

    val currentDelegate: Int get() = _delegate
    val currentMinHandDetectionConfidence: Float
        get() =
            _minHandDetectionConfidence

    val currentMinHandTrackingConfidence: Float
        get() =
            _minHandTrackingConfidence

    val currentMinHandPresenceConfidence: Float
        get() =
            _minHandPresenceConfidence


    fun setDelegate(delegate: Int) {
        _delegate = delegate

    }



    //Gesture confidence functions
    fun setMinHandDetectionConfidence(confidence: Float) {
        _minHandDetectionConfidence = confidence

    }

    fun setMinHandTrackingConfidence(confidence: Float) {
        _minHandTrackingConfidence = confidence

    }

    fun setMinHandPresenceConfidence(confidence: Float) {
        _minHandPresenceConfidence = confidence

    }




    //Pose confidence functions

    fun setMinPoseDetectionConfidence(confidence: Float) {
        _minPoseDetectionConfidence = confidence
    }

    fun setMinPoseTrackingConfidence(confidence: Float) {
        _minPoseTrackingConfidence = confidence
    }

    fun setMinPosePresenceConfidence(confidence: Float) {
        _minPosePresenceConfidence = confidence
    }

    fun setModel(model: Int) {
        _model = model
    }



}
