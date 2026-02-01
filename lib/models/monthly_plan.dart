import 'package:hive/hive.dart';

part 'monthly_plan.g.dart';

@HiveType(typeId: 1)
class MonthlyPlan extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String planTitle;

  @HiveField(2)
  final double amountToSpread;

  @HiveField(3)
  final int numberOfMonths;

  @HiveField(4)
  final String accountNumber;

  @HiveField(5)
  final String accountName;

  @HiveField(6)
  final String bank;

  @HiveField(7)
  final double monthlyPayment;

  @HiveField(8)
  final String preferredDate; // 1-25

  @HiveField(9)
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

  DateTime? nextPayment() {
    final now = DateTime.now();
    if (paymentDates.isEmpty) return null;
    return paymentDates.firstWhere(
      (d) => !d.isBefore(now),
      orElse: () => paymentDates.last,
    );
  }
}
