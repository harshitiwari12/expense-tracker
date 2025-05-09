class GetSmsData {
  final int id;
  final double amount;
  final String refNo;
  final String? category;
  final String moneyType;
  final DateTime dateTime;

  GetSmsData({
    required this.id,
    required this.amount,
    required this.refNo,
    required this.category,
    required this.moneyType,
    required this.dateTime,
  });

  factory GetSmsData.fromJson(Map<String, dynamic> json) {
    return GetSmsData(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      refNo: json['refNo'] ?? "N/A",
      category: json['category'],
      moneyType: json['moneyType'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'refNo': refNo,
      'category': category,
      'moneyType': moneyType,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
