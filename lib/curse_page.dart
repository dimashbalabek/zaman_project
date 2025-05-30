import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_practise/core/app_pallet.dart';
import 'package:flutter_clean_architecture_practise/currency_rate.dart';
import 'package:hive/hive.dart';

class CurrencyDashboard extends StatefulWidget {
  const CurrencyDashboard({Key? key}) : super(key: key);
  static Route<MaterialPageRoute> get route =>
      MaterialPageRoute(builder: (_) => const CurrencyDashboard());

  @override
  State<CurrencyDashboard> createState() => _CurrencyDashboardState();
}

class _CurrencyDashboardState extends State<CurrencyDashboard> {
  List<CurrencyRate> _rates = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _loadRates();

    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _loadRates();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadRates() async {
    try {
      final box = await Hive.openBox<CurrencyRate>('currency_rates_box');
      final rates = box.values.toList();

      if (mounted) {
        setState(() {
          _rates = rates;
        });
      }
    } catch (e) {
      print("Ошибка чтения из Hive: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 233, 233, 233),
              AppPallete.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    const Text(
                      "Курсы",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadRates,
                  color: AppPallete.darkGreen,
                  child: _rates.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _rates.length,
                          itemBuilder: (context, i) {
                            final rate = _rates[i];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Card(
                                color: AppPallete.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 12),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Покупка",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                      179, 0, 0, 0),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                rate.buy,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 24,
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 167, 167, 167),
                                                backgroundImage:
                                                    AssetImage(rate.flagAsset),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                rate.currency,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              const Text(
                                                "Продажа",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                      179, 0, 0, 0),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                rate.sell,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppPallete.darkGreen,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                          ),
                                          onPressed: () {},
                                          child: const Text(
                                            "Бронировать",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: AppPallete.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
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
