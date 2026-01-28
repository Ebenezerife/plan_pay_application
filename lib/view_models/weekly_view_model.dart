import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_pay_application/models/weekly_plan.dart';
import 'package:plan_pay_application/view_models/wallet_view_model.dart';

class WeeklyViewModel extends GetxController {
  /// Plans
  final plans = <WeeklyPlan>[].obs;

  /// Controllers (single source of truth)
  final planTitleController = TextEditingController();
  final amountToSpreadController = TextEditingController();
  final numberOfWeeksController = TextEditingController();
  final accountNumberController = TextEditingController();
  final accountNameController = TextEditingController();
  final bankNameController = TextEditingController();

  /// Computed
  final weeklyPayment = 0.0.obs;

  /// Day selection
  final selectedDay = 'Monday'.obs;

  final List<String> allowedDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  @override
  void onInit() {
    super.onInit();

    amountToSpreadController.addListener(calculateWeeklyPayment);
    numberOfWeeksController.addListener(calculateWeeklyPayment);
  }

  @override
  void onClose() {
    planTitleController.dispose();
    amountToSpreadController.dispose();
    numberOfWeeksController.dispose();
    accountNumberController.dispose();
    accountNameController.dispose();
    bankNameController.dispose();
    super.onClose();
  }

  /// Calculate weekly payment
  void calculateWeeklyPayment() {
    final amount = double.tryParse(
          amountToSpreadController.text.replaceAll(',', '').trim(),
        ) ??
        0;
    final weeks =
        int.tryParse(numberOfWeeksController.text.trim()) ?? 0;

    if (amount > 0 && weeks > 0) {
      weeklyPayment.value = amount / weeks;
    } else {
      weeklyPayment.value = 0.0;
    }
  }

  bool validateSelectedDay() {
    final today = DateTime.now();

    const weekdays = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
    };

    final targetWeekday = weekdays[selectedDay.value]!;
    int daysToAdd = (targetWeekday - today.weekday + 7) % 7;
    if (daysToAdd == 0) daysToAdd = 7;

    if (daysToAdd <= 0) {
      Get.snackbar(
        'Invalid Day',
        'DATE YOU PICKED IS EXPIRED. Please pick a future weekday.',
      );
      return false;
    }
    return true;
  }

  List<DateTime> generateWeeklyPaymentDates({
    required String paymentDay,
    required int numberOfWeeks,
  }) {
    final today = DateTime.now();

    const weekdays = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
    };

    final targetWeekday = weekdays[paymentDay]!;
    int daysToAdd = (targetWeekday - today.weekday + 7) % 7;
    if (daysToAdd == 0) daysToAdd = 7;

    final firstPayment = today.add(Duration(days: daysToAdd));

    return List.generate(
      numberOfWeeks,
      (i) => firstPayment.add(Duration(days: i * 7)),
    );
  }

  void createWeeklyPlan() {
    final walletVM = Get.find<WalletViewModel>();

    final amount = double.tryParse(
          amountToSpreadController.text.replaceAll(',', ''),
        ) ??
        0;
    final weeks = int.tryParse(numberOfWeeksController.text) ?? 0;

    if (amount <= 0 || weeks <= 0) {
      Get.snackbar(
        'Invalid Input',
        'Please enter valid amount and number of weeks',
      );
      return;
    }

    if (!validateSelectedDay()) return;

    if (!walletVM.canDebit(amount)) {
      Get.snackbar('Error', 'Insufficient wallet balance');
      return;
    }

    final weeklyPay = amount / weeks;

    walletVM.debit(amount, 'Weekly Plan: ${planTitleController.text}');

    final plan = WeeklyPlan(
      id: DateTime.now().toIso8601String(),
      planTitle: planTitleController.text,
      amountToSpread: amount,
      numberOfWeeks: weeks,
      accountNumber: accountNumberController.text,
      accountName: accountNameController.text,
      bank: bankNameController.text,
      weeklyPayment: weeklyPay,
      paymentDay: selectedDay.value,
      paymentDates: generateWeeklyPaymentDates(
        paymentDay: selectedDay.value,
        numberOfWeeks: weeks,
      ),
    );

    plans.add(plan);
    clearForm();
  }

  void clearForm() {
    planTitleController.clear();
    amountToSpreadController.clear();
    numberOfWeeksController.clear();
    accountNumberController.clear();
    accountNameController.clear();
    bankNameController.clear();
    weeklyPayment.value = 0.0;
    selectedDay.value = 'Monday';
  }
}
