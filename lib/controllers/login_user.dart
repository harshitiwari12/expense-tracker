import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_model.dart';
class AuthService {
  final String _baseUrl = "http://<YOUR_BACKEND_IP>:<PORT>"; // Ask your friend for this

  Future<String> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/api/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        // Optional: save token if backend returns it
        return "Success";
      } else {
        return "Failed";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
