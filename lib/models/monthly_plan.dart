class MonthlyPlan {
  final String id;
  final String planTitle;
  final double amountToSpread;
  final int numberOfMonths;
  final String accountNumber;
  final String accountName;
  final String bank;
  final double monthlyPayment;
  final String preferredDate; // 1-25
  final List<DateTime> paymentDates;

  MonthlyPlan({
    required this.id,
    required this.planTitle,
    required this.amountToSpread,
    required this.numberOfMonths,
    required this.accountNumber,
    required this.accountName,
    required this.bank,
    required this.monthlyPayment,
    required this.preferredDate,
    required this.paymentDates,
  });

  /// Next payment date (today or future)
  DateTime? nextPayment() {
    final now = DateTime.now();
    if (paymentDates.isEmpty) return null;
    return paymentDates.firstWhere(
      (d) => !d.isBefore(now),
      orElse: () => paymentDates.last,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'planTitle': planTitle,
    'amountToSpread': amountToSpread,
    'numberOfMonths': numberOfMonths,
    'accountNumber': accountNumber,
    'accountName': accountName,
    'bank': bank,
    'monthlyPayment': monthlyPayment,
    'preferredDate': preferredDate,
    'paymentDates': paymentDates.map((d) => d.toIso8601String()).toList(),
  };

  factory MonthlyPlan.fromMap(Map<String, dynamic> map) => MonthlyPlan(
    id: map['id'],
    planTitle: map['planTitle'],
    amountToSpread: map['amountToSpread'],
    numberOfMonths: map['numberOfMonths'],
    accountNumber: map['accountNumber'],
    accountName: map['accountName'],
    bank: map['bank'],
    monthlyPayment: map['monthlyPayment'],
    preferredDate: map['preferredDate'],
    paymentDates: List<String>.from(
      map['paymentDates'],
    ).map((s) => DateTime.parse(s)).toList(),
  );
}
