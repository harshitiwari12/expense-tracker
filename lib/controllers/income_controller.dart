import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_minor/api/api_urls.dart';
import 'package:new_minor/api/secure_helper_functions.dart';
import '../models/income.dart';


class IncomeController {
  Future<bool> submitIncome(Income incomeData) async {
    final url = Uri.parse(
      '${ApiUrls.baseURL}/api/amount/income?saving=${incomeData.targetSaving}&income=${incomeData.monthlyIncome}',
    );

    final jwtToken = await SecureStorageHelper.getToken(); // Use secure storage

    if (jwtToken == null || jwtToken.isEmpty) {
      print('JWT token not found.');
      return false;
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': jwtToken,
      },
      body: jsonEncode(incomeData.toJson()),
    );

    if (response.statusCode == 200) {
      print("Income data submitted successfully.");
      return true;
    } else {
      print("Failed to submit income data: ${response.body}");
      return false;
    }
  }
}
