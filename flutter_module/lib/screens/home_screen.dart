import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'asl_translation_screen.dart';
import 'text_to_sign_screen.dart';
import 'voice_to_text_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const platform = const MethodChannel('com.ASL/KotlinNav');
  int _selectedIndex = 0;

  // List of pages for each tab
  final List<Widget> _pageOptions = [
    TextToSignScreen(),
    ASLTranslationScreen(),
    VoiceToTextScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // This line ensures the Flutter setup is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Set up the listener for the method channel for navigation
    platform.setMethodCallHandler(_handleMethod);
  }

  @override
  void dispose() {

    platform.setMethodCallHandler(null);

    super.dispose();
  }



  Future<void> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'navigateToFlutterScreen':
      // Navigate to the screen specified by 'call.arguments'
        int targetScreen = call.arguments;
        print("Reached, and attribute is $targetScreen");
        // Navigate to the flutter screen
        setState(() {
          _selectedIndex = targetScreen;
        });
        print("Attribute after selected index $targetScreen");
        break;
      default:
        print('Unexpected method ${call.method} invoked from native host');
        break;
    }
  }


  // Navigates to the index of button using pages list.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asl Translation'),
      ),
      body: _pageOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
