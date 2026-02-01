// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_plan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeeklyPlanAdapter extends TypeAdapter<WeeklyPlan> {
  @override
  final int typeId = 3;

  @override
  WeeklyPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeeklyPlan(
      id: fields[0] as String,
      planTitle: fields[1] as String,
      amountToSpread: fields[2] as double,
      numberOfWeeks: fields[3] as int,
      accountNumber: fields[4] as String,
      accountName: fields[5] as String,
      bank: fields[6] as String,
      weeklyPayment: fields[7] as double,
      paymentDay: fields[8] as String,
      paymentDates: (fields[9] as List).cast<DateTime>(),
    );
  }

  @override
  void write(BinaryWriter writer, WeeklyPlan obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.planTitle)
      ..writeByte(2)
      ..write(obj.amountToSpread)
      ..writeByte(3)
      ..write(obj.numberOfWeeks)
      ..writeByte(4)
      ..write(obj.accountNumber)
      ..writeByte(5)
      ..write(obj.accountName)
      ..writeByte(6)
      ..write(obj.bank)
      ..writeByte(7)
      ..write(obj.weeklyPayment)
      ..writeByte(8)
      ..write(obj.paymentDay)
      ..writeByte(9)
      ..write(obj.paymentDates);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
