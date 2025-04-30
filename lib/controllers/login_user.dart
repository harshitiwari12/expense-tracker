import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/login_model.dart';

class AuthService {
  final String _baseUrl = "https://ceaf-103-83-80-38.ngrok-free.app"; // Replace with your backend URL

  Future<String> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/api/users/login"),  // Replace with your backend login API endpoint
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final String token = responseData['token'];

        final storage = FlutterSecureStorage();
        await storage.write(key: 'jwt_token', value: token);

        return "Success";
      }
      else{
        return "Failed";
      }
    }
    catch (e){
      return "Error: $e";
    }
  }
}
