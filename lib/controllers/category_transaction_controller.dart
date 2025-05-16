import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_urls.dart';
import '../models/post_sms_category_model.dart';

class CategoryTransactionController {
  static Future<List<CategorizedSmsData>> fetchTransactionsByCategory(String category) async {
    final url = Uri.parse('${ApiUrls.baseURL}/api/sms/category?category=${category.toUpperCase()}');
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwt_token') ?? '';

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': jwtToken,
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print("API Response Body: $body");

        if (body.containsKey('smsList')) {
          final List<dynamic> jsonData = body['smsList'];
          return jsonData.map((item) => CategorizedSmsData.fromJson(item)).toList();
        } else {
          print("No 'smsList' field in the response");
        }
      } else {
        print("Failed to fetch transactions: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching transactions: $e");
    }

    return [];
  }
}
