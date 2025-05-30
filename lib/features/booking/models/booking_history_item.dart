import 'package:hive/hive.dart';

part '../../booking/models/booking_history_item.g.dart';

@HiveType(typeId: 1)
class BookingHistoryItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String currency;

  @HiveField(2)
  String amount;

  @HiveField(3)
  String exchangePoint;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime expiresAt;

  @HiveField(6)
  String name;

  @HiveField(7)
  String email;

  BookingHistoryItem({
    required this.id,
    required this.currency,
    required this.amount,
    required this.exchangePoint,
    required this.createdAt,
    required this.expiresAt,
    required this.name,
    required this.email,
  });
}
