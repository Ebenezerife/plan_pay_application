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
      appBar: AppBar(
        title: Text(
          'TRANSACTION HISTORY',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            color: Colors.green,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      body: ListView(
        children: [
          ..._monthlyViewModel.plans.map(
            (monthlyPlan) => ListTile(
              title: Text(monthlyPlan.planTitle),
              subtitle: Text('Monthly Payment: ${monthlyPlan.monthlyPayment}'),
              trailing: Text('Date Created: ${monthlyPlan.id}'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Monthly Plan Details'),
                      content: Text(
                        'Plan Title: ${monthlyPlan.planTitle}\nAmount To Spread: ${monthlyPlan.amountToSpread}\nNumber Of Months: ${monthlyPlan.numberOfMonths}\nAccount Number: ${monthlyPlan.accountNumber}\nAccount Name: ${monthlyPlan.accountName}\nBank: ${monthlyPlan.bank}\nMonthly Payment: ${monthlyPlan.monthlyPayment}\nPreferred Pay Date: ${monthlyPlan.preferredDate}',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
                // You can add functionality here to view more details about the plan
              },
            ),
          ),
          ..._weeklyViewModel.plans.map(
            (weeklyPlan) => ListTile(
              title: Text(weeklyPlan.planTitle),
              subtitle: Text('Weekly Payment: ${weeklyPlan.weeklyPayment}'),
              trailing: Text('Date Created: ${weeklyPlan.id}'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Weekly Plan Details'),
                      content: Text(
                        'Plan Title: ${weeklyPlan.planTitle}\nAmount To Spread: ${weeklyPlan.amountToSpread}\nNumber Of Weeks: ${weeklyPlan.numberOfWeeks}\nAccount Number: ${weeklyPlan.accountNumber}\nAccount Name: ${weeklyPlan.accountName}\nBank: ${weeklyPlan.bank}\nWeekly Payment: ${weeklyPlan.weeklyPayment}\nPayment Day: ${weeklyPlan.paymentDay}',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
                // You can add functionality here to view more details about the plan
              },
            ),
          ),
        ],
      ),
    );
  }
}
