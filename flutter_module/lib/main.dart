import 'package:flutter/material.dart';
import 'root_nav.dart';
import 'config/style.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'models/nav_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appStateModel = AppStateModel(); // Initialize AppStateModel outside

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(
      ChangeNotifierProvider.value(
        value: appStateModel,
        child: MyApp(),
      ),
    );
  } catch (e) {
    print("Firebase initialization error: $e");
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Styles styleObj = Styles();
    final MaterialColor primarySwatchColor = MaterialColor(
        styleObj.getPrimaryColor.value,
        <int, Color>{
          50: styleObj.getPrimaryColor,
          100: styleObj.getPrimaryColor,
          200: styleObj.getPrimaryColor,
          300: styleObj.getPrimaryColor,
          400: styleObj.getPrimaryColor,
          500: styleObj.getPrimaryColor,
          600: styleObj.getPrimaryColor,
          700: styleObj.getPrimaryColor,
          800: styleObj.getPrimaryColor,
          900: styleObj.getPrimaryColor,
        }
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sign It',
      theme: ThemeData(
        primarySwatch: primarySwatchColor,
      ),
      home: RootNav(),
    );
  }
}
