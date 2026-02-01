import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:plan_pay_application/models/bank.dart';
import 'package:plan_pay_application/models/weekly_plan.dart';
import 'package:plan_pay_application/services/bank_api_service.dart';
import 'package:plan_pay_application/view_models/wallet_view_model.dart';

class WeeklyViewModel extends GetxController {
  final bankService = BankApiService();

  /// Banks loaded dynamically from backend
  final banks = <Bank>[].obs;

  /// Plans
  final plans = <WeeklyPlan>[].obs;

  /// Controllers (single source of truth)
  final planTitleController = TextEditingController();
  final amountToSpreadController = TextEditingController();
  final numberOfWeeksController = TextEditingController();
  final accountNumberController = TextEditingController();
  final accountNameController = TextEditingController();
  final bankNameController = TextEditingController();

  /// Bank verification
  final selectedBank = Rxn<Bank>();
  final isFetchingAccountName = false.obs;

  /// Computed values
  final weeklyPayment = 0.0.obs;

  /// Day selection
  final selectedDay = 'Monday'.obs;
  final allowedDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  void onInit() {
    super.onInit();
    final box = Hive.box<WeeklyPlan>('weekly_plans');
    plans.assignAll(box.values);
    amountToSpreadController.addListener(calculateWeeklyPayment);
    numberOfWeeksController.addListener(calculateWeeklyPayment);

    loadBanks();
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

  /// Calculate weekly payment
  void calculateWeeklyPayment() {
    final amount =
        double.tryParse(
          amountToSpreadController.text.replaceAll(',', '').trim(),
        ) ??
        0;
    final weeks = int.tryParse(numberOfWeeksController.text.trim()) ?? 0;
    weeklyPayment.value = (amount > 0 && weeks > 0) ? amount / weeks : 0.0;
  }

  /// Generate weekly payment dates
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

  /// Create weekly plan
  void createWeeklyPlan() {
    final walletVM = Get.find<WalletViewModel>();
    final amount =
        double.tryParse(
          amountToSpreadController.text.replaceAll(',', '').trim(),
        ) ??
        0;
    final weeks = int.tryParse(numberOfWeeksController.text.trim()) ?? 0;

    if (amount <= 0 || weeks <= 0) {
      Get.snackbar('Error', 'Please fill in all required fields correctly');
      return;
    }

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
    Hive.box<WeeklyPlan>('weekly_plans').add(plan);
    Get.snackbar('Success', 'Weekly plan created successfully');
  }

  /// Clear form
  void clearForm() {
    planTitleController.clear();
    amountToSpreadController.clear();
    numberOfWeeksController.clear();
    accountNumberController.clear();
    accountNameController.clear();
    bankNameController.clear();

    weeklyPayment.value = 0.0;
    selectedDay.value = 'Monday';
    selectedBank.value = null;
  }
}
