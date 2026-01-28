import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_pay_application/view_models/monthly_view_model.dart';
import 'package:plan_pay_application/view_models/wallet_view_model.dart';
import 'package:plan_pay_application/view_models/weekly_view_model.dart';
import 'package:plan_pay_application/views/home.dart';

void main() {
  Get.put(MonthlyViewModel());
  Get.put(WeeklyViewModel());
  Get.put(WalletViewModel());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Plan Pay Application',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}
