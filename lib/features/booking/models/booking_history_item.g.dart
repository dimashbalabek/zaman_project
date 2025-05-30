// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/booking_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingHistoryItemAdapter extends TypeAdapter<BookingHistoryItem> {
  @override
  final int typeId = 1;

  @override
  BookingHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingHistoryItem(
      id: fields[0] as String,
      currency: fields[1] as String,
      amount: fields[2] as String,
      exchangePoint: fields[3] as String,
      createdAt: fields[4] as DateTime,
      expiresAt: fields[5] as DateTime,
      name: fields[6] as String,
      email: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookingHistoryItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.currency)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.exchangePoint)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.expiresAt)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
