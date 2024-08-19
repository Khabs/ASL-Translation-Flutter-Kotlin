//This file will be used for styling configurations to be used throughout the app

//TO DO: Create style variables and getter methods for color,
// font, and other reusable styling values.
import 'package:flutter/material.dart';
class Styles{

  //Color Scheme
  Color primaryColor =  Colors.blue;
  Color? secondaryColor = Colors.lightBlue[100];
  Color primaryTextColor =  Colors.black;
  Color secondaryTextColor =  Colors.white;
  Color appBarColor = Colors.white;

  double roundedCornersValue = 20.0;
  //Gif sizes
  double _gifHeightFactor = 0.3; // 30% of screen height
  double _gifWidthFactor = 0.5;  // 50% of screen width
  double _containerHeightFactor = 0.55; // 55% of screen height
  double _containerWidthFactor = 0.8;  // 80% of screen width


//Text Styles --FONT
  final appBarTextStyle = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: 'Montserrat',
    color: Colors.white,
  );

  final headerTextStyle = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: 'Montserrat',
    color: Colors.blue,
  );

  final transcriptionTextStyle = const TextStyle(
    fontFamily: 'Cairo',
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  );


  final paragraphTextStyle = const TextStyle(
    fontSize: 16,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.normal,
  );

  final infoMessageTextStyle = const TextStyle(
    fontSize: 14,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );




  //Getters

  //Colors
  Color get getPrimaryColor =>primaryColor;
  Color? get getSecondaryColor =>secondaryColor;
  Color get getPrimaryTextColor =>primaryTextColor;
  Color get getSecondaryTextColor =>secondaryTextColor;
  Color get getAppBarColor => appBarColor;

  //TextStyles
  TextStyle get getTranscriptionTextStyle => transcriptionTextStyle;
  TextStyle get getParagraphTextStyle => paragraphTextStyle;
  TextStyle get getHeaderTextStyle => headerTextStyle;
  TextStyle get getAppBarTextStyle => appBarTextStyle;
  TextStyle get getInfoMessageTextStyle => infoMessageTextStyle;

  double get getRoundedCornersValue => roundedCornersValue;

  double getGifHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * _gifHeightFactor;
  }

  double getGifWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * _gifWidthFactor;
  }

  double getGifContainerHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * _containerHeightFactor;
  }

  double getGifContainerWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * _containerWidthFactor;
  }


  //Style Notes - Add where each style is used (if needed) for development purposes.

//=========================================================
//Voice-Text Style cheat sheet
//=========================================================

//primaryColor
//used for icons

//secondaryColor
// Used for background for voice-text transcription.

//headerTextStyle
// used in voice-to-text for "Press to Record, Listning headers"

//******************************************************************





}