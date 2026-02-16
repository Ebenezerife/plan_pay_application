import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:plan_pay_application/views/home.dart';

import '../models/wallet_model.dart';
import '../models/transaction_model.dart';
import '../hive/wallet_adapter.dart';
import '../hive/transaction_adapter.dart';

class WalletViewModel extends GetxController {
  final walletBox = Hive.box<WalletHive>('walletBox');
  final txBox = Hive.box<TransactionHive>('transactionBox');

  var wallet = Wallet(balance: 0.0).obs;
  var transactions = <TransactionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadWallet();
    _loadTransactions();
  }

  void _loadWallet() {
    final saved = walletBox.get('wallet');
    if (saved != null) {
      wallet.value = Wallet(balance: saved.balance, currency: saved.currency);
    }
  }

  void _saveWallet() {
    walletBox.put(
      'wallet',
      WalletHive(
        balance: wallet.value.balance,
        currency: wallet.value.currency,
      ),
    );
  }

  void _loadTransactions() {
    transactions.value = txBox.values.map((e) => e.toModel()).toList();
  }

  void _saveTransaction(TransactionModel tx) {
    txBox.put(tx.id, TransactionHive.fromModel(tx));
  }

  void deposit(double amount) {
    wallet.update((w) => w!.balance += amount);
    _saveWallet();

    final tx = TransactionModel(
      id: DateTime.now().toIso8601String(),
      type: TransactionType.deposit,
      amount: amount,
      description: 'Wallet deposit',
      date: DateTime.now(),
    );

    transactions.add(tx);
    _saveTransaction(tx);
    Get.offAll(Home());
  }

  bool canDebit(double amount) => wallet.value.balance >= amount;

  void debit(double amount, String description) {
    if (!canDebit(amount)) {
      Get.snackbar('Insufficient Balance', 'Please fund your wallet');
      return;
    }

    wallet.update((w) => w!.balance -= amount);
    _saveWallet();

    final tx = TransactionModel(
      id: DateTime.now().toIso8601String(),
      type: TransactionType.debit,
      amount: amount,
      description: description,
      date: DateTime.now(),
    );

    transactions.add(tx);
    _saveTransaction(tx);
  }
}
