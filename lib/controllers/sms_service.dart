import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sms_data.dart';

class SmsService {
  static Future<void> sendSmsToBackend(SmsData smsData) async {
    final url = Uri.parse("https://your-server.com/api/sms/save");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
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
