class SmsData {
  final int amount;
  final int refNo;
  final String dateTime;

  SmsData({
    required this.amount,
    required this.refNo,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'refNo': refNo,
      'dateTime': dateTime,
    };
  }

  factory SmsData.fromJson(Map<String, dynamic> json) {
    return SmsData(
      amount: json['amount'] is int ? json['amount'] : int.tryParse(json['amount'].toString()) ?? 0,
      refNo: json['refNo'] is int ? json['refNo'] : int.tryParse(json['refNo'].toString()) ?? 0,
      dateTime: json['dateTime'] ?? '',
    );
  }
}
