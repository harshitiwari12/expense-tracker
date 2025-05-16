class CategoryTotals {
  final int id;
  final double groceries;
  final double medical;
  final double domestic;
  final double shopping;
  final double bills;
  final double entertainment;
  final double travelling;
  final double fueling;
  final double educational;
  final double others;
  final DateTime datetime;

  CategoryTotals({
    required this.id,
    required this.groceries,
    required this.medical,
    required this.domestic,
    required this.shopping,
    required this.bills,
    required this.entertainment,
    required this.travelling,
    required this.fueling,
    required this.educational,
    required this.others,
    required this.datetime,
  });

  factory CategoryTotals.fromJson(Map<String, dynamic> json) {
    return CategoryTotals(
      id: json['id'] ?? 0,
      groceries: (json['groceries'] ?? 0).toDouble(),
      medical: (json['medical'] ?? 0).toDouble(),
      domestic: (json['domestic'] ?? 0).toDouble(),
      shopping: (json['shopping'] ?? 0).toDouble(),
      bills: (json['bills'] ?? 0).toDouble(),
      entertainment: (json['entertainment'] ?? 0).toDouble(),
      travelling: (json['travelling'] ?? 0).toDouble(),
      fueling: (json['fueling'] ?? 0).toDouble(),
      educational: (json['educational'] ?? 0).toDouble(),
      others: (json['others'] ?? 0).toDouble(),
      datetime: _parseDateTime(json['datetime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groceries': groceries,
      'medical': medical,
      'domestic': domestic,
      'shopping': shopping,
      'bills': bills,
      'entertainment': entertainment,
      'travelling': travelling,
      'fueling': fueling,
      'educational': educational,
      'others': others,
      'datetime': datetime.toIso8601String(),
    };
  }

  static DateTime _parseDateTime(dynamic dt) {
    if (dt == null) return DateTime.now();
    if (dt is DateTime) return dt;
    if (dt is String) return DateTime.tryParse(dt) ?? DateTime.now();
    return DateTime.now(); // fallback
  }
}
