// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../currency_rate.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrencyRateAdapter extends TypeAdapter<CurrencyRate> {
  @override
  final int typeId = 0;

  @override
  CurrencyRate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrencyRate(
      currency: fields[0] as String,
      buy: fields[1] as String,
      sell: fields[2] as String,
      flagAsset: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CurrencyRate obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.currency)
      ..writeByte(1)
      ..write(obj.buy)
      ..writeByte(2)
      ..write(obj.sell)
      ..writeByte(3)
      ..write(obj.flagAsset);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyRateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
