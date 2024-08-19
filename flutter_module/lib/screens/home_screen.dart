import 'package:flutter/material.dart';
import 'search_for_sign_screen.dart';
import 'asl_translation_screen.dart';
import 'voice_to_text_screen.dart';
import '../config/style.dart';  // Ensure this path is correct
import '../root_nav.dart';

class HomeScreen extends StatelessWidget {
//Callback to enable navigation through rootNav
  final Function(int) navigateToScreen;

  HomeScreen({required this.navigateToScreen});

  @override
  Widget build(BuildContext context) {
    // Getting the screen height for equal division of cards
    double screenHeight = MediaQuery.of(context).size.height;
    final Styles styleObj = Styles();
    final RootNav navObj = RootNav();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            // First card
            GestureDetector(
              onTap: () {
                //Use rootNav function to navigate to index 1 ( Search for text)
                navigateToScreen(1);
              },
              child: buildCard(
                styleObj.getSecondaryColor,
                "Search for Sign",
                "Explore sign language through text inputs.",
                "assets/images/search_image.png",
                screenHeight,
              ),
            ),

            // Second card
            GestureDetector(
              onTap: () {
                //Use rootNav function to navigate to index 2
                navigateToScreen(2);
              },
              child: buildCard(
                styleObj.getPrimaryColor,
                "Gesture Recognition",
                "Interpret sign language from gestures.",
                "assets/images/gesture_image.png",
                screenHeight,
              ),
            ),

            // Third card
            GestureDetector(
              onTap: () {
                //Use rootNav function to navigate to index 3
                navigateToScreen(3);
              },
              child: buildCard(
                styleObj.getSecondaryColor,
                "Voice to Text",
                "Convert speech into text effortlessly.",
                "assets/images/voice_image.png",
                screenHeight,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  Widget buildCard(Color? cardColor, String title, String description, String imagePath, double screenHeight) {
    Color color = cardColor ?? Colors.grey;  // Fallback to a default color if null

    final Styles styleObj = Styles();
    double roundCornerValue=styleObj.getRoundedCornersValue;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 10,
      shadowColor: Colors.grey.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(roundCornerValue), // Rounded corners for Card
      ),
      child: ClipRRect(  // ClipRRect to enforce the border radius
        borderRadius: BorderRadius.circular(roundCornerValue), // Match the Card's borderRadius
        child: Container(
          height: screenHeight / 4.5,
          color: color,
          child: Row(
            children: [
              SizedBox(
                width: screenHeight / 8,
                height: screenHeight / 8,
                child: Image.asset(imagePath, fit: BoxFit.cover),  // Image size
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(description),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  }

