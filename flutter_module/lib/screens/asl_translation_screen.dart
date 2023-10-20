import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ASLTranslationScreen extends StatefulWidget {
  @override
  _ASLTranslationScreenState createState() => _ASLTranslationScreenState();
}

class _ASLTranslationScreenState extends State<ASLTranslationScreen> {
  // Method channel declaration
  static const platform = const MethodChannel('com.ASL/navigateToNative');

  // This function will be called immediately after the widget is allocated memory
  @override
  void initState() {
    super.initState();
    _navigateToNativeScreen();
  }

  // Function to navigate to the native screen
  Future<void> _navigateToNativeScreen() async {
    try {
      await platform.invokeMethod('navigateToNativeScreen');
    } on PlatformException catch (e) {
      print("Failed to navigate: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    //  a placeholder
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // shows a loading indicator
      ),
    );
  }
}
