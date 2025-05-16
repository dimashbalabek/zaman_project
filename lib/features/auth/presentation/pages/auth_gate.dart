import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/pages/wellcome_page.dart';
import 'package:flutter_clean_architecture_practise/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return HomePage();
    }

    return Scaffold(
      body: BlocBuilder<EmailAuthBloc, EmailAuthState>(
        builder: (context, state) {
          if (state is EmailAuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmailAuthAuthenticated) {
            return HomePage();
          } else {
            return SplashScreen();
          }
        },
      ),
    );
  }
}
