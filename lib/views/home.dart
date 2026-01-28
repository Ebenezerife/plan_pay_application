import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plan_pay_application/view_models/monthly_view_model.dart';
import 'package:plan_pay_application/view_models/wallet_view_model.dart';
import 'package:plan_pay_application/view_models/weekly_view_model.dart';
import 'package:plan_pay_application/views/deposit_screen.dart';
import 'package:plan_pay_application/views/monthly_plan_view.dart';
import 'package:plan_pay_application/views/transaction_history.dart';
import 'package:plan_pay_application/views/weekly_plan_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final WalletViewModel walletVM = Get.find();
  final MonthlyViewModel monthlyVM = Get.find();
  final WeeklyViewModel weeklyVM = Get.find();

  // Number formatter for Naira currency
  final NumberFormat nairaFormat = NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
    decimalDigits: 2,
  );

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
            // Wallet Balance
            Obx(
              () {
                final balance = walletVM.wallet.value.balance;
                final formattedBalance = nairaFormat.format(balance);

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Wallet Balance',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        formattedBalance, // Use formatted balance
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Get.to(() => DepositScreen());
              },
              child: const Text('Fund Wallet'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(MonthlyPlanView());
              },
              child: const Text('Create Monthly Plan'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(WeeklyPlanView());
              },
              child: const Text('Create Weekly Plan'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(TransactionHistory());
              },
              child: const Text('Transaction History'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
