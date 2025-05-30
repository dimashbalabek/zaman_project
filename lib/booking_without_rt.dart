import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_clean_architecture_practise/core/app_pallet.dart';

class BookingWithOutExchangeRatePage extends StatefulWidget {
  const BookingWithOutExchangeRatePage({Key? key}) : super(key: key);
  static Route<MaterialPageRoute> get route =>
      MaterialPageRoute(builder: (_) => const BookingWithOutExchangeRatePage());

  @override
  State<BookingWithOutExchangeRatePage> createState() =>
      _BookingWithOutExchangeRatePageState();
}

class _BookingWithOutExchangeRatePageState
    extends State<BookingWithOutExchangeRatePage> {
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

    final bookingData = {
      'currency': selectedCurrency,
      'amount': amount,
      'exchangePoint': selectedExchangePoint,
      'createdAt': now.toUtc().toIso8601String(),
      'expiresAt': "does not expire",
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
          'Бронирование без Привязки К Курсу',
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
                          ': Пользователь Может Забронировать Обмен На Ближайшее Время, Но Курс Не Фиксируется — Он Будет Известен Только При Посещении Обменного Пункта.',
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
                  });
                },
              ),
              const SizedBox(height: 16),
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
