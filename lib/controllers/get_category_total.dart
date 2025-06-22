import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_minor/api/secure_helper_functions.dart';
import '../api/api_urls.dart';
import '../models/total_expense_model.dart';

class GetCategoryTotalsController {
  static Future<CategoryTotals?> fetchCategoryTotals() async {
    final url = Uri.parse("${ApiUrls.baseURL}/api/categories/amount");
    final jwtToken = await SecureStorageHelper.getToken(); 

    if (jwtToken == null || jwtToken.isEmpty) {
      print("JWT token not found.");
      return null;
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
        final Map<String, dynamic> data = jsonDecode(response.body);
        final Map<String, dynamic> categoryJson = data['category'];
        return CategoryTotals.fromJson(categoryJson);
      } else {
        print("Failed to fetch category totals: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching category totals: $e");
    }

    return null;
  }
}
