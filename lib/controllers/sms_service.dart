import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/sms_data.dart';

class SmsService {
  static Future<void> sendSmsToBackend(SmsData smsData) async {
    final url = Uri.parse("https://your-server.com/api/sms/save");

    // Get the JWT token from secure storage
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'jwt_token'); // Read token from storage

    if (token == null) {
      print("No JWT token found, user is not authenticated.");
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",  // Add the JWT token to the header
        },
        body: jsonEncode(smsData.toJson()),
      );

      if (response.statusCode == 200) {
        print("SMS saved successfully: ${smsData.refNo}");
      } else {
        print("Failed to save SMS: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending SMS to backend: $e");
    }
  }
}
