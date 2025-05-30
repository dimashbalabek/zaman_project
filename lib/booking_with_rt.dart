import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_clean_architecture_practise/core/app_pallet.dart';
import 'package:flutter_clean_architecture_practise/currency_rate.dart';
import 'package:hive/hive.dart';

class BookingWithExchangeRatePage extends StatefulWidget {
  const BookingWithExchangeRatePage({Key? key}) : super(key: key);
  static Route<MaterialPageRoute> get route =>
      MaterialPageRoute(builder: (_) => const BookingWithExchangeRatePage());

  @override
  State<BookingWithExchangeRatePage> createState() =>
      _BookingWithExchangeRatePageState();
}

class _BookingWithExchangeRatePageState
    extends State<BookingWithExchangeRatePage> {
  final List<String> currencies = ['USD', 'RUB', 'EUR', 'KGS', 'UZS'];
  final List<String> exchangePoints = [
    'Zaman1 Ул.Байтурсынова 35',
    'Zaman2 Ул.Толе Би 156',
    'Zaman3 Ул.Толе Би 156'
  ];

  String? selectedCurrency;
  String? selectedExchangePoint;
  String amount = '';
  String exchangeAmount = '';

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  double _convertedAmount = 0;

  void _calculateExchange() {
    final box = Hive.box('currency_rates_box');
    final rates = box.get('rates') as Map<dynamic, dynamic>? ?? {};

    if (selectedCurrency == null || amount.isEmpty) {
      setState(() {
        _convertedAmount = 0.0;
      });
      return;
    }

    final currencyData = rates[selectedCurrency];
    final rate = currencyData != null
        ? (currencyData['sell'] as num?)?.toDouble() ?? 0.0
        : 0.0;

    final input = double.tryParse(amount) ?? 0.0;

    setState(() {
      _convertedAmount = rate * input;
    });
  }

  void _saveBooking() async {
    if (selectedCurrency == null ||
        amount.isEmpty ||
        selectedExchangePoint == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, заполните все поля')),
      );
      return;
    }

    final now = DateTime.now();
    final expiresAt = now.add(const Duration(minutes: 20));

    final bookingData = {
      'currency': selectedCurrency,
      'amount': amount,
      'exchangePoint': selectedExchangePoint,
      'createdAt': now.toUtc().toIso8601String(),
      'expiresAt': expiresAt.toUtc().toIso8601String(),
    };

    try {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);
      await userDoc.update({
        'bookingHistory': FieldValue.arrayUnion([bookingData])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Бронирование успешно сохранено')),
      );

      setState(() {
        selectedCurrency = null;
        selectedExchangePoint = null;
        amount = '';
        exchangeAmount = '';
        _convertedAmount = 0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при сохранении: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.white,
      appBar: AppBar(
        backgroundColor: AppPallete.white,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: AppPallete.black,
            )),
        title: const Text(
          'Бронирование c Привязки К Курсу',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Здесь',
                      style: TextStyle(color: Colors.green),
                    ),
                    TextSpan(
                      style: TextStyle(color: Colors.black),
                      text:
                          ': Пользователь Может Забронировать Обмен На Ближайшее Время, И Курс Фиксируется — Он Будет актуален до 20 минут.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Выбрать Валюту',
                  labelStyle: TextStyle(color: AppPallete.darkGreen),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFEAF3EA),
                ),
                dropdownColor: AppPallete.white,
                value: selectedCurrency,
                items: currencies
                    .map((currency) => DropdownMenuItem(
                          value: currency,
                          child: Text(currency),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCurrency = value;
                    _calculateExchange();
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Введите Сумму',
                  labelStyle: TextStyle(color: AppPallete.darkGreen),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFEAF3EA),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    amount = value;
                    _calculateExchange();
                  });
                },
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFCBEEDB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_convertedAmount.toStringAsFixed(2).replaceAll('.', ',')}T',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                dropdownColor: AppPallete.white,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: AppPallete.darkGreen),
                  labelText: 'Выбрать Пункт Обмена',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFEAF3EA),
                ),
                value: selectedExchangePoint,
                items: exchangePoints
                    .map((point) => DropdownMenuItem(
                          value: point,
                          child: Text(point),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedExchangePoint = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF014421),
                  ),
                  onPressed: _saveBooking,
                  child: const Text(
                    'Забронировать',
                    style: TextStyle(color: AppPallete.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
