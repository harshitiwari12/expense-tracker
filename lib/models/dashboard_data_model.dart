class DashboardDataModel {
  final String username;
  final String mobileNo;
  final String bankName;
  final String email;
  final double monthlyIncome;
  final double targetSaving;
  final double totalExpense;
  final double totalSaving;

  DashboardDataModel({
    required this.username,
    required this.mobileNo,
    required this.bankName,
    required this.email,
    required this.monthlyIncome,
    required this.targetSaving,
    required this.totalExpense,
    required this.totalSaving,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardDataModel(
      username: json['name'] ?? '',
      mobileNo: json['mobile'] ?? '',
      bankName: json['bank'] ?? '',
      email: json['email'] ?? '',
      monthlyIncome: (json['income'] ?? 0).toDouble(),
      targetSaving: (json['savingAmount'] ?? 0).toDouble(),
      totalExpense: (json['debitedAmount'] ?? 0).toDouble(),
      totalSaving: (json['monthlyLimit'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': username,
      'mobile': mobileNo,
      'bank': bankName,
      'email': email,
      'income': monthlyIncome,
      'savingAmount': targetSaving,
      'debitedAmount': totalExpense,
      'monthlyLimit': totalSaving,
    };
  }
}
