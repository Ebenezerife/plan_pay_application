import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plan_pay_application/view_models/monthly_view_model.dart';
import 'package:plan_pay_application/view_models/weekly_view_model.dart';
import 'package:plan_pay_application/view_models/wallet_view_model.dart';
import 'package:plan_pay_application/models/transaction_model.dart';
import 'package:plan_pay_application/models/monthly_plan.dart';
import 'package:plan_pay_application/models/weekly_plan.dart';

class TransactionHistory extends StatefulWidget {
  TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  final WalletViewModel walletVM = Get.find();
  final MonthlyViewModel monthlyVM = Get.find();
  final WeeklyViewModel weeklyVM = Get.find();

  final DateFormat dateFormat = DateFormat('EEE, dd MMM yyyy');

  String selectedTab = 'Deposit'; // Default selected tab

  @override
  Widget build(BuildContext context) {
    Widget buildWalletTransactionCard(TransactionModel tx) {
      final color = tx.type == TransactionType.deposit
          ? Colors.green
          : Colors.red;
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          title: Text(
            tx.description,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(dateFormat.format(tx.date)),
          trailing: Text(
            '₦${tx.amount.toStringAsFixed(2)}',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    Widget buildPlanCardMonthly(MonthlyPlan plan) {
      final now = DateTime.now();
      final nextPayment = plan.paymentDates.firstWhere(
        (d) => !d.isBefore(now),
        orElse: () =>
            plan.paymentDates.isNotEmpty ? plan.paymentDates.last : now,
      );

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          title: Text(
            plan.planTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Amount: ₦${plan.amountToSpread.toStringAsFixed(2)}\n'
            'Duration: ${plan.numberOfMonths} months\n'
            'Next Payment: ${dateFormat.format(nextPayment)}',
          ),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Get.to(
              () => PlanDetailView(
                title: plan.planTitle,
                amount: plan.amountToSpread,
                duration: plan.numberOfMonths,
                durationLabel: 'Months',
                paymentDates: plan.paymentDates,
                accountName: plan.accountName,
                accountNumber: plan.accountNumber,
                bank: plan.bank,
              ),
            );
          },
        ),
      );
    }

    Widget buildPlanCardWeekly(WeeklyPlan plan) {
      final now = DateTime.now();
      final nextPayment = plan.paymentDates.firstWhere(
        (d) => !d.isBefore(now),
        orElse: () =>
            plan.paymentDates.isNotEmpty ? plan.paymentDates.last : now,
      );

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          title: Text(
            plan.planTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Amount: ₦${plan.amountToSpread.toStringAsFixed(2)}\n'
            'Duration: ${plan.numberOfWeeks} weeks\n'
            'Next Payment: ${dateFormat.format(nextPayment)}',
          ),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Get.to(
              () => PlanDetailView(
                title: plan.planTitle,
                amount: plan.amountToSpread,
                duration: plan.numberOfWeeks,
                durationLabel: 'Weeks',
                paymentDates: plan.paymentDates,
                accountName: plan.accountName,
                accountNumber: plan.accountNumber,
                bank: plan.bank,
              ),
            );
          },
        ),
      );
    }

    Widget buildTabButton(String tabName) {
      final isSelected = selectedTab == tabName;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => selectedTab = tabName),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green.shade300 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                tabName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      );
    }

    List<Widget> buildSelectedTabContent() {
      if (selectedTab == 'Deposit') {
        // Sort deposits by date descending (newest first)
        final sortedTx = walletVM.transactions.toList()
          ..sort((a, b) => b.date.compareTo(a.date));
        return sortedTx.map(buildWalletTransactionCard).toList();
      } else if (selectedTab == 'Monthly') {
        // Sort monthly plans by creation date descending
        final sortedMonthly = monthlyVM.plans.toList()
          ..sort(
            (a, b) => DateTime.parse(b.id).compareTo(DateTime.parse(a.id)),
          );
        return sortedMonthly.map(buildPlanCardMonthly).toList();
      } else if (selectedTab == 'Weekly') {
        // Sort weekly plans by creation date descending
        final sortedWeekly = weeklyVM.plans.toList()
          ..sort(
            (a, b) => DateTime.parse(b.id).compareTo(DateTime.parse(a.id)),
          );
        return sortedWeekly.map(buildPlanCardWeekly).toList();
      } else {
        return [];
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions & Plans'),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tabs row
            Row(
              children: [
                buildTabButton('Deposit'),
                const SizedBox(width: 8),
                buildTabButton('Weekly'),
                const SizedBox(width: 8),
                buildTabButton('Monthly'),
              ],
            ),
            const SizedBox(height: 16),
            // Tab content
            Expanded(
              child: Obx(() {
                final content = buildSelectedTabContent();
                if (content.isEmpty) {
                  return const Center(child: Text('No records available.'));
                }
                return ListView(children: content);
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// Detail view remains same as previous code
class PlanDetailView extends StatelessWidget {
  final String title;
  final double amount;
  final int duration;
  final String durationLabel;
  final List<DateTime> paymentDates;
  final String accountName;
  final String accountNumber;
  final String bank;

  final DateFormat dateFormat = DateFormat('EEE, dd MMM yyyy');

  PlanDetailView({
    super.key,
    required this.title,
    required this.amount,
    required this.duration,
    required this.durationLabel,
    required this.paymentDates,
    required this.accountName,
    required this.accountNumber,
    required this.bank,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final nextPayment = paymentDates.firstWhere(
      (d) => !d.isBefore(now),
      orElse: () => paymentDates.isNotEmpty ? paymentDates.last : now,
    );

    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.amberAccent),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount to Spread: ₦${amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              '$durationLabel: $duration',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Next Payment: ${dateFormat.format(nextPayment)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Account Name: $accountName'),
            Text('Account Number: $accountNumber'),
            Text('Bank: $bank'),
            const SizedBox(height: 20),
            const Text(
              'Upcoming Payment Dates:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: paymentDates.map((d) {
                  final isFuture = !d.isBefore(now);
                  return Text(
                    '- ${dateFormat.format(d)}',
                    style: TextStyle(
                      color: isFuture ? Colors.green : Colors.grey,
                      fontWeight: isFuture
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
