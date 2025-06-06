import 'package:http/http.dart' as http;
import 'package:new_minor/api/secure_helper_functions.dart';
import 'dart:convert';
import '../api/api_urls.dart';
import '../models/sms_data.dart';

class SmsService {
  static Future<void> sendSmsListToBackend(List<SmsData> smsList) async {
    final jwtToken = await SecureStorageHelper.getToken();

    print('JWT Token found in Read SMS Page');
    if (jwtToken == null || jwtToken.isEmpty) {
      print("JWT token not found. User might not be logged in.");
      return;
    }

    final payload = SmsPayload(sms: smsList);
    final uri = Uri.parse('${ApiUrls.baseURL}/api/sms/save');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': jwtToken,
        },
        body: jsonEncode(payload.toJson()),
      );

      print("JWT Token of read sms page: $jwtToken");
      print("Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 204) {
        print("SMS data list sent successfully");
      } else {
        print("Failed to send SMS data list: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending SMS list: $e");
    }
  }
}
