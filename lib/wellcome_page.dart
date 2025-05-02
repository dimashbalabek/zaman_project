import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/pages/sign_up_page.dart';

void main() {
  runApp(const ZamanApp());
}

class ZamanApp extends StatelessWidget {
  const ZamanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zaman',
      theme: ThemeData(
        primaryColor: const Color(0xFF11482F),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (c) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF11482F),
      body: const Center(
        child: Text(
          'ZAMAN',
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

/// Экран онбординга
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  final _data = <_OnbPageData>[
    _OnbPageData(
      image: 'assets/on_time.jpg',
      text:
          'Лёгкая и быстрая конвертация валют. Управляйте деньгами без границ.',
    ),
    _OnbPageData(
      image: 'assets/price.jpg',
      text: 'Следите за актуальными курсами валют в реальном времени.',
    ),
    _OnbPageData(
      image: 'assets/go_anywhere.jpg',
      text:
          'Все ваши конверсии всегда под рукой. Безопасно. Удобно. Прозрачно.',
    ),
  ];

  void _goNext() {
    if (_page < _data.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (c) => const SignUpPage()),
      );
    }
  }

  void _goBack() {
    if (_page > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: _data.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) => _OnboardingPage(data: _data[i]),
            ),

            // Кнопки-стрелки
            Positioned(
              left: 16,
              bottom: 32,
              child: Opacity(
                opacity: _page > 0 ? 1 : 0, // спрятать на первой странице
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.grey,
                    onPressed: _goBack,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 16,
              bottom: 32,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF11482F),
                child: IconButton(
                  icon: Icon(
                    _page == _data.length - 1
                        ? Icons.check
                        : Icons.arrow_forward,
                  ),
                  color: Colors.white,
                  onPressed: _goNext,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnbPageData {
  final String image;
  final String text;
  _OnbPageData({required this.image, required this.text});
}

class _OnboardingPage extends StatelessWidget {
  final _OnbPageData data;
  const _OnboardingPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            data.image,
            height: 200,
          ),
          const SizedBox(height: 24),
          Text(
            data.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF333333),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
