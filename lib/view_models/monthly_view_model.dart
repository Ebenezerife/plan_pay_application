import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_pay_application/models/monthly_plan.dart';

class MonthlyViewModel extends GetxController {
  var plans = <MonthlyPlan>[].obs;
  var planTitleController = TextEditingController();
  var amountToSpreadController = TextEditingController();
  var numberOfMonthsController = TextEditingController();
  var accountNumberController = TextEditingController();
  var accountNameController = TextEditingController();
  var bankNameController = TextEditingController();
  var monthlyPayment = 0.0.obs;
  var preferredDate = ''.obs;

  void createMonthlyPlan() {
    double amountToSpread = double.parse(amountToSpreadController.text);
    int numberOfMonths = int.parse(numberOfMonthsController.text);
    double monthlyPayment = amountToSpread / numberOfMonths;

    MonthlyPlan plan = MonthlyPlan(
      id: DateTime.now().toString(),
      planTitle: planTitleController.text,
      amountToSpread: amountToSpread,
      numberOfMonths: numberOfMonths,
      accountNumber: accountNumberController.text,
      accountName: accountNameController.text,
      bank: bankNameController.text,
      monthlyPayment: monthlyPayment,
      preferredDate: preferredDate.value,
    );
    plans.add(plan);
  }

  void calculateMonthlyPayment() {
    if (amountToSpreadController.text.isNotEmpty &&
        numberOfMonthsController.text.isNotEmpty) {
      double amountToSpread = double.parse(amountToSpreadController.text);
      int numberOfMonths = int.parse(numberOfMonthsController.text);
      monthlyPayment.value = amountToSpread / numberOfMonths;
    }
  }

  void selectPreferredDate(String date) {
    preferredDate.value = date;
  }

  Future<void> showDatePickerDialog() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      firstDate: DateTime(1),
      initialDate: DateTime(1),
      lastDate: DateTime(31),
    );
    if (pickedDate != null) {
      preferredDate.value = pickedDate.day.toString();
    }
  }
}
