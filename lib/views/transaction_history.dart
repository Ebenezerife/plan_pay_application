import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_pay_application/view_models/monthly_view_model.dart';
import 'package:plan_pay_application/view_models/weekly_view_model.dart';

class TransactionHistory extends StatelessWidget {
  final MonthlyViewModel _monthlyViewModel = Get.put(MonthlyViewModel());
  final WeeklyViewModel _weeklyViewModel = Get.put(WeeklyViewModel());
  TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transaction History')),
      body: ListView(
        children: [
          ..._monthlyViewModel.plans.map(
            (monthlyPlan) => ListTile(
              title: Text(monthlyPlan.planTitle),
              subtitle: Text('Monthly Payment: ${monthlyPlan.monthlyPayment}'),
            ),
          ),
          ..._weeklyViewModel.plans.map(
            (weeklyPlan) => ListTile(
              title: Text('Weekly Payment: ${weeklyPlan.weeklyPayment}'),
            ),
          ),
        ],
      ),
    );
  }
}
