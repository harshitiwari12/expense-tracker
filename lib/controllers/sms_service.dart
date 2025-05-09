import 'package:http/http.dart' as http;
import 'package:new_minor/api/api_urls.dart';
import 'dart:convert';
import '../models/sms_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmsService {
  static Future<void> sendSmsListToBackend(List<SmsData> smsList) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwt_token') ?? '';

    if (jwtToken.isEmpty) {
      print("JWT token not found. User might not be logged in.");
      return;
    }

    final payload = SmsPayload(sms: smsList);
    final uri = Uri.parse('${ApiUrls.baseURL}/api/sms/saved');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':'$jwtToken',
        },
        body: jsonEncode(payload.toJson()),
      );

      print("JWT Token: $jwtToken");
      print("Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        print("SMS data list sent successfully");
      } else {
        print("Failed to send SMS data list: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending SMS list: $e");
    }
  }
}

