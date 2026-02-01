import 'package:hive/hive.dart';
import '../models/transaction_model.dart';

part 'transaction_adapter.g.dart';

@HiveType(typeId: 0)
class TransactionHive extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  int type; // enum index

  @HiveField(2)
  double amount;

  @HiveField(3)
  String description;

  @HiveField(4)
  DateTime date;

  TransactionHive({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
  });

  TransactionModel toModel() => TransactionModel(
        id: id,
        type: TransactionType.values[type],
        amount: amount,
        description: description,
        date: date,
      );

  static TransactionHive fromModel(TransactionModel tx) {
    return TransactionHive(
      id: tx.id,
      type: tx.type.index,
      amount: tx.amount,
      description: tx.description,
      date: tx.date,
    );
  }
}
