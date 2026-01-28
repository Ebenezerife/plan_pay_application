import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_pay_application/utilities/currency_formatter.dart';
import 'package:plan_pay_application/utilities/ngn_text_field.dart';
import 'package:plan_pay_application/view_models/wallet_view_model.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  double depositAmount = 0;

  double getDepositAmount() {
    final text = amountController.text;
    final numericString = text.replaceAll(RegExp(r'[^0-9]'), '');
    return numericString.isEmpty ? 0 : double.parse(numericString);
  }

  final WalletViewModel walletVM = Get.find();

  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fund Wallet'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet Balance
            Obx(
              () => Container(
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
                      CurrencyFormatter.format(walletVM.wallet.value.balance),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Text(
                    //   '₦${walletVM.wallet.value.balance.toStringAsFixed(2)}',
                    //   style: const TextStyle(
                    //     fontSize: 24,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.green,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Amount Input
            // TextField(
            //   keyboardType: TextInputType.number,
            //   inputFormatters: [
            //     MoneyInputFormatter(
            //       leadingSymbol: '₦',
            //       useSymbolPadding: true,
            //       thousandSeparator: ThousandSeparator.Comma,
            //       mantissaLength: 0, // 0 for whole Naira only, 2 for kobo
            //     ),
            //   ],
            //   decoration: InputDecoration(
            //     labelText: 'Deposit Amount (NGN)',
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //   ),
            //   onChanged: (text) {
            //     // Remove ₦ and commas, then parse
            //     final numericString = text.replaceAll(RegExp(r'[^0-9]'), '');
            //     depositAmount = numericString.isEmpty
            //         ? 0
            //         : double.parse(numericString);
            //   },
            // ),
            // TextField(
            //   keyboardType: TextInputType.number,
            //   inputFormatters: [
            //     MoneyInputFormatter(
            //       leadingSymbol: '₦',
            //       thousandSeparator: ThousandSeparator.Comma,
            //       mantissaLength: 0, // 0 for whole Naira
            //       trailingSymbol: '', // optional
            //       useSymbolPadding: true,
            //     ),
            //   ],
            //   decoration: InputDecoration(
            //     labelText: 'Deposit Amount (NGN)',
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //   ),
            //   onChanged: (text) {
            //     // Remove ₦ and commas, parse double
            //     final numericString = text.replaceAll(RegExp(r'[^0-9]'), '');
            //     depositAmount = numericString.isEmpty
            //         ? 0
            //         : double.parse(numericString);
            //   },
            // ),
            // TextField(
            //   controller: amountController,
            //   keyboardType: TextInputType.number,
            //   inputFormatters: [
            //     CurrencyInputFormatter(
            //       leadingSymbol: '₦',
            //       thousandSeparator: ThousandSeparator.Comma,
            //       mantissaLength: 0, // 0 for whole Naira, 2 if you want kobo
            //       useSymbolPadding: true,
            //       onValueChange: (value) {
            //         // This gives the numeric value directly
            //        depositAmount = value;
            //       },
            //     ),
            //   ],
            //   decoration: InputDecoration(
            //     labelText: 'Deposit Amount (NGN)',
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //   ),
            // ),
            NGNInputField(
              controller: amountController,
              labelText: 'Deposit Amount (NGN)',
              onChanged: (value) {
                depositAmount = value;
              },
            ),
            // NGNTextField(
            //   labelText: 'Deposit Amount (NGN)',
            //   onChanged: (amount) {
            //     depositAmount = amount;
            //   },
            // ),

            // TextField(
            //   controller: amountController,
            //   keyboardType: TextInputType.number,
            //   decoration: InputDecoration(
            //     labelText: 'Deposit Amount (NGN)',
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 24),

            // Deposit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  double depositAmount = getDepositAmount();
                  if (depositAmount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter an amount')),
                    );
                    return;
                  }

                  walletVM.deposit(depositAmount);

                  // Clear the field
                  amountController.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Deposited ₦${depositAmount.toInt()}'),
                    ),
                  );
                },
                child: const Text('Deposit'),
              ),

              // ElevatedButton(
              //   onPressed: () {
              //     if (depositAmount <= 0) {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(content: Text('Please enter an amount')),
              //       );
              //       return;
              //     }

              //     walletVM.deposit(depositAmount);
              //     // Clear the field
              //     amountController.clear(); // ✅ clears the textfield

              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(
              //         content: Text('Deposited ₦${depositAmount.toInt()}'),
              //       ),
              //     );

              //     depositAmount = 0;
              //   },
              //   child: const Text('Deposit'),
              // ),

              // ElevatedButton(
              //   onPressed: () {
              //     if (amountController.text.isEmpty) {
              //       Get.snackbar('Error', 'Please enter an amount');
              //       return;
              //     }

              //     final amount = double.tryParse(amountController.text);

              //     if (amount == null || amount <= 0) {
              //       Get.snackbar('Invalid Amount', 'Enter a valid amount');
              //       return;
              //     }

              //     walletVM.deposit(amount);
              //     amountController.clear();

              //     Get.snackbar(
              //       'Success',
              //       'Wallet funded successfully',
              //       backgroundColor: Colors.green,
              //       colorText: Colors.white,
              //     );
              //   },
              //   child: const Text('Deposit'),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
