import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_practise/core/app_pallet.dart';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;

class CurrencyRate {
  final String currency;
  final String buy;
  final String sell;
  final String flagAsset;

  CurrencyRate({
    required this.currency,
    required this.buy,
    required this.sell,
    required this.flagAsset,
  });
}

class CurrencyDashboard extends StatefulWidget {
  const CurrencyDashboard({Key? key}) : super(key: key);

  @override
  State<CurrencyDashboard> createState() => _CurrencyDashboardState();
}

class _CurrencyDashboardState extends State<CurrencyDashboard> {
  List<CurrencyRate> _rates = [];

  @override
  void initState() {
    super.initState();
    fetchCurrencyRates();
  }

  Future<void> fetchCurrencyRates() async {
    final url = Uri.parse(
        "https://frosty-hat-108d.dimashbalabek0.workers.dev/?target=https://mig.kz/");
    final response = await http.get(url);
    if (response.statusCode != 200) return;

    final document = html.parse(response.body);
    final text = document.body?.text ?? "";
    final regExp = RegExp(r"(\d+\.\d+)\s*USD\s*(\d+\.\d+)\s*"
        r"(\d+\.\d+)\s*EUR\s*(\d+\.\d+)\s*"
        r"(\d+\.\d+)\s*RUB\s*(\d+\.\d+)\s*"
        r"(\d+\.\d+)\s*KGS\s*(\d+\.\d+)\s*"
        r"(\d+\.\d+)\s*GBP\s*(\d+\.\d+)\s*"
        r"(\d+\.\d+)\s*CNY\s*(\d+\.\d+)\s*"
        r"(\d+\.\d+)\s*GOLD\s*(\d+\.\d+)");
    final match = regExp.firstMatch(text);
    if (match == null) return;

    setState(() {
      _rates = [
        CurrencyRate(
          currency: "USD",
          buy: match.group(1)!,
          sell: match.group(2)!,
          flagAsset: 'assets/usd.jpg',
        ),
        CurrencyRate(
          currency: "EUR",
          buy: match.group(3)!,
          sell: match.group(4)!,
          flagAsset: 'assets/eur.jpg',
        ),
        CurrencyRate(
          currency: "RUB",
          buy: match.group(5)!,
          sell: match.group(6)!,
          flagAsset: 'assets/rub.jpg',
        ),
        CurrencyRate(
          currency: "KGS",
          buy: match.group(7)!,
          sell: match.group(8)!,
          flagAsset: 'assets/kgs.jpg',
        ),
        CurrencyRate(
          currency: "CNY",
          buy: match.group(11)!,
          sell: match.group(12)!,
          flagAsset: 'assets/flags/cn.png',
        ),
      ];
    });
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
                    BackButton(color: Colors.black),
                    const SizedBox(width: 8),
                  ],
                ),
              ),

              // Список курсов
              Expanded(
                child: RefreshIndicator(
                  onRefresh: fetchCurrencyRates,
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
                                      // Верхний ряд: Покупка — Флаг/Код — Продажа
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          // Покупка
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Покупка",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: const Color.fromARGB(
                                                      179, 0, 0, 0),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                rate.buy,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),

                                          // Флаг
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

                                          // Продажа
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Продажа",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: const Color.fromARGB(
                                                      179, 0, 0, 0),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                rate.sell,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 16),

                                      // «Бронировать»
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

// void main() => runApp(
//   const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: CurrencyDashboard(),
//   ),
// );
