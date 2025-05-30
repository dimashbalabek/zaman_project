// lib/main.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_practise/currency_rate.dart';
import 'package:flutter_clean_architecture_practise/features/booking/booking_history_page.dart';
import 'package:flutter_clean_architecture_practise/features/booking/repository/booking_repository.dart';
import 'package:flutter_clean_architecture_practise/features/booking/bloc/booking_history_bloc.dart';
import 'package:flutter_clean_architecture_practise/features/booking/models/booking_history_item.dart';
import 'package:flutter_clean_architecture_practise/core/app_theme.dart';
import 'package:flutter_clean_architecture_practise/features/home/home_page.dart';
import 'package:flutter_clean_architecture_practise/firebase_options.dart';
import 'package:flutter_clean_architecture_practise/main_booking_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

import 'background_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(BookingHistoryItemAdapter());
  Hive.registerAdapter(CurrencyRateAdapter());

  await Hive.openBox('userBox');
  await Hive.openBox<BookingHistoryItem>('bookingHistoryBox');
  await Hive.openBox<CurrencyRate>('currency_rates_box');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
  await Workmanager().registerPeriodicTask(
    "uniqueTaskName",
    "simplePeriodicTask",
    frequency: const Duration(seconds: 15),
    existingWorkPolicy: ExistingWorkPolicy.keep,
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      home: HomePage(),
    );
  }
}
// BookingHistoryPage(userId: userId)
