import 'package:hive/hive.dart';
part 'wallet_adapter.g.dart';

@HiveType(typeId: 1)
class WalletHive extends HiveObject {
  @HiveField(0)
  double balance;

  @HiveField(1)
  String currency;

  WalletHive({required this.balance, required this.currency});
}
