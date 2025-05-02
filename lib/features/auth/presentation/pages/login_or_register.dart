import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/pages/log_in_page.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/pages/sign_up_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // initially show login page
  bool showLoginPage = true;

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LogInPage();
    } else {
      return SignUpPage();
    }
  }
}
