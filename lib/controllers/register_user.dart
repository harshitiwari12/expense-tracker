import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:8080';

  static Future<bool> registerUser(User user) async {
    final url = Uri.parse('$_baseUrl/api/users/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    }
    else if (response.statusCode == 409) {
      throw Exception('User already exists');
    }
    else {
      throw Exception('Failed to register user');
    }
  }
}
