import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../config/connections.dart';

class WhisperApiClient {
  final Connections configObj;

  // Constructor initializing the configuration object
  WhisperApiClient() : configObj = Connections();

  // Method to convert speech to text using the Whisper API
  Future<Map<String, dynamic>> convertSpeechToText({
    required String filename,
    required Uint8List audioData,
    String model = 'whisper-1',  // Default model parameter
  }) async {
    // Constructing the URI from the configuration object
    final uri = Uri.parse('${configObj.getWhisperApiApiUrl}/v1/audio/transcriptions');

    // Setting up headers with authorization
    final headers = <String, String>{
      'Authorization': 'Bearer ${configObj.getWhisperApiApiKey}',
      'Content-Type': 'application/json; charset=utf-8'  // Ensuring UTF-8 charset
    };

    // Create a multipart request to send audio data
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..fields['model'] = model  // Adding the model field to the request
      ..files.add(http.MultipartFile.fromBytes(
          'file',  // Field name expected by the API
          audioData,
          filename: filename,
          contentType: MediaType('audio', 'mpeg')  // Setting content type for the file
      ));

    try {
      // Sending the request and waiting for the streamed response
      final streamedResponse = await request.send();

      // Converting the streamed response to HTTP response
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Decode response body using UTF-8 decoder to handle special characters
        var decodedBody = utf8.decode(response.bodyBytes);
        print("API Response: $decodedBody");  // Debug statement to check response
        return json.decode(decodedBody);  // Decode JSON response
      } else {
        // Handle API errors by printing them and throwing an exception
        print("API Error: ${response.statusCode}");  // Debug statement for errors
        throw http.ClientException(
            'Failed to convert speech to text with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Print exceptions and rethrow them to be handled elsewhere
      print("API Exception: $e");  // Debug statement for exceptions
      rethrow;
    }
  }
}
