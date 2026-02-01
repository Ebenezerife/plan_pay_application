// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletHiveAdapter extends TypeAdapter<WalletHive> {
  @override
  final int typeId = 1;

  @override
  WalletHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalletHive(
      balance: fields[0] as double,
      currency: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WalletHive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.balance)
      ..writeByte(1)
      ..write(obj.currency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
