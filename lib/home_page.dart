import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_practise/core/app_pallet.dart';
import 'package:flutter_clean_architecture_practise/curse_page.dart';
import 'package:flutter_clean_architecture_practise/discount_page.dart';

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

  @override
  void initState() {
    super.initState();
    _pages = [
      _MainContent(name: widget.name, dateTime: widget.dateTime), // Главная
      Container(), // Бронь
      const CurrencyDashboard(), // Курсы
      Container(), // Карта
      Container(), // Профиль
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

  const _MainContent({Key? key, this.name, this.dateTime}) : super(key: key);

  @override
  State<_MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<_MainContent>
    with AutomaticKeepAliveClientMixin<_MainContent> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final displayName =
        (widget.name?.isNotEmpty ?? false) ? widget.name! : 'не найдено';
    final displayDate = (widget.dateTime?.isNotEmpty ?? false)
        ? widget.dateTime!
        : 'не найдено';

    // final _topCards = [
    //   {
    //     'image': 'assets/images/currency_board.jpg',
    //     'title': 'Бронирование Суммы/Курса'
    //   },
    // ];

    final sections = <Widget>[
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.all(20),
        child: _buildWideCard(
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
              onPressed: () => DefaultTabController.of(context)?.animateTo(2),
              child: Text('Смотреть Больше',
                  style: TextStyle(color: AppPallete.lightGreen)),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 140,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _buildRateCard(context, 'USD', '515.3', '517.3'),
            const SizedBox(width: 12),
            _buildRateCard(context, 'EUR', '583.3', '587.3'),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _buildWideCard(
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
            _buildIconButton(
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
          child: Text('Добро Пожаловать $displayName!',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.darkGreen)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(displayDate,
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

// Widget _buildTopCard(String imagePath, String title) {
//   return SizedBox(
//     width: 380,
//     height: 140,
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           // 1) Сам виджет картинки
//           Image.asset(
//             imagePath,
//             fit: BoxFit.cover,
//           ),
//           // 2) Градиентный оверлей
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter,
//                 colors: [
//                   AppPallete.darkGreen.withAlpha(100),
//                   Colors.transparent
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Align(
//               alignment: Alignment.bottomLeft,
//               child: Text(
//                 title.isNotEmpty ? title : 'Не найдено',
//                 style: TextStyle(
//                   color: AppPallete.white,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

  Widget _buildRateCard(
      BuildContext context, String currency, String buy, String sell) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(currency,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppPallete.darkGreen)),
            Spacer()
          ]),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text('Покупка',
                      style:
                          TextStyle(fontSize: 12, color: AppPallete.darkGreen)),
                  Text('$buy',
                      style:
                          TextStyle(fontSize: 12, color: AppPallete.darkGreen)),
                ],
              ),
              Column(
                children: [
                  Text('Продажа',
                      style:
                          TextStyle(fontSize: 12, color: AppPallete.darkGreen)),
                  Text('$sell',
                      style:
                          TextStyle(fontSize: 12, color: AppPallete.darkGreen)),
                ],
              )
            ],
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPallete.lightGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              minimumSize: Size(double.infinity, 32),
            ),
            child: Text('Бронировать',
                style: TextStyle(fontSize: 12, color: AppPallete.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildWideCard(BuildContext context,
      {String? image, String? title, String? subtitle, String? value}) {
    final img = (image != null && image.isNotEmpty)
        ? AssetImage(image)
        : AssetImage('assets/images/placeholder.png');
    final txt = (title != null && title.isNotEmpty) ? title : 'не найдено';
    final sub = (subtitle != null && subtitle.isNotEmpty) ? subtitle : '';
    final val = (value != null && value.isNotEmpty) ? value : '';
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: img, fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [AppPallete.darkGreen.withAlpha(80), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(txt,
                style: TextStyle(
                    color: AppPallete.white, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(sub,
                    style: TextStyle(color: AppPallete.white, fontSize: 12)),
                Text(val,
                    style: TextStyle(color: AppPallete.white, fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(
      IconData icon, String label, BuildContext context, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: AppPallete.lightGreen.withAlpha(60),
            child: Icon(icon, color: AppPallete.lightGreen),
          ),
          SizedBox(height: 8),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppPallete.darkGreen)),
        ],
      ),
    );
  }
}
