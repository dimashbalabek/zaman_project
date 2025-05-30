import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_practise/core/app_pallet.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/pages/log_in_page.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter_clean_architecture_practise/features/home/home_page.dart';
import 'package:hive/hive.dart';

class SignUpPage extends StatefulWidget {
  static Route<MaterialPageRoute> get route =>
      MaterialPageRoute(builder: (_) => const SignUpPage());

  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onSignUpPressed() {
    if (_formKey.currentState!.validate() && !_isSuccess) {
      context.read<EmailAuthBloc>().add(
            EmailSignUpSubmitted(
              email: _emailController.text.trim(),
              name: _nameController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.darkGreen,
      appBar: AppBar(
        backgroundColor: AppPallete.darkGreen,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<EmailAuthBloc, EmailAuthState>(
        listener: (context, state) {
          if (state is EmailAuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is EmailAuthAuthenticated) {
            final userBox = Hive.box('userBox');
            userBox.put('name', _nameController.text.trim());
            userBox.put('email', _emailController.text.trim());
            setState(() {
              _isSuccess = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Успешно зарегистрированы! ✅')),
            );
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).pushReplacement(HomePage.route);
            });
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
                    'Регистрация',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  AuthField(
                    hintText: 'Имя',
                    controller: _nameController,
                    fillColor: AppPallete.lightGreen,
                    textColor: Colors.white,
                    hintColor: Colors.white70,
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  AuthField(
                    hintText: 'Повторить Пароль',
                    controller: _confirmController,
                    isObscure: true,
                    fillColor: AppPallete.lightGreen,
                    textColor: Colors.white,
                    hintColor: Colors.white70,
                  ),
                  const SizedBox(height: 32),
                  AuthGradientButton(
                    buttonText: _isSuccess
                        ? 'Успешно зарегистрированы ✅'
                        : 'Продолжить',
                    onPressed: _isSuccess ? null : _onSignUpPressed,
                    disabled: _isSuccess,
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushReplacement(LogInPage.route),
                    child: RichText(
                      text: const TextSpan(
                        text: 'У Вас Есть Аккаунт? ',
                        style: TextStyle(color: Colors.white70),
                        children: [
                          TextSpan(
                            text: 'Войти',
                            style: TextStyle(
                              color: Colors.white,
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
    );
  }
}
