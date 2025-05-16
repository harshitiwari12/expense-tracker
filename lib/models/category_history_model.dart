class TransactionModel {
  final double amount;
  final DateTime time;

  TransactionModel({
    required this.amount,
    required this.time,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      amount: (json['amount'] ?? 0).toDouble(),
      time: DateTime.parse(json['timestamp']),
    );
  }
}

