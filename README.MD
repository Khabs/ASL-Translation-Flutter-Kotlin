

# The project files are incomplete at the moment.  
  
# flutter_asl_translation  
  
#### Kotlin-Flutter ASL translation Project.  
>This is a Kotlin project using Google's MediaPipe code as a base with flutter included as a module.  
 ___
 ## File Structure for ANDROID - Platform Specific  
  
### /app/src/main/  
>**AndroidManifest.xml**  
>_Add features and permissions required for the app here._  
  
### /app/src/main/java/com/google/mediapipe/examples/gesturerecognizer/  
>**FlutterHostActivity.kt** <sub>_Enables flutter to Native navigation through platform channels_</sub>  
  
>**MainActivity.kt** <sub> _Handles user interaction, controls screen layouts, and initiates app functionalities. Also has logic to navigate from native to flutter._</sub>  
  
### /app/src/main/java/res/  
>**layout/** 
>>**activity_main.xml**
>_Styling for the native side layout_

>**menu/** 
>>**new_bottom_nav_menu.xml**
>_The bottom nav on the native side_
>
>**drawable/**  
>>**ic_new_item.xml**
>_The custom menu items placed at the bottom menu for the native side_
  
  
 ___
 ## File Structure:  FLUTTER  
  
### flutter_module/lib/config/  
> _This directory is for all configs. Storing api keys, styling etc..._  
>>**style.dart**  
>_Global style variables for color,font size etc._  
  
### flutter_module/lib/screens/  
>>**home_screen.dart**  
_The root screen used for navigation. May not be the home page, depends on how we are going to structure our code/routing._  
  
>>**translation_screen.dart**  
_Loading screen to native from flutter._  
  
### flutter_module/lib/models/  
>_This directory will contain all business logic files_  
  
  
### flutter_module/lib/services/  
>_This directory will handle services(api calls etc)_  
  
  
 ___
 ### Developer Instructions:
 >_1. Download Flutter & Android Studio along with other dependencies_
 >
 >_2. Open the project in android studio, select file>Sync project with gradle files._
 >
 >_3. In your root project directory, go to the terminal and type cd flutter_module, then type "flutter clean" hit enter, then type "flutter pub get"_
 >
 >_4. Go back to the root directory by typing "cd .." and you're done, you can now run the project on your android device or an emulator within android studio._
 >

 ### Notes:  
>* _Areas marked with "**TEMP DEBUG:**" are print statements that are not critical to the application's functionality. They are simply there to aid in the debugging process and should be removed after release._  
>  
>* _Items marked with "**TO DO:**" are incomplete tasks that are to be done_  

 >## Usefull Links
 >
>>[MediaPipe Developer Documentation For Android](https://developer.android.com/reference/android/view/GestureDetector)
>
>>[Flutter Platform Channels Documentation](https://docs.flutter.dev/platform-integration/platform-channels?tab=type-mappings-kotlin-tab)

___  


> > _This project is in its early stages."_

