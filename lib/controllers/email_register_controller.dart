import 'package:http/http.dart' as http;
import 'package:new_minor/api/api_urls.dart';

class EmailOtpService {
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
        if (response.body.toLowerCase().contains("otp sent")) {
          return true;
        } else {
          return false;
        }
      } else {
        throw Exception("Failed to send OTP: ${response.statusCode}");
      }
    } catch (e) {
      print("Send OTP Error: $e");
      throw Exception("Failed to send OTP: $e");
    }
  }

  static Future<bool> verifyEmailOtp(String email, String otp) async {
    try {
      final url = Uri.parse('${ApiUrls.baseURL}/api/emailVerification/verifyOtp?email=$email&otp=$otp');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('Verify OTP - Status Code: ${response.statusCode}');
      print('Verify OTP - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.toLowerCase().contains("otp verified") ||
            response.body.toLowerCase().contains("verified")) {
          return true;
        } else {
          return false;
        }
      } else {
        throw Exception("OTP Verification Failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Verify OTP Error: $e");
      throw Exception("OTP Verification Failed: $e");
    }
  }
}
