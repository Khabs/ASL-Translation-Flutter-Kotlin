package com.google.mediapipe.examples.gesturerecognizer.fragment

import android.annotation.SuppressLint
import android.content.res.Configuration
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.TextView
import android.widget.Toast
import androidx.camera.core.*
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.navigation.Navigation
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.mediapipe.examples.gesturerecognizer.GestureRecognizerHelper
import com.google.mediapipe.examples.gesturerecognizer.MainViewModel
import com.google.mediapipe.examples.gesturerecognizer.R
import com.google.mediapipe.examples.gesturerecognizer.databinding.FragmentCameraBinding
import com.google.mediapipe.tasks.vision.core.RunningMode
import java.util.*
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit

import com.google.mediapipe.examples.gesturerecognizer.PoseLandmarkerHelper
import com.google.mediapipe.examples.gesturerecognizer.MultiModelHelper
import androidx.camera.core.Preview
import androidx.camera.core.CameraSelector
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.ImageProxy
import androidx.camera.core.Camera
import androidx.camera.core.AspectRatio
import java.util.Locale




class CameraFragment : Fragment(),
    GestureRecognizerHelper.GestureRecognizerListener,
    PoseLandmarkerHelper.LandmarkerListener,
    MultiModelHelper.UpdateListener {


    //Override the interface from MultiModelHelper
    override fun onResultLabelListUpdated() {
        updateLabelsTextField()
    }
    //Methods to update text fields in the text container.
    private fun updateLabelsTextField() {
        val labelsTextField = activity?.findViewById<TextView>(R.id.LabelsTextField)
        activity?.runOnUiThread {
            labelsTextField?.text = multiModelHelper.currentResultLabelList.joinToString(separator = " ")
        }
    }


    companion object {
        private const val TAG = "Hand gesture recognizer"
    }



    private var _fragmentCameraBinding: FragmentCameraBinding? = null

    private val fragmentCameraBinding
        get() = _fragmentCameraBinding!!

    //creating the multiModel helper here to ensure the same instance is passed through both helpers.
    private lateinit var multiModelHelper: MultiModelHelper
    //Creating lateint var of helpers.
    private lateinit var gestureRecognizerHelper: GestureRecognizerHelper
    private lateinit var poseLandmarkerHelper: PoseLandmarkerHelper

    private val viewModel: MainViewModel by activityViewModels()
    private var defaultNumResults = 1

    private val gestureRecognizerResultAdapter: GestureRecognizerResultsAdapter by lazy {
        GestureRecognizerResultsAdapter().apply {
            updateAdapterSize(defaultNumResults)
        }
    }

    private var preview: Preview? = null
    private var imageAnalyzer: ImageAnalysis? = null
    private var camera: Camera? = null
    private var cameraProvider: ProcessCameraProvider? = null
    //Set to back camera - Instead of FRONT
    private var cameraFacing = CameraSelector.LENS_FACING_BACK

    /** Blocking ML operations are performed using this executor */
    private lateinit var backgroundExecutor: ExecutorService

    override fun onResume() {
        super.onResume()
        // Make sure that all permissions are still present, since the
        // user could have removed them while the app was in paused state.
        if (!PermissionsFragment.hasPermissions(requireContext())) {
            Navigation.findNavController(
                requireActivity(), R.id.fragment_container
            ).navigate(R.id.action_camera_to_permissions)
        }

        // Start the GestureRecognizerHelper again when users come back
        // to the foreground.
        backgroundExecutor.execute {
            if (gestureRecognizerHelper.isClosed()) {
                gestureRecognizerHelper.setupGestureRecognizer()
            }
        }

        // Start the PoseLandmarkerHelper again when users come back
        // to the foreground.
        backgroundExecutor.execute {
            if(this::poseLandmarkerHelper.isInitialized) {
                if (poseLandmarkerHelper.isClose()) {
                    poseLandmarkerHelper.setupPoseLandmarker()
                }
            }
        }



    }

    override fun onPause() {
        super.onPause()
        if (this::gestureRecognizerHelper.isInitialized) {
            viewModel.setMinHandDetectionConfidence(gestureRecognizerHelper.minHandDetectionConfidence)
            viewModel.setMinHandTrackingConfidence(gestureRecognizerHelper.minHandTrackingConfidence)
            viewModel.setMinHandPresenceConfidence(gestureRecognizerHelper.minHandPresenceConfidence)
            viewModel.setDelegate(gestureRecognizerHelper.currentDelegate)

            //PoseLandMarker

            viewModel.setMinPoseDetectionConfidence(poseLandmarkerHelper.minPoseDetectionConfidence)
            viewModel.setMinPoseTrackingConfidence(poseLandmarkerHelper.minPoseTrackingConfidence)
            viewModel.setMinPosePresenceConfidence(poseLandmarkerHelper.minPosePresenceConfidence)
            viewModel.setDelegate(poseLandmarkerHelper.currentDelegatePose)




            // Close the Gesture Recognizer helper and release resources
            backgroundExecutor.execute { gestureRecognizerHelper.clearGestureRecognizer() }

            // Close the PoseLandmarkerHelper and release resources
            backgroundExecutor.execute { poseLandmarkerHelper.clearPoseLandmarker() }

        }
    }

    override fun onDestroyView() {
        _fragmentCameraBinding = null
        super.onDestroyView()

        // Shut down our background executor
        backgroundExecutor.shutdown()
        backgroundExecutor.awaitTermination(
            Long.MAX_VALUE, TimeUnit.NANOSECONDS
        )
    }

    //Initialize the helpers on createView.
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _fragmentCameraBinding =
            FragmentCameraBinding.inflate(inflater, container, false)

        return fragmentCameraBinding.root
    }

    @SuppressLint("MissingPermission")
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)



        with(fragmentCameraBinding.recyclerviewResults) {
            layoutManager = LinearLayoutManager(requireContext())
            adapter = gestureRecognizerResultAdapter
        }

        // Initialize our background executor
        backgroundExecutor = Executors.newSingleThreadExecutor()

        // Initialize MultiModelHelper
        multiModelHelper = MultiModelHelper()

        // Assuming multiModelHelper is already initialized
        multiModelHelper.updateListener = this

        // Wait for the views to be properly laid out
        fragmentCameraBinding.viewFinder.post {
            // Set up the camera and its use cases
            setUpCamera()
        }


        // Toggle translation processing on button click
        viewModel.isTranslationEnabled.observe(viewLifecycleOwner) { isEnabled ->
            multiModelHelper.isTranslationEnabled = isEnabled

            //If the translation is toggled on again, clear the current text
            if(multiModelHelper.isTranslationEnabled){
                multiModelHelper.currentResultLabelList.clear()
                // Notify the listener that the list has been updated (cleared in this case).
                multiModelHelper.updateListener?.onResultLabelListUpdated()
            }



        }

        // Create the Hand Gesture Recognition Helper that will handle the
        // inference
        backgroundExecutor.execute {
            gestureRecognizerHelper = GestureRecognizerHelper(
                multiModelHelper = multiModelHelper,
                context = requireContext(),
                runningMode = RunningMode.LIVE_STREAM,
                minHandDetectionConfidence = viewModel.currentMinHandDetectionConfidence,
                minHandTrackingConfidence = viewModel.currentMinHandTrackingConfidence,
                minHandPresenceConfidence = viewModel.currentMinHandPresenceConfidence,
                currentDelegate = viewModel.currentDelegate,
                gestureRecognizerListener = this
            )


            // Create the PoseLandmarkerHelper that will handle the inference
            poseLandmarkerHelper = PoseLandmarkerHelper(
                multiModelHelper = multiModelHelper,
                context = requireContext(),
                runningMode = RunningMode.LIVE_STREAM,
                minPoseDetectionConfidence = viewModel.currentMinPoseDetectionConfidence,
                minPoseTrackingConfidence = viewModel.currentMinPoseTrackingConfidence,
                minPosePresenceConfidence = viewModel.currentMinPosePresenceConfidence,
                currentDelegatePose = viewModel.currentDelegate,
                poseLandmarkerHelperListener = this
            )

        }


    }





    // Initialize CameraX, and prepare to bind the camera use cases
    private fun setUpCamera() {
        val cameraProviderFuture =
            ProcessCameraProvider.getInstance(requireContext())
        cameraProviderFuture.addListener(
            {
                // CameraProvider
                cameraProvider = cameraProviderFuture.get()

                // Build and bind the camera use cases
                bindCameraUseCases()
            }, ContextCompat.getMainExecutor(requireContext())
        )
    }

    // Declare and bind preview, capture and analysis use cases
    @SuppressLint("UnsafeOptInUsageError")
    private fun bindCameraUseCases() {

        // CameraProvider
        val cameraProvider = cameraProvider
            ?: throw IllegalStateException("Camera initialization failed.")

        val cameraSelector =
            CameraSelector.Builder().requireLensFacing(cameraFacing).build()

        // Preview. Only using the 4:3 ratio because this is the closest to our models
        preview = Preview.Builder().setTargetAspectRatio(AspectRatio.RATIO_4_3)
            .setTargetRotation(fragmentCameraBinding.viewFinder.display.rotation)
            .build()

        // ImageAnalysis. Using RGBA 8888 to match how our models work
        imageAnalyzer =
            ImageAnalysis.Builder().setTargetAspectRatio(AspectRatio.RATIO_4_3)
                .setTargetRotation(fragmentCameraBinding.viewFinder.display.rotation)
                .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                .setOutputImageFormat(ImageAnalysis.OUTPUT_IMAGE_FORMAT_RGBA_8888)
                .build()
                // The analyzer can then be assigned to the instance
                .also {
                    it.setAnalyzer(backgroundExecutor) { image ->
                        //Removed use and close from detectPose , so the imageProxy is only closing with gesture not pose.
                        detectPose(image)
                        recognizeHand(image)


                        // Close the ImageProxy after all processing is done
                        image.close()

                    }
                }

        // Must unbind the use-cases before rebinding them
        cameraProvider.unbindAll()

        try {
            // A variable number of use-cases can be passed here -
            // camera provides access to CameraControl & CameraInfo
            camera = cameraProvider.bindToLifecycle(
                this, cameraSelector, preview, imageAnalyzer
            )

            // Attach the viewfinder's surface provider to preview use case
            preview?.setSurfaceProvider(fragmentCameraBinding.viewFinder.surfaceProvider)
        } catch (exc: Exception) {
            Log.e(TAG, "Use case binding failed", exc)
        }
    }








    private fun recognizeHand(imageProxy: ImageProxy) {
        gestureRecognizerHelper.recognizeLiveStream(
            imageProxy = imageProxy,
        )
    }

    //Detect Pose
    private fun detectPose(imageProxy: ImageProxy) {
        if(this::poseLandmarkerHelper.isInitialized) {
            poseLandmarkerHelper.detectLiveStream(
                imageProxy = imageProxy,
                isFrontCamera = cameraFacing == CameraSelector.LENS_FACING_FRONT
            )
        }
    }



    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        imageAnalyzer?.targetRotation =
            fragmentCameraBinding.viewFinder.display.rotation
    }

    // Update UI after a hand gesture has been recognized. Extracts original
    // image height/width to scale and place the landmarks properly through
    // OverlayView. Only one result is expected at a time. If two or more
    // hands are seen in the camera frame, only one will be processed.
    override fun onResults(
        resultBundle: GestureRecognizerHelper.ResultBundle
    ) {
        activity?.runOnUiThread {
            if (_fragmentCameraBinding != null) {
                // Show result of recognized gesture
                val gestureCategories = resultBundle.results.first().gestures()
                if (gestureCategories.isNotEmpty()) {
                    gestureRecognizerResultAdapter.updateResults(
                        gestureCategories.first()
                    )
                } else {
                    gestureRecognizerResultAdapter.updateResults(emptyList())
                }



                // Pass necessary information to OverlayView for drawing on the canvas
                fragmentCameraBinding.overlay.setResults(
                    resultBundle.results.first(),
                    resultBundle.inputImageHeight,
                    resultBundle.inputImageWidth,
                    RunningMode.LIVE_STREAM
                )

                // Force a redraw
                fragmentCameraBinding.overlay.invalidate()
            }
        }
    }


    // Update UI after pose have been detected. Extracts original
    // image height/width to scale and place the landmarks properly through
    // OverlayView
    override fun onResultsPose(
        resultBundlePose: PoseLandmarkerHelper.ResultBundlePose
    ) {
        activity?.runOnUiThread {
            if (_fragmentCameraBinding != null) {


                // Pass necessary information to OverlayView for drawing on the canvas
                fragmentCameraBinding.overlay.setResultsPose(
                    resultBundlePose.resultsPose.first(),
                    resultBundlePose.inputImageHeight,
                    resultBundlePose.inputImageWidth,
                    RunningMode.LIVE_STREAM
                )

                // Force a redraw
                fragmentCameraBinding.overlay.invalidate()
            }
        }
    }





    override fun onError(error: String, errorCode: Int) {
        activity?.runOnUiThread {
            Toast.makeText(requireContext(), error, Toast.LENGTH_SHORT).show()
            gestureRecognizerResultAdapter.updateResults(emptyList())



        }
    }


    override fun onErrorPose(error: String, errorCode: Int) {
        activity?.runOnUiThread {
            Toast.makeText(requireContext(), error, Toast.LENGTH_SHORT).show()

        }
    }



}
