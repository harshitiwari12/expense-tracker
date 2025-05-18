import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_minor/api/api_urls.dart';
import 'package:new_minor/models/email_model.dart';

class EmailVerificationService {
  static Future<EmailVerificationResponse?> sendEmailVerification(String email) async {
    final url = Uri.parse('${ApiUrls.baseURL}/api/send-email-otp');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(EmailVerificationRequest(email: email).toJson()),
      );

      if (response.statusCode == 200) {
        return EmailVerificationResponse.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to send OTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception while sending OTP: $e');
    }

    return null;
  }

  static Future<EmailVerificationResponse?> verifyEmailOtp(String email, String otp) async {
    final url = Uri.parse('${ApiUrls.baseURL}/api/verify-email-otp');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(EmailVerificationRequest(email: email, otp: otp).toJson()),
      );

      if (response.statusCode == 200) {
        return EmailVerificationResponse.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to verify OTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception while verifying OTP: $e');
    }

    return null;
  }
}
