import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_urls.dart';
import '../models/income.dart';

class IncomeController {
  final String token;
  final String apiUrl = ApiUrls.baseURL; // Replace with your real endpoint

  IncomeController({required this.token});

  Future<bool> submitIncome(Income income) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Include JWT token
      },
      body: jsonEncode(income.toJson()),
    );

    if(response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }
    else{
      print('Failed to submit income: ${response.statusCode}');
      print('Response: ${response.body}');
      return false;
    }
  }
}
