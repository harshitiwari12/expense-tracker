class GetSms {
  final String amount;
  final String date;

  GetSms({required this.amount, required this.date});

  factory GetSms.fromJson(Map<String, dynamic> json) {
    return GetSms(
      amount: json['amount'],
      date: json['date'],
    );
  }
}
