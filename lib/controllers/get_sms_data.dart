import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_urls.dart';
import '../models/sms_data.dart';

class GetSmsData{
  static Future<List<SmsData>> fetchSmsData() async {
    final url = Uri.parse("${ApiUrls.baseURL}/api/sms/get");

    try{
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);

        List<SmsData> smsDataList = jsonList.map((json) {
          return SmsData.fromJson(json);
        }).toList();

        return smsDataList;
      }
      else{
        print("Failed to fetch SMS data: ${response.statusCode}");
        return [];
      }
    }
    catch(e) {
      print("Error fetching SMS data: $e");
      return [];
    }
  }
}
