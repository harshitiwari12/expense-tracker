class SmsData {
  final String amount;
  final String refNo;
  final String dateTime;

  SmsData({
    required this.amount,
    required this.refNo,
    required this.dateTime,
  });

  Map<String, String> toJson() {
    return {
      'amount': amount,
      'refNo': refNo,
      'dateTime': dateTime,
    };
  }

  factory SmsData.fromJson(Map<String, dynamic> json) {
    return SmsData(
      amount: json['amount'] ?? '',
      refNo: json['refNo'] ?? '',
      dateTime: json['dateTime'] ?? '',
    );
  }
}
