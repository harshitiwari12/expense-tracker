class CategorizedSmsData {
  final int id;
  final double amount;
  final String refNo;
  String? category;
  final String moneyType;
  final DateTime dateTime;

  CategorizedSmsData({
    required this.id,
    required this.amount,
    required this.refNo,
    required this.category,
    required this.moneyType,
    required this.dateTime,
  });

  factory CategorizedSmsData.fromJson(Map<String, dynamic> json) {
    return CategorizedSmsData(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      refNo: json['refNo'],
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
      'category': category?.toUpperCase(),
      'moneyType': moneyType,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
