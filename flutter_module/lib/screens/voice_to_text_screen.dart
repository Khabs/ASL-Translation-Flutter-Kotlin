import 'package:flutter/material.dart';
import '../controllers/voice_to_text_logic.dart';
import '../services/whisper_api_client.dart';
import '../widgets/reusable_widgets.dart';
import '../config/style.dart';



class VoiceToTextScreen extends StatefulWidget {
  @override
  _VoiceToTextScreenState createState() => _VoiceToTextScreenState();
}

class _VoiceToTextScreenState extends State<VoiceToTextScreen> {
  final VoiceToTextLogic _voiceToTextLogic = VoiceToTextLogic(WhisperApiClient());
  String _transcription = '';
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _voiceToTextLogic.initRecorder();
  }

  // Calls logic to start recording.
  void _startRecording() async {
    setState(() {
      _isRecording = true;
    });
    await _voiceToTextLogic.startRecording();
  }

  // Calls logic to stop recording and fetch the transcription.
  void _stopRecording() async {
    final transcription = await _voiceToTextLogic.stopRecordingAndGetTranscription();
    setState(() {
      _isRecording = false;
      _transcription = transcription;
    });
  }

  @override
  Widget build(BuildContext context) {

    //Create style object
    Styles styleObj = Styles();

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text messages for recording state
            if (!_isRecording)
              Text(
                'Press Microphone Icon To Record',
                style: styleObj.getHeaderTextStyle,
              ),
            if (_isRecording)
              Text(
                'Listening...',
                style: styleObj.getHeaderTextStyle,
              ),
            if (_isRecording)
              AnimatedMicIcon(
                isRecording: _isRecording,
                onStartRecording: () {},
                onStopRecording: () {},
              ),
            // Sky baby blue box for transcription text only when not recording
            if (!_isRecording)
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: styleObj.getSecondaryColor, // Sky baby blue color
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _transcription,
                      style: styleObj.getTranscriptionTextStyle,
                    ),
                  ),
                ),
              ),
            // Control buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  child: Icon(_isRecording ? Icons.stop : Icons.mic,
                  color: styleObj.getPrimaryColor),
                ),
                if (_isRecording)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _transcription = '';
                        _isRecording = false;
                      });
                      _voiceToTextLogic.stopRecorder();
                    },
                    child: Text('Cancel'),
                    style: TextButton.styleFrom(primary: styleObj.getSecondaryTextColor, backgroundColor: styleObj.getPrimaryColor),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
