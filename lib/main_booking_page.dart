import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_practise/booking_with_rt.dart';
import 'package:flutter_clean_architecture_practise/booking_without_rt.dart';
import 'package:flutter_clean_architecture_practise/core/app_pallet.dart';
import 'package:flutter_clean_architecture_practise/features/booking/booking_history_page.dart';

class MainBookingPage extends StatelessWidget {
  const MainBookingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<_BookingOption> options = [
      _BookingOption(
        title: "Без Привязки К Курсу",
        subtitle: "Нажмите Для Ознакомления",
        icon: Icons.access_time,
        onTap: () {
          Navigator.of(context).push(BookingWithOutExchangeRatePage.route);
        },
      ),
      _BookingOption(
        title: "С привязкой к курсу",
        subtitle: "Бронь До 1-Го Часа",
        icon: Icons.schedule,
        onTap: () {
          Navigator.of(context).push(BookingWithExchangeRatePage.route);
        },
      ),
      _BookingOption(
        title: "История бронирования",
        subtitle: "Нажмите Для Ознакомления",
        icon: Icons.history,
        onTap: () {
          Navigator.of(context).push(
              BookingHistoryPage.route(FirebaseAuth.instance.currentUser!.uid));
        },
      ),
      _BookingOption(
        title: "Часто задаваемые вопросы",
        subtitle: "Русский Язык",
        icon: Icons.question_answer,
        onTap: () {
          // Добавь навигацию на страницу FAQ
          // Navigator.of(context).push(FAQPage.route);
        },
      ),
    ];

    return Scaffold(
      backgroundColor: AppPallete.white,
      appBar: AppBar(
        backgroundColor: AppPallete.white,
        elevation: 0,
        title: const Text(
          "Бронирование",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final option = options[index];
          return Container(
            decoration: BoxDecoration(
              color: AppPallete.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Container(
                decoration: const BoxDecoration(shape: BoxShape.rectangle),
                child: Icon(option.icon, color: AppPallete.darkGreen),
              ),
              title: Text(
                option.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                option.subtitle,
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: AppPallete.darkGreen, size: 16),
              onTap: option.onTap,
            ),
          );
        },
      ),
    );
  }
}

class _BookingOption {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  _BookingOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}
