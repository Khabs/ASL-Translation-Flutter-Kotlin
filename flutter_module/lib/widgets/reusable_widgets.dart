import 'package:flutter/material.dart';
import '../config/style.dart';

class AnimatedMicIcon extends StatefulWidget {
  final bool isRecording;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;



  const AnimatedMicIcon({
    Key? key,
    required this.isRecording,
    required this.onStartRecording,
    required this.onStopRecording,
  }) : super(key: key);

  @override
  _AnimatedMicIconState createState() => _AnimatedMicIconState();
}

class _AnimatedMicIconState extends State<AnimatedMicIcon> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0.0, end: 16.8).animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });

    if (widget.isRecording) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedMicIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording != oldWidget.isRecording) {
      if (widget.isRecording) {
        _animationController.forward();
      } else {
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Create style object
    final Styles styleObj = Styles();

    return Container(
      width: 126 + 16.8 * 21, // Maximum size including the largest wave
      height: 126 + 16.8 * 21,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Radio Waves Animation
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: 126 + _animation.value * 21, // Adjusted size for waves
                height: 126 + _animation.value * 21,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: styleObj.getPrimaryColor.withOpacity(1 - _animation.value / 16.8), // animation effect for waves
                ),
              );
            },
          ),
          // Microphone Icon (Always displayed, regardless of recording state)
          Icon(Icons.mic, size: 48, color: styleObj.getPrimaryColor),
        ],
      ),
    );
  }
}
