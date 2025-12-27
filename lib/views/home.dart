import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_pay_application/views/monthly_plan_view.dart';
import 'package:plan_pay_application/views/transaction_history.dart';
import 'package:plan_pay_application/views/weekly_plan_view.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome To Plan Pay',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            color: Colors.green,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.to(MonthlyPlanView());
              },
              child: Text('Create Monthly Plan'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(WeeklyPlanView());
              },
              child: Text('Create Weekly Plan'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(TransactionHistory());
              },
              child: Text('Transcation History'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
