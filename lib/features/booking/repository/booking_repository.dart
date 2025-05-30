import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import '../models/booking_history_item.dart';

class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Box<BookingHistoryItem> _box =
      Hive.box<BookingHistoryItem>('bookingHistoryBox');

  Future<void> fetchAndSaveFromFirebase(String userId) async {
    final docSnapshot = await _firestore.collection('users').doc(userId).get();

    if (!docSnapshot.exists) {
      await _box.clear();
      return;
    }

    final rawData = docSnapshot.data();
    if (rawData == null) {
      await _box.clear();
      return;
    }

    await _box.clear();

    final List<dynamic>? bookingList =
        rawData['bookingHistory'] as List<dynamic>?;

    if (bookingList == null || bookingList.isEmpty) {
      return;
    }

    for (int index = 0; index < bookingList.length; index++) {
      final entry = bookingList[index] as Map<String, dynamic>;

      final String id = '$userId-$index';

      final currency = entry['currency'] as String? ?? '';
      final amount = entry['amount'] as String? ?? '';
      final exchangePoint = entry['exchangePoint'] as String? ?? '';

      DateTime createdAt;
      final rawCreated = entry['createdAt'];
      if (rawCreated is Timestamp) {
        createdAt = rawCreated.toDate();
      } else if (rawCreated is String) {
        createdAt = DateTime.parse(rawCreated);
      } else {
        createdAt = DateTime.now();
      }

      DateTime expiresAt;
      final rawExpires = entry['expiresAt'];
      if (rawExpires is Timestamp) {
        expiresAt = rawExpires.toDate();
      } else if (rawExpires is String) {
        expiresAt = DateTime.parse(rawExpires);
      } else {
        expiresAt = createdAt;
      }

      final name = entry['name'] as String? ?? '';
      final email = entry['email'] as String? ?? '';

      final item = BookingHistoryItem(
        id: id,
        currency: currency,
        amount: amount,
        exchangePoint: exchangePoint,
        createdAt: createdAt,
        expiresAt: expiresAt,
        name: name,
        email: email,
      );

      await _box.put(id, item);
    }
  }
}
