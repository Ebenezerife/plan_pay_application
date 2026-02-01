// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_plan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MonthlyPlanAdapter extends TypeAdapter<MonthlyPlan> {
  @override
  final int typeId = 2;

  @override
  MonthlyPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MonthlyPlan(
      id: fields[0] as String,
      planTitle: fields[1] as String,
      amountToSpread: fields[2] as double,
      numberOfMonths: fields[3] as int,
      accountNumber: fields[4] as String,
      accountName: fields[5] as String,
      bank: fields[6] as String,
      monthlyPayment: fields[7] as double,
      preferredDate: fields[8] as String,
      paymentDates: (fields[9] as List).cast<DateTime>(),
    );
  }

  @override
  void write(BinaryWriter writer, MonthlyPlan obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.planTitle)
      ..writeByte(2)
      ..write(obj.amountToSpread)
      ..writeByte(3)
      ..write(obj.numberOfMonths)
      ..writeByte(4)
      ..write(obj.accountNumber)
      ..writeByte(5)
      ..write(obj.accountName)
      ..writeByte(6)
      ..write(obj.bank)
      ..writeByte(7)
      ..write(obj.monthlyPayment)
      ..writeByte(8)
      ..write(obj.preferredDate)
      ..writeByte(9)
      ..write(obj.paymentDates);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
