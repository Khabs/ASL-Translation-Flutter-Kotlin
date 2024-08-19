// root_nav.dart
import 'package:flutter/material.dart';
import 'screens/asl_translation_screen.dart';
import 'screens/search_for_sign_screen.dart';
import 'screens/voice_to_text_screen.dart';
import 'screens/home_screen.dart';
import 'config/style.dart';
import 'package:provider/provider.dart';
import 'models/nav_model.dart';
import 'package:flutter/services.dart';

//This file handles our flutter navigation to other screens.
class RootNav extends StatefulWidget {
  @override
  _RootNavState createState() => _RootNavState();
}

class _RootNavState extends State<RootNav> with WidgetsBindingObserver {
  static const methodChannel = MethodChannel('com.ASL/navigateToFlutter');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    methodChannel.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == 'navigateToScreen') {
      final int screenIndex = call.arguments;
      navigateToScreen(screenIndex);
    }
  }
// Navigates to the specified screen index
  void navigateToScreen(int index) {
    final appState = Provider.of<AppStateModel>(context, listen: false);
    appState.updateSelectedIndex(index);
    print('RootNav navigateToScreen: index=$index');
  }

  @override
  Widget build(BuildContext context) {
    print('RootNav build');
    final appState = Provider.of<AppStateModel>(context);
    final List<Widget> _pageOptions = [
      HomeScreen(navigateToScreen: navigateToScreen),
      SearchForSignScreen(),
      ASLTranslationScreen(),
      VoiceToTextScreen(),
    ];

    final Styles styleObj = Styles();

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/s_logo.png',
          fit: BoxFit.cover,
          height: kToolbarHeight + 75,
        ),
        backgroundColor: styleObj.getAppBarColor,
      ),
      // Display the selected page from _pageOptions
      body: _pageOptions.elementAt(appState.getSelectedIndex),
      // Display the BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Voice',
          ),
        ],
        currentIndex: appState.getSelectedIndex,
        selectedItemColor: styleObj.getPrimaryColor,
        onTap: navigateToScreen,
      ),
    );
  }
// Clean up: remove lifecycle observer and nullify method channel handler
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    methodChannel.setMethodCallHandler(null);
    print('RootNav dispose');
    super.dispose();
  }
}
