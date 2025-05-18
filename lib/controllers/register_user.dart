import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_minor/api/secure_helper_functions.dart';
import '../api/api_urls.dart';
import '../models/user.dart';

class ApiService {
  static const String _baseUrl = ApiUrls.baseURL;

  static Future<bool> registerUser(User user) async {
    final url = Uri.parse('$_baseUrl/api/users/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    print('Response $response');
    print(response.body);

    if (response.statusCode == 201) {
      final body = jsonDecode(response.body);
      final token = body['token'];

      await SecureStorageHelper.saveToken(token);
      print("Saved JWT token: $token");

      return true;
    } else if (response.statusCode == 409) {
      throw Exception('User already exists');
    } else {
      throw Exception('Failed to register user');
    }
  }

  static Future<String?> fetchJwtToken() async {
    final token = await SecureStorageHelper.getToken();
    if (token == null) {
      print("No JWT token found, user is not authenticated.");
    } else {
      print("Fetched token: $token");
    }
    return token;
  }
}
