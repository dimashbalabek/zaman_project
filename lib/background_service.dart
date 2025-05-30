import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Hive.initFlutter();
    final userBox = await Hive.openBox('userBox');

    final url = Uri.parse(
        "https://frosty-hat-108d.dimashbalabek0.workers.dev/?target=https://mig.kz/");
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final document = html.parse(response.body);
        final text = document.body?.text ?? "";

        final regExp = RegExp(r"(\d+\.\d+)\s*USD\s*(\d+\.\d+)");
        final match = regExp.firstMatch(text);

        if (match != null) {
          final usdBuy = match.group(1);
          final usdSell = match.group(2);

          final oldUsdBuy = userBox.get('usdBuy');
          final oldUsdSell = userBox.get('usdSell');

          if (usdBuy != oldUsdBuy || usdSell != oldUsdSell) {
            await userBox.put('usdBuy', usdBuy);
            await userBox.put('usdSell', usdSell);

            _showLocalNotification(
              title: 'Курс USD обновился!',
              body: 'Новый курс: $usdBuy / $usdSell',
            );
          }
        }
      }
    } catch (e) {
      print('Ошибка фоновой задачи: $e');
    }

    return Future.value(true);
  });
}

void _showLocalNotification(
    {required String title, required String body}) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'currency_channel',
    'Currency Updates',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
  );
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    notificationDetails,
  );
}
