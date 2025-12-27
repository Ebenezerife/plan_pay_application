import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_pay_application/models/monthly_plan.dart';
import 'package:plan_pay_application/views/home.dart';

class MonthlyViewModel extends GetxController {
  var plans = <MonthlyPlan>[].obs;
  var planTitleController = TextEditingController();
  var amountToSpreadController = TextEditingController();
  var numberOfMonthsController = TextEditingController();
  var accountNumberController = TextEditingController();
  var accountNameController = TextEditingController();
  var bankNameController = TextEditingController();
  var monthlyPayment = 0.0.obs;
  // var preferredDate = ''.obs;
  var preferredDate = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
  ].obs; // new
  var selectedPayDate = '1'.obs; // new
  void onCreatePlanPressed() {
    // rest form fields
    planTitleController.clear();
    amountToSpreadController.clear();
    numberOfMonthsController.clear();
    accountNumberController.clear();
    accountNameController.clear();
    bankNameController.clear();
    monthlyPayment.value = 0.0;
    selectedPayDate.value = '1';
    // navigate to home page
    Get.offAll(
      () => Home(),
    ); // navigate to home and remove previous routes NOTE i removed the Get.back(), Get.Off(), i tried and used Get.offAll(() => Home()) instead
  }

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
      preferredDate: selectedPayDate.value,
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

  // void selectPreferredDate(String date) {
  //   preferredDate.value = date;
  // }

  // Future<void> showDatePickerDialog() async {
  //   DateTime? pickedDate = await showDatePicker(
  //     context: Get.context!,
  //     firstDate: DateTime(1),
  //     initialDate: DateTime(1),
  //     lastDate: DateTime(31),
  //   );
  //   if (pickedDate != null) {
  //     preferredDate.value = pickedDate.day.toString();
  //   }
  // }
}
