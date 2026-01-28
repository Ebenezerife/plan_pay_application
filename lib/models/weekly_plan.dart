class WeeklyPlan {
  final String id;
  final String planTitle;
  final double amountToSpread;
  final int numberOfWeeks;
  final String accountNumber;
  final String accountName;
  final String bank;
  final double weeklyPayment;
  final String paymentDay; // Monday-Sunday
  final List<DateTime> paymentDates;

  WeeklyPlan({
    required this.id,
    required this.planTitle,
    required this.amountToSpread,
    required this.numberOfWeeks,
    required this.accountNumber,
    required this.accountName,
    required this.bank,
    required this.weeklyPayment,
    required this.paymentDay,
    required this.paymentDates,
  });

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
    'numberOfWeeks': numberOfWeeks,
    'accountNumber': accountNumber,
    'accountName': accountName,
    'bank': bank,
    'weeklyPayment': weeklyPayment,
    'paymentDay': paymentDay,
    'paymentDates': paymentDates.map((d) => d.toIso8601String()).toList(),
  };

  factory WeeklyPlan.fromMap(Map<String, dynamic> map) => WeeklyPlan(
    id: map['id'],
    planTitle: map['planTitle'],
    amountToSpread: map['amountToSpread'],
    numberOfWeeks: map['numberOfWeeks'],
    accountNumber: map['accountNumber'],
    accountName: map['accountName'],
    bank: map['bank'],
    weeklyPayment: map['weeklyPayment'],
    paymentDay: map['paymentDay'],
    paymentDates: List<String>.from(
      map['paymentDates'],
    ).map((s) => DateTime.parse(s)).toList(),
  );
}
