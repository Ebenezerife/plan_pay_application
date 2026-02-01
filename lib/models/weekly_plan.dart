import 'package:hive/hive.dart';

part 'weekly_plan.g.dart';

@HiveType(typeId: 2)
class WeeklyPlan extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String planTitle;

  @HiveField(2)
  final double amountToSpread;

  @HiveField(3)
  final int numberOfWeeks;

  @HiveField(4)
  final String accountNumber;

  @HiveField(5)
  final String accountName;

  @HiveField(6)
  final String bank;

  @HiveField(7)
  final double weeklyPayment;

  @HiveField(8)
  final String paymentDay;

  @HiveField(9)
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
}
