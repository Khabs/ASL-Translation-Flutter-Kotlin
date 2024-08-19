// models/voice_to_text_logic.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart'; // Import path_provider
import 'package:permission_handler/permission_handler.dart';
import '../services/whisper_api_client.dart';

class VoiceToTextLogic {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecorderInitialized = false;
  final WhisperApiClient _apiClient;
  String? _tempRecordingPath; // Added to store the recording path

  VoiceToTextLogic(this._apiClient);

  Future<void> initRecorder() async {
    // Requesting both microphone and storage permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
    ].request();

    if (statuses[Permission.microphone]?.isGranted != true ||
        statuses[Permission.storage]?.isGranted != true) {
      throw RecordingPermissionException('Microphone or Storage permission not granted');
    }

    await _recorder.openRecorder();
    _isRecorderInitialized = true;
  }

  Future<void> startRecording() async {
    if (!_isRecorderInitialized) await initRecorder();
    final tempDir = await getTemporaryDirectory(); // Get the temp directory
    _tempRecordingPath = '${tempDir.path}/audio_file.mp4'; // Store the file path
    await _recorder.startRecorder(toFile: _tempRecordingPath);
  }

  Future<String> stopRecordingAndGetTranscription() async {
    if (!_isRecorderInitialized || _tempRecordingPath == null) {
      return 'Recorder not initialized or path is null';
    }
    try {
      final path = await _recorder.stopRecorder();
      final File file = File(path ?? _tempRecordingPath!); // Use the stored path if stopRecorder doesn't return a path
      if (!file.existsSync()) {
        print('Temp Directory Path: $_tempRecordingPath');
        return 'Recorded audio file does not exist.';
      }
      final Uint8List audioData = await file.readAsBytes();
      final transcriptionResponse = await _apiClient.convertSpeechToText(
        filename: 'audio_file.mp4',
        audioData: audioData,
      );
      return transcriptionResponse['text'] ?? 'Error in transcription.';
    } catch (e) {
      print("Error in transcription: $e"); // Debug statement
      return 'Error in transcription: $e';
    }
  }

  Future<void> stopRecorder() async {
    if (!_isRecorderInitialized) return;
    await _recorder.stopRecorder();
  }
}
