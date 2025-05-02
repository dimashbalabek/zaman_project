import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_practise/core/app_pallet.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/pages/sign_up_page.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/widgets/auth_gradient_button.dart';

class LogInPage extends StatefulWidget {
  static Route<MaterialPageRoute> get route =>
      MaterialPageRoute(builder: (_) => const LogInPage());

  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignInPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<EmailAuthBloc>().add(
            EmailSignInSubmitted(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmailAuthBloc>(
      create: (_) => EmailAuthBloc(),
      child: Scaffold(
        backgroundColor: AppPallete.darkGreen,
        appBar: AppBar(
          backgroundColor: AppPallete.darkGreen,
          elevation: 0,
          leading: const BackButton(color: Colors.white),
        ),
        body: BlocListener<EmailAuthBloc, EmailAuthState>(
          listener: (context, state) {
            if (state is EmailAuthFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            } else if (state is EmailAuthAuthenticated) {
              // Navigate to home or next page
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Вход',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    AuthField(
                      hintText: 'Электронная Почта',
                      controller: _emailController,
                      fillColor: AppPallete.lightGreen,
                      textColor: Colors.white,
                      hintColor: Colors.white70,
                    ),
                    const SizedBox(height: 16),
                    AuthField(
                      hintText: 'Пароль',
                      controller: _passwordController,
                      isObscure: true,
                      fillColor: AppPallete.lightGreen,
                      textColor: Colors.white,
                      hintColor: Colors.white70,
                    ),
                    const SizedBox(height: 32),
                    AuthGradientButton(
                      buttonText: 'Войти',
                      onPressed: _onSignInPressed,
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushReplacement(SignUpPage.route),
                      child: RichText(
                        text: TextSpan(
                          text: 'Нет аккаунта? ',
                          style: const TextStyle(color: Colors.white70),
                          children: [
                            TextSpan(
                              text: 'Регистрация',
                              style: TextStyle(
                                color: AppPallete.gradientEnd,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
