import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_pay_application/models/weekly_plan.dart';
import 'package:plan_pay_application/views/home.dart';

class WeeklyViewModel extends GetxController {
  var plans = <WeeklyPlan>[].obs;
  var planTitleController = TextEditingController();
  var amountToSpreadController = TextEditingController();
  var numberOfWeeksController = TextEditingController();
  var accountNumberController = TextEditingController();
  var accountNameController = TextEditingController();
  var bankNameController = TextEditingController();
  var weeklyPayment = 0.0.obs;
  // var paymentDay = ''.obs;
  var paymentDay = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ].obs; // new

  var selectedPayDay = 'Monday'.obs; // new

  void onCreatePlanClicked() {
    // rest form fields
    planTitleController.clear();
    amountToSpreadController.clear();
    numberOfWeeksController.clear();
    accountNumberController.clear();
    accountNameController.clear();
    bankNameController.clear();
    weeklyPayment.value = 0.0;
    selectedPayDay.value = 'Monday';
    // navigate to home page
    Get.offAll(
      () => Home(),
    ); // navigate to home and remove previous routes NOTE i removed the Get.back(), Get.Off(), i tried and used Get.offAll(() => Home()) instead
  }

  void createWeeklyPlan() {
    double amountToSpread = double.parse(amountToSpreadController.text);
    int numberOfWeeks = int.parse(numberOfWeeksController.text);
    double weeklyPayment = amountToSpread / numberOfWeeks;

    WeeklyPlan weeklyPlan = WeeklyPlan(
      id: DateTime.now().toString(),
      planTitle: planTitleController.text,
      amountToSpread: amountToSpread,
      numberOfWeeks: numberOfWeeks,
      accountNumber: accountNumberController.text,
      accountName: accountNameController.text,
      bank: bankNameController.text,
      weeklyPayment: weeklyPayment,
      paymentDay: selectedPayDay
          .value, // new paymentDay.value was changed to selectedPayDay.value
    );
    plans.add(weeklyPlan);
  }

  void calculateWeeklyPayment() {
    if (amountToSpreadController.text.isNotEmpty &&
        numberOfWeeksController.text.isNotEmpty) {
      double amountToSpread = double.parse(amountToSpreadController.text);
      int numberOfMonths = int.parse(numberOfWeeksController.text);
      weeklyPayment.value = amountToSpread / numberOfMonths;
    }
  }

  // void selectedPaymentDay(String day) {
  //   paymentDay.value = day;
  // }
}
