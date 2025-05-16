import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_practise/core/app_theme.dart';
import 'package:flutter_clean_architecture_practise/discount_page.dart';

import 'package:flutter_clean_architecture_practise/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_clean_architecture_practise/firebase_options.dart';
import 'package:flutter_clean_architecture_practise/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => EmailAuthBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      home: HomePage(),
    );
  }
}
