// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MonthlyPlan {
  final String id;
  final String planTitle;
  final double amountToSpread;
  final int numberOfMonths;
  final String accountNumber;
  final String accountName;
  final String bank;
  final double monthlyPayment;
  final String preferredDate;
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
  });

  MonthlyPlan copyWith({
    String? id,
    String? title,
    double? amountToSpread,
    int? numberOfMonths,
    String? accountNumber,
    String? accountName,
    String? bank,
    double? monthlyPayment,
    String? preferredDate,
  }) {
    return MonthlyPlan(
      id: id ?? this.id,
      planTitle: title ?? planTitle,
      amountToSpread: amountToSpread ?? this.amountToSpread,
      numberOfMonths: numberOfMonths ?? this.numberOfMonths,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      bank: bank ?? this.bank,
      monthlyPayment: monthlyPayment ?? this.monthlyPayment,
      preferredDate: preferredDate ?? this.preferredDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': planTitle,
      'amountToSpread': amountToSpread,
      'numberOfMonths': numberOfMonths,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'bank': bank,
      'monthlyPayment': monthlyPayment,
      'preferredDate': preferredDate,
    };
  }

  factory MonthlyPlan.fromMap(Map<String, dynamic> map) {
    return MonthlyPlan(
      id: map['id'] as String,
      planTitle: map['title'] as String,
      amountToSpread: map['amountToSpread'] as double,
      numberOfMonths: map['numberOfMonths'] as int,
      accountNumber: map['accountNumber'] as String,
      accountName: map['accountName'] as String,
      bank: map['bank'] as String,
      monthlyPayment: map['monthlyPayment'] as double,
      preferredDate: map['preferredDate'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MonthlyPlan.fromJson(String source) =>
      MonthlyPlan.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MonthlyPlan(id: $id, title: $planTitle, amountToSpread: $amountToSpread, numberOfMonths: $numberOfMonths, accountNumber: $accountNumber, accountName: $accountName, bank: $bank, monthlyPayment: $monthlyPayment, preferredDate: $preferredDate)';
  }

  @override
  bool operator ==(covariant MonthlyPlan other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.planTitle == planTitle &&
        other.amountToSpread == amountToSpread &&
        other.numberOfMonths == numberOfMonths &&
        other.accountNumber == accountNumber &&
        other.accountName == accountName &&
        other.bank == bank &&
        other.monthlyPayment == monthlyPayment &&
        other.preferredDate == preferredDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        planTitle.hashCode ^
        amountToSpread.hashCode ^
        numberOfMonths.hashCode ^
        accountNumber.hashCode ^
        accountName.hashCode ^
        bank.hashCode ^
        monthlyPayment.hashCode ^
        preferredDate.hashCode;
  }
}
