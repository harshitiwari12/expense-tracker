import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_urls.dart';
import '../models/sms_data.dart';

class SmsService {
  static const String _baseUrl = ApiUrls.baseURL;

  static Future<bool> sendSmsToBackend(SmsData smsData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwtToken');

      if (token == null) {
        print('JWT Token not found.');
        return false;
      }

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(smsData.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('SMS sent successfully.');
        return true;
      } else {
        print('Failed to send SMS: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error sending SMS: $e');
      return false;
    }
  }

}
