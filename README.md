
  
# flutter_asl_translation  
 
#### Kotlin-Flutter ASL translation Project.  
>This is a Kotlin project using Google's MediaPipe code as a base with flutter included as a module.  
  ___
## File Structure for ANDROID - Platform Specific  

  ### /app/src/main/
  >**AndroidManifest.xml**
  >_Add features and permissions required for the app here._ 

### /app/src/main/java/com/google/mediapipe/examples/gesturerecognizer/  
>**FlutterHostActivity.kt**  
<sub>_Enables flutter to Native navigation through platform channels_</sub>  

>**MainActivity.kt**  
<sub> _Handles user interaction, controls screen layouts, and initiates app functionalities._</sub>  
  
### /app/src/main/java/res/  
>**layout/**  
**menu/**  
**drawable/**  
  

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
### Notes:  
>* _Areas marked with "**TEMP DEBUG:**" are print statements that are not critical to the application's functionality. They are simply there to aid in the debugging process and should be removed after release._  
>
>* _Items marked with "**TO DO:**" are incomplete tasks that are to be done_  
___
> > _The readmeFile is formatted to be viewed in "https://stackedit.io/app#"_
