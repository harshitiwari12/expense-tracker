class SmsData {
  final double amount;
  final String refNo;
  final String moneyType;
  final DateTime dateTime;

  SmsData({
    required this.amount,
    required this.refNo,
    required this.moneyType,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'refNo': refNo,
      'moneyType': moneyType,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory SmsData.fromJson(Map<String, dynamic> json) {
    return SmsData(
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      refNo: json['refNo'] ?? '',
      moneyType: json['moneyType'] ?? '',
      dateTime: DateTime.tryParse(json['dateTime'] ?? '') ?? DateTime.now(),
    );
  }
}

class SmsPayload {
  final List<SmsData> sms;
  SmsPayload({required this.sms});
  Map<String, dynamic> toJson() {
    return {
      'sms': sms.map((e) => e.toJson()).toList(),
    };
  }
}
