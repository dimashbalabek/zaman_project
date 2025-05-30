import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_practise/booking_with_rt.dart';
import 'package:flutter_clean_architecture_practise/core/app_pallet.dart';
import 'package:flutter_clean_architecture_practise/currency_rate.dart';
import 'package:flutter_clean_architecture_practise/curse_page.dart';
import 'package:flutter_clean_architecture_practise/discount_page.dart';
import 'package:flutter_clean_architecture_practise/features/home/widgets/icon_button.dart';
import 'package:flutter_clean_architecture_practise/features/home/widgets/rate_card.dart';
import 'package:flutter_clean_architecture_practise/features/home/widgets/wide_card.dart';
import 'package:flutter_clean_architecture_practise/main_booking_page.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.name, this.dateTime}) : super(key: key);

  final String? name;
  final String? dateTime;

  static Route<MaterialPageRoute> get route =>
      MaterialPageRoute(builder: (_) => const HomePage());

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  void _updateCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      _MainContent(
        name: widget.name,
        dateTime: widget.dateTime,
        onIndexChange: _updateCurrentIndex,
      ),
      MainBookingPage(),
      const CurrencyDashboard(),
      Container(),
      Container(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.white,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppPallete.lightGreen,
        unselectedItemColor: AppPallete.hint,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(
              icon: Icon(Icons.book_online), label: 'Бронь'),
          BottomNavigationBarItem(
              icon: Icon(Icons.request_quote), label: 'Курсы'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Карта'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}

class _MainContent extends StatefulWidget {
  final String? name;
  final String? dateTime;
  final ValueChanged<int>? onIndexChange;

  const _MainContent({Key? key, this.name, this.dateTime, this.onIndexChange})
      : super(key: key);

  @override
  State<_MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<_MainContent>
    with AutomaticKeepAliveClientMixin<_MainContent> {
  bool _isLoadingFromServer = false;
  Timer? _refreshTimer;

  String? usdBuy;
  String? usdSell;
  String? eurBuy;
  String? eurSell;
  String? rubBuy;
  String? rubSell;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadRatesFromHive();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _fetchAndUpdateRates();

    _refreshTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) {
        if (!mounted) return;
        _fetchAndUpdateRates();
      },
    );
  }

  Future<void> _loadRatesFromHive() async {
    final box = await Hive.openBox<CurrencyRate>('currency_rates_box');
    final rates = box.values.toList();

    for (var rate in rates) {
      switch (rate.currency) {
        case "USD":
          usdBuy = rate.buy;
          usdSell = rate.sell;
          break;
        case "EUR":
          eurBuy = rate.buy;
          eurSell = rate.sell;
          break;
        case "RUB":
          rubBuy = rate.buy;
          rubSell = rate.sell;
          break;
      }
    }
  }

  Future<void> _fetchAndUpdateRates() async {
    if (!mounted) return;
    setState(() {
      _isLoadingFromServer = true;
    });

    try {
      final url = Uri.parse(
          "https://frosty-hat-108d.dimashbalabek0.workers.dev/?target=https://mig.kz/");
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
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

        if (match != null) {
          final newRates = [
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
          ];

          final box = await Hive.openBox<CurrencyRate>('currency_rates_box');
          await box.clear();
          await box.addAll(newRates);

          await _loadRatesFromHive();
        }
      }
    } catch (e) {
      print("Ошибка при загрузке с сервера: $e");
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingFromServer = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final sections = [
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.all(20),
        child: buildWideCard(
          context,
          image: 'assets/curse.jpg',
          title: 'Бронирование Суммы/Курса',
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Курсы',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppPallete.darkGreen)),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.onIndexChange?.call(2);
                });
              },
              child: Text('Смотреть Больше',
                  style: TextStyle(color: AppPallete.lightGreen)),
            ),
          ],
        ),
      ),
      Stack(
        children: [
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                buildRateCard(context, 'USD', usdBuy ?? '-', usdSell ?? '-'),
                const SizedBox(width: 12),
                buildRateCard(context, 'EUR', eurBuy ?? '-', eurSell ?? '-'),
                const SizedBox(width: 12),
                buildRateCard(context, 'RUB', rubBuy ?? '-', rubSell ?? '-'),
              ],
            ),
          ),
          if (_isLoadingFromServer)
            Positioned.fill(
              child: Container(
                color: Colors.grey.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: buildWideCard(
          context,
          image: 'assets/gold.jpg',
          title: 'Золотые Слитки НБ РК',
          subtitle: 'Курс НБ РК за 1гр',
          value: '54 100,30 Т',
        ),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildIconButton(
              Icons.discount,
              'Получить\nСкидку',
              context,
              () => Navigator.of(context).push(DiscountPage().route),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppPallete.darkGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Есть Ли Отзыв Или Предложение?',
                    style: TextStyle(color: AppPallete.white, fontSize: 16),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: AppPallete.white, size: 16),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 80),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.account_circle,
                  size: 28, color: AppPallete.lightGreen),
              Icon(Icons.notifications_none,
                  size: 28, color: AppPallete.lightGreen),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Добро Пожаловать ${widget.name ?? ''}!',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.darkGreen)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(widget.dateTime ?? '',
              style: TextStyle(fontSize: 14, color: AppPallete.hint)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: sections.length,
            itemBuilder: (context, idx) => sections[idx],
          ),
        ),
      ],
    );
  }
}
