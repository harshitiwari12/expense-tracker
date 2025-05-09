import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_minor/models/post_sms_category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_urls.dart';
class SmsPostController {
  static Future<bool> submitCategorizedSms(List<CategorizedSmsData> smsList) async {
    final url = Uri.parse("${ApiUrls.baseURL}/api/sms/updatecategory");
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwt_token') ?? '';

    if (jwtToken.isEmpty) {
      print("JWT token not found.");
      return false;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': jwtToken,
        },
        body: jsonEncode({
          'sms': smsList.map((sms) => sms.toJson()).toList(),
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['status'] == true;
      } else {
        print("Failed to post data: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception during post: $e");
    }

    return false;
  }
}
