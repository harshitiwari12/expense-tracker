import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_minor/api/secure_helper_functions.dart';
import 'package:new_minor/models/post_sms_category_model.dart';
import '../api/api_urls.dart';


class SmsFetchController {
  static Future<List<CategorizedSmsData>> fetchCategorizedSms() async {
    final url = Uri.parse("${ApiUrls.baseURL}/api/sms/categorization");
    final jwtToken = await SecureStorageHelper.getToken(); // Secure fetch

    print("NEW TOKEN: $jwtToken");
    if (jwtToken == null || jwtToken.isEmpty) {
      print("JWT token not found.");
      return [];
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': jwtToken,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse.containsKey('smsList')) {
          final List<dynamic> smsList = jsonResponse['smsList'];
          return smsList.map((json) => CategorizedSmsData.fromJson(json)).toList();
        } else {
          print("Invalid structure: key 'smsList' missing.");
        }
      } else {
        print("Error fetching data: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception during fetch: $e");
    }

    return [];
  }
}
