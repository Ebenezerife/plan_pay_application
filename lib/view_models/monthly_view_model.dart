import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_pay_application/models/monthly_plan.dart';
import 'package:plan_pay_application/view_models/wallet_view_model.dart';

class MonthlyViewModel extends GetxController {
  /// Plans
  final plans = <MonthlyPlan>[].obs;

  /// Controllers (single source of truth)
  final planTitleController = TextEditingController();
  final amountToSpreadController = TextEditingController();
  final numberOfMonthsController = TextEditingController();
  final accountNumberController = TextEditingController();
  final accountNameController = TextEditingController();
  final bankNameController = TextEditingController();

  /// Computed values
  final monthlyPayment = 0.0.obs;

  /// Date selection
  final selectedDay = '1'.obs;
  final selectedMonth = DateTime.now().obs;

  final List<String> allowedDays = List.generate(
    25,
    (index) => (index + 1).toString(),
  );

  final allowedMonths = <DateTime>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Auto-calculate payment when inputs change
    amountToSpreadController.addListener(calculateMonthlyPayment);
    numberOfMonthsController.addListener(calculateMonthlyPayment);

    _updateAllowedMonths();
    ever(selectedDay, (_) => _updateAllowedMonths());
  }

  @override
  void onClose() {
    planTitleController.dispose();
    amountToSpreadController.dispose();
    numberOfMonthsController.dispose();
    accountNumberController.dispose();
    accountNameController.dispose();
    bankNameController.dispose();
    super.onClose();
  }

  /// ✅ Calculate monthly payment (comma-safe)
  void calculateMonthlyPayment() {
    final amount =
        double.tryParse(
          amountToSpreadController.text.replaceAll(',', '').trim(),
        ) ??
        0;

    final months = int.tryParse(numberOfMonthsController.text.trim()) ?? 0;

    if (amount > 0 && months > 0) {
      monthlyPayment.value = amount / months;
    } else {
      monthlyPayment.value = 0.0;
    }
  }

  /// Update allowed months based on today's date and selected day
  void _updateAllowedMonths() {
    final today = DateTime.now();
    final day = int.parse(selectedDay.value);

    final List<DateTime> months = [];

    for (int i = 0; i < 24; i++) {
      int month = ((today.month - 1 + i) % 12) + 1;
      int year = today.year + ((today.month - 1 + i) ~/ 12);

      // Skip current month if selected day already passed
      if (!(month == today.month && day <= today.day)) {
        months.add(DateTime(year, month));
      }
    }

    allowedMonths.value = months;

    // Reset selected month if invalid
    if (!allowedMonths.any(
      (m) =>
          m.month == selectedMonth.value.month &&
          m.year == selectedMonth.value.year,
    )) {
      selectedMonth.value = allowedMonths.first;
    }
  }

  /// Generate payment dates
  List<DateTime> generateMonthlyPaymentDates({
    required int preferredDay,
    required int numberOfMonths,
  }) {
    final List<DateTime> dates = [];

    int firstMonth = selectedMonth.value.month;
    int firstYear = selectedMonth.value.year;

    for (int i = 0; i < numberOfMonths; i++) {
      int month = firstMonth + i;
      int year = firstYear + (month - 1) ~/ 12;
      month = ((month - 1) % 12) + 1;

      dates.add(DateTime(year, month, preferredDay));
    }

    return dates;
  }

  /// ✅ Create plan (comma-safe)
  void createMonthlyPlan() {
    final walletVM = Get.find<WalletViewModel>();

    final amount =
        double.tryParse(
          amountToSpreadController.text.replaceAll(',', '').trim(),
        ) ??
        0;

    final months = int.tryParse(numberOfMonthsController.text.trim()) ?? 0;

    if (amount <= 0 || months <= 0) {
      Get.snackbar('Error', 'Please fill in all required fields correctly');
      return;
    }

    if (!walletVM.canDebit(amount)) {
      Get.snackbar('Error', 'Insufficient wallet balance');
      return;
    }

    final monthlyPay = amount / months;

    walletVM.debit(amount, 'Monthly Plan: ${planTitleController.text}');

    final plan = MonthlyPlan(
      id: DateTime.now().toIso8601String(),
      planTitle: planTitleController.text,
      amountToSpread: amount,
      numberOfMonths: months,
      accountNumber: accountNumberController.text,
      accountName: accountNameController.text,
      bank: bankNameController.text,
      monthlyPayment: monthlyPay,
      preferredDate: selectedDay.value,
      paymentDates: generateMonthlyPaymentDates(
        preferredDay: int.parse(selectedDay.value),
        numberOfMonths: months,
      ),
    );

    plans.add(plan);
    clearForm();
  }

  /// Reset form
  void clearForm() {
    planTitleController.clear();
    amountToSpreadController.clear();
    numberOfMonthsController.clear();
    accountNumberController.clear();
    accountNameController.clear();
    bankNameController.clear();

    monthlyPayment.value = 0.0;
    selectedDay.value = '1';

    _updateAllowedMonths(); // recompute allowed months
    if (allowedMonths.isNotEmpty) {
      selectedMonth.value = allowedMonths.first; // reset Start Month
    }
  }
}
