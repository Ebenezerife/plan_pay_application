// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionHiveAdapter extends TypeAdapter<TransactionHive> {
  @override
  final int typeId = 0;

  @override
  TransactionHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionHive(
      id: fields[0] as String,
      type: fields[1] as int,
      amount: fields[2] as double,
      description: fields[3] as String,
      date: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
