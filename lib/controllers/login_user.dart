import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../api/api_urls.dart';
import '../models/login_model.dart';

class AuthService {
  Future<String> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiUrls.baseURL}/api/users/signin"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final String token = responseData['token'];
        print("JWT TOKEN: ${token}");
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
