import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_minor/api/api_urls.dart';

class EmailOtpService {
  // Method to send OTP to email
  static Future<bool> sendOtpToEmail(String email) async {
    try {
      final url = Uri.parse('${ApiUrls.baseURL}/api/emailVerification/sendOtp?email=$email');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('Send OTP - Status Code: ${response.statusCode}');
      print('Send OTP - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final body = jsonDecode(response.body);
          return body['status'] == true;
        } catch (e) {
          print('JSON decode error: $e');
          throw Exception('Invalid JSON response: ${response.body}');
        }
      } else {
        throw Exception("Failed to send OTP: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      throw Exception("Failed to send OTP: $e");
    }
  }

  // Method to verify the OTP
  static Future<bool> verifyEmailOtp(String email, String otp) async {
    try {
      // Properly formatted URL without spaces
      final url = Uri.parse('${ApiUrls.baseURL}/api/emailVerification/verifyOtp?email=$email&otp=$otp');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('Verify OTP - Status Code: ${response.statusCode}');
      print('Verify OTP - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final body = jsonDecode(response.body);
          return body['status'] == true;
        } catch (e) {
          print('JSON decode error: $e');
          throw Exception('Invalid JSON response: ${response.body}');
        }
      } else {
        throw Exception("OTP Verification Failed: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      throw Exception("OTP Verification Failed: $e");
    }
  }
}

//api/emailVerification/sendOtp?email=$email

//api/emailVerification/verifyOtp?email = ${email} & otp=${emailOtp}