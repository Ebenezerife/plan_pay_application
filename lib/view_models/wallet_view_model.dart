import 'package:get/get.dart';
import 'package:plan_pay_application/models/transaction_model.dart';
import 'package:plan_pay_application/models/wallet_model.dart';

class WalletViewModel extends GetxController {
  var wallet = Wallet(balance: 0.0).obs;
  var transactions = <TransactionModel>[].obs;

  void deposit(double amount) {
    wallet.update((w) => w!.balance += amount);

    transactions.add(
      TransactionModel(
        id: DateTime.now().toString(),
        type: TransactionType.deposit,
        amount: amount,
        description: 'Wallet deposit',
        date: DateTime.now(),
      ),
    );
  }

  bool canDebit(double amount) => wallet.value.balance >= amount;

  void debit(double amount, String description) {
    if (!canDebit(amount)) {
      Get.snackbar('Insufficient Balance', 'Please fund your wallet');
      return;
    }

    wallet.update((w) => w!.balance -= amount);

    transactions.add(
      TransactionModel(
        id: DateTime.now().toString(),
        type: TransactionType.debit,
        amount: amount,
        description: description,
        date: DateTime.now(),
      ),
    );
  }
}
