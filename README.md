
  
# flutter_asl_translation  
#### Kotlin-Flutter ASL translation Project. >This is a Kotlin project using Google's MediaPipe code as a base with flutter included as a module.  
  
  
___  
## File Structure for ANDROID - Platform Specific  
  
### /app/src/main/ >**AndroidManifest.xml**  
>_Add features and permissions required for the app here._  
### /app/src/main/java/com/google/mediapipe/examples/gesturerecognizer/  
  
>**GesturerRecognizerHelper.kt** _Initializes gesture recognizer feature with the desired configurations_ 
>>**PoseLandmarkHelper.kt** _Initializes pose landmark feature with the desired configurations_  
>**PoseClassificationHelper.kt** _Classifies the pose using the pose landmarks from helper  
>**MultiModelHelper.kt** Takes labels from both pose and gesture helpers to find final label  
>**FlutterHostActivity.kt** _Enables navigation from flutter to native and sets up the FlutterEngine to be used throughout the application_ >**MainActivity.kt** _Handles user interaction, controls screen layouts, and initiates app functionalities, also contains method to navigate from native to flutter_ 
>>**MaxHeightScrollView.kt** Custom scrollview with a set height constraint  
>**SplashScreenActivity.kt** Custom splash screen code. Can adjust duration of splashscreen to match the actual animation  
  
### /app/src/main/res/  
>>**layout/** >_Contains main layout files such as activity_main which defines which menu to use etc_  
>>>**/activity_main.xml** Main activity layout. Sets everything up  
>>>**/activity_splash_screen.xml** Layout for splash screen  
>>>**/recording_controls_container.xml** Layout for final translated text under hand results.  
>>>**/item_gesture_recognizer_result.xml** Layout for hand results. Displayed under camera  
>>>**/fragment_camera.xml** Layout for camera display  
>  
>>**menu/new_bottom_nav_menu.xml** >_Defines menu items_ >>**drawable/** >_Contains drawable content such as icons for menu_ >>**values/** > Contains colors, dimensions files etc.  
 ___
 ## File Structure:  FLUTTER  
  
### flutter_module/ >  
>>**root_nav.dart** _  >The root nav used for navigation throughout the application_  
  
### flutter_module/lib/config/  
> _This directory is for all configs. Storing api keys, styling etc..._  
> >>**style.dart** >_Global style variables for color,font size etc._ >        
>>**connections.dart** >_Stores any connection variables as well as their getter methods. ( DB,ApiKey,ApiUrl etc)_  
>  
### flutter_module/lib/screens/  
>>**home_screen.dart** _Home screen ui._  
>>>**translation_screen.dart** _Loading screen to native from flutter._ >>      
>>**voice_to_text_screen.dart** The UI for the voice to text screen._  
>>>  
>>**search_for_sign_screen.dart** _The UI for the search for sign_  
### flutter_module/lib/models/  
>>**search_for_sign_model.dart** _Handles connections to the database_ >>**sign_model** _Object template to organize db data._ >>**nav_model** _State Managment template to store navigation index via provider._  
### flutter_module/lib/controllers/  
>>**voice_to_text_logic.dart** _Handles the logic for the voice to text translation.  _  
>>**search_for_sign_logic.dart** _Handles the logic for the search for sign._  
  
### flutter_module/lib/widgets/  
>>**reuseable_widgets.dart** _Contains reuseable widgets used throughout the app__  
  
  
### flutter_module/lib/services/  
>>**whisper_api_client.dart** _Handles the api call to send the audio file to whisper api for translation._  
 ___ 
 ### Developer Instructions:  
>_1. Download Flutter & Android Studio along with other dependencies_ >        
>_2. Open the project in android studio, select file>Sync project with gradle files._ >        
>_3. In your root project directory, go to the terminal and type cd flutter_module, then type "flutter clean" hit enter, then type "flutter pub get"_ >        
>_4. Go back to the root directory by typing "cd .." and you're done, you can now run the project on your android device or an emulator within android studio._ >  
>* _If you encounter an error that says  "**cannot delete flutter_module/.android**" while attempting flutter pub get. Just manually delete that folder. 
>
>* _Make sure you edit the config files and insert your own API KEYS for whisper open ai and firebase_*  

>___ 
>> >## Usefull Links  

>>[MediaPipe Developer Documentation For Android](https://developer.android.com/reference/android/view/GestureDetector) 
>>     
>   
>>[Flutter Platform Channels Documentation](https://docs.flutter.dev/platform-integration/platform-channels?tab=type-mappings-kotlin-tab) 
>___ 
>> > _The readmeFile is formatted to be viewed in "https://stackedit.io/app#"_
