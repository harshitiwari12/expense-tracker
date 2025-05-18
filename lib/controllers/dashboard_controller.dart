import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_minor/api/secure_helper_functions.dart';
import '../models/dashboard_data_model.dart';
import '../api/api_urls.dart';

class DashboardController {
  static Future<DashboardDataModel?> fetchDashboardData() async {
    final url = Uri.parse('${ApiUrls.baseURL}/api/users/profile');
    final jwtToken = await SecureStorageHelper.getToken(); // Securely get token

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
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          return DashboardDataModel.fromJson(data['data']);
        } else {
          print("Invalid dashboard data format.");
        }
      } else {
        print("Failed to load dashboard data: ${response.statusCode}");
      }
    } catch (e) {
      print("Not fetching dashboard Data: $e");
    }

    return null;
  }
}
