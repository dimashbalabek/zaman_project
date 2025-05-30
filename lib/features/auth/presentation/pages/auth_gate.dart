// lib/features/auth/presentation/pages/auth_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/pages/wellcome_page.dart';
import 'package:flutter_clean_architecture_practise/features/home/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  Future<HomePage> _prepareHome() async {
    final box = await Hive.openBox('userBox');

    String name = box.get('userName') as String? ?? '';
    String email = box.get('userEmail') as String? ?? '';
    String createdAt = box.get('userCreatedAt') as String? ?? '';

    if (name.isEmpty || email.isEmpty || createdAt.isEmpty) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        name = data['name'] as String? ?? '';
        email = data['email'] as String? ?? '';
        createdAt =
            (data['createdAt'] as Timestamp?)?.toDate().toLocal().toString() ??
                '';

        await box.put('userName', name);
        await box.put('userEmail', email);
        await box.put('userCreatedAt', createdAt);
      }
    }

    return HomePage(
      name: name,
      dateTime: createdAt,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return const Scaffold(
        body: SplashScreen(),
      );
    }

    return FutureBuilder<HomePage>(
      future: _prepareHome(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasData) {
          return snap.data!;
        }
        return const Scaffold(
          body: Center(child: Text('Ошибка при загрузке данных')),
        );
      },
    );
  }
}
