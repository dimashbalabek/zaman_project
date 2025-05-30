import 'package:hive/hive.dart';

part 'features/home/hive/currency_rate.g.dart'; // генерируется автоматически!

@HiveType(typeId: 0)
class CurrencyRate extends HiveObject {
  @HiveField(0)
  final String currency;
  @HiveField(1)
  final String buy;
  @HiveField(2)
  final String sell;
  @HiveField(3)
  final String flagAsset;

  CurrencyRate({
    required this.currency,
    required this.buy,
    required this.sell,
    required this.flagAsset,
  });
}
