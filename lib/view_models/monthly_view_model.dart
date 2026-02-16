import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:plan_pay_application/models/bank.dart';
import 'package:plan_pay_application/models/monthly_plan.dart';
import 'package:plan_pay_application/services/bank_api_service.dart';
import 'package:plan_pay_application/view_models/wallet_view_model.dart';
import 'package:plan_pay_application/views/home.dart';

class MonthlyViewModel extends GetxController {
  final bankService = BankApiService();

  /// Banks loaded dynamically from backend
  final banks = <Bank>[].obs;
  final isCreatingPlan = false.obs;

  /// Plans
  final plans = <MonthlyPlan>[].obs;

  /// Controllers (single source of truth)
  final planTitleController = TextEditingController();
  final amountToSpreadController = TextEditingController();
  final numberOfMonthsController = TextEditingController();
  final accountNumberController = TextEditingController();
  final accountNameController = TextEditingController();
  final bankNameController = TextEditingController();

  /// Bank verification
  final selectedBank = Rxn<Bank>();
  final isFetchingAccountName = false.obs;

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
    final box = Hive.box<MonthlyPlan>('monthly_plans');
    plans.assignAll(box.values);

    amountToSpreadController.addListener(calculateMonthlyPayment);
    numberOfMonthsController.addListener(calculateMonthlyPayment);

    _updateAllowedMonths();
    ever(selectedDay, (_) => _updateAllowedMonths());

    loadBanks();
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

  /// Load banks dynamically from backend
  Future<void> loadBanks() async {
    if (banks.isNotEmpty) return;
    try {
      final fetchedBanks = await bankService.getBanks();
      banks.value = fetchedBanks;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load banks: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Calculate monthly payment
  void calculateMonthlyPayment() {
    final amount =
        double.tryParse(
          amountToSpreadController.text.replaceAll(',', '').trim(),
        ) ??
        0;
    final months = int.tryParse(numberOfMonthsController.text.trim()) ?? 0;
    monthlyPayment.value = (amount > 0 && months > 0) ? amount / months : 0.0;
  }

  void _updateAllowedMonths() {
    final today = DateTime.now();
    final day = int.parse(selectedDay.value);
    final List<DateTime> months = [];

    for (int i = 0; i < 24; i++) {
      int month = ((today.month - 1 + i) % 12) + 1;
      int year = today.year + ((today.month - 1 + i) ~/ 12);

      if (!(month == today.month && day <= today.day)) {
        months.add(DateTime(year, month));
      }
    }

    allowedMonths.value = months;

    if (!allowedMonths.any(
      (m) =>
          m.month == selectedMonth.value.month &&
          m.year == selectedMonth.value.year,
    )) {
      selectedMonth.value = allowedMonths.first;
    }
  }

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

  /// Fetch account name from backend API
  Future<void> fetchAccountName() async {
    final accountNumber = accountNumberController.text.trim();
    final bank = selectedBank.value;

    if (accountNumber.isEmpty || bank == null) {
      accountNameController.text = '';
      return;
    }

    if (accountNumber.length < 10) {
      accountNameController.text = 'Account number too short';
      return;
    }

    try {
      isFetchingAccountName.value = true;
      final name = await bankService.resolveAccount(
        accountNumber: accountNumber,
        bankCode: bank.code,
      );
      accountNameController.text = name;
      bankNameController.text = bank.name;
    } catch (e) {
      accountNameController.text = 'Failed to resolve account';
      bankNameController.text = '';
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isFetchingAccountName.value = false;
    }
  }

  Future<void> createMonthlyPlan() async {
    if (isCreatingPlan.value) return;
    isCreatingPlan.value = true;
    try {
      final walletVM = Get.find<WalletViewModel>();
      final amount =
          double.tryParse(
            amountToSpreadController.text.replaceAll(',', '').trim(),
          ) ??
          0;
      final months = int.tryParse(numberOfMonthsController.text.trim()) ?? 0;

      if (amount <= 0 ||
          months <= 0 ||
          planTitleController.text.trim().isEmpty) {
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
      Hive.box<MonthlyPlan>('monthly_plans').add(plan);
      Get.snackbar('Success', 'Monthly plan created successfully');
      Get.offAll(Home());
    } finally {
      isCreatingPlan.value = false;
    }
  }

  void clearForm() {
    planTitleController.clear();
    amountToSpreadController.clear();
    numberOfMonthsController.clear();
    accountNumberController.clear();
    accountNameController.clear();
    bankNameController.clear();

    monthlyPayment.value = 0.0;
    selectedDay.value = '1';
    selectedBank.value = null;

    _updateAllowedMonths();
    if (allowedMonths.isNotEmpty) selectedMonth.value = allowedMonths.first;
  }
}
