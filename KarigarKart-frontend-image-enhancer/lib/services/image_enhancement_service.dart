import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class ApiConfig {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );
}

class ImageEnhancementException implements Exception {
  const ImageEnhancementException(this.message);
  final String message;

  @override
  String toString() => message;
}

class ImageEnhancementService {
  const ImageEnhancementService();

  Future<Uint8List> enhance(String imagePath) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}/api/enhance-image'),
    );
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    try {
      final streamed = await request.send().timeout(const Duration(minutes: 3));
      final bytes = await streamed.stream.toBytes();
      if (streamed.statusCode == 200) return Uint8List.fromList(bytes);

      String message = 'Image enhancement failed (${streamed.statusCode}).';
      try {
        final payload = jsonDecode(utf8.decode(bytes));
        if (payload is Map && payload['detail'] is String) {
          message = payload['detail'] as String;
        }
      } catch (_) {
        // Retain the status-based message when the response is not JSON.
      }
      throw ImageEnhancementException(message);
    } on TimeoutException {
      throw const ImageEnhancementException(
        'The AI took too long. Confirm the backend is running and try again.',
      );
    } on ImageEnhancementException {
      rethrow;
    } catch (_) {
      throw const ImageEnhancementException(
        'Cannot reach the AI backend. Check the server address and Wi-Fi.',
      );
    }
  }
}
