// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WeeklyPlan {
  final String id;
  final String planTitle;
  final double amountToSpread;
  final int numberOfWeeks;
  final String accountNumber;
  final String accountName;
  final String bank;
  final double weeklyPayment;
  final String
  paymentDay; // take note, if there is any issue with paymentDay and payDay clashes, consider chnaging here to payDay as we have it in the weekly controller
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
  });

  WeeklyPlan copyWith({
    String? id,
    String? planTitle,
    double? amountToSpread,
    int? numberOfWeeks,
    String? accountNumber,
    String? accountName,
    String? bank,
    double? weeklyPayment,
    String? selectedPayDay,
  }) {
    return WeeklyPlan(
      id: id ?? this.id,
      planTitle: planTitle ?? this.planTitle,
      amountToSpread: amountToSpread ?? this.amountToSpread,
      numberOfWeeks: numberOfWeeks ?? this.numberOfWeeks,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      bank: bank ?? this.bank,
      weeklyPayment: weeklyPayment ?? this.weeklyPayment,
      paymentDay: selectedPayDay ?? paymentDay,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'planTitle': planTitle,
      'amountToSpread': amountToSpread,
      'numberOfWeeks': numberOfWeeks,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'bank': bank,
      'weeklyPayment': weeklyPayment,
      'preferredDay': paymentDay,
    };
  }

  factory WeeklyPlan.fromMap(Map<String, dynamic> map) {
    return WeeklyPlan(
      id: map['id'] as String,
      planTitle: map['planTitle'] as String,
      amountToSpread: map['amountToSpread'] as double,
      numberOfWeeks: map['numberOfWeeks'] as int,
      accountNumber: map['accountNumber'] as String,
      accountName: map['accountName'] as String,
      bank: map['bank'] as String,
      weeklyPayment: map['weeklyPayment'] as double,
      paymentDay: map['preferredDay'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WeeklyPlan.fromJson(String source) =>
      WeeklyPlan.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WeeklyPlan(id: $id, planTitle: $planTitle, amountToSpread: $amountToSpread, numberOfWeeks: $numberOfWeeks, accountNumber: $accountNumber, accountName: $accountName, bank: $bank, weeklyPayment: $weeklyPayment, preferredDay: $paymentDay)';
  }

  @override
  bool operator ==(covariant WeeklyPlan other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.planTitle == planTitle &&
        other.amountToSpread == amountToSpread &&
        other.numberOfWeeks == numberOfWeeks &&
        other.accountNumber == accountNumber &&
        other.accountName == accountName &&
        other.bank == bank &&
        other.weeklyPayment == weeklyPayment &&
        other.paymentDay == paymentDay;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        planTitle.hashCode ^
        amountToSpread.hashCode ^
        numberOfWeeks.hashCode ^
        accountNumber.hashCode ^
        accountName.hashCode ^
        bank.hashCode ^
        weeklyPayment.hashCode ^
        paymentDay.hashCode;
  }
}
