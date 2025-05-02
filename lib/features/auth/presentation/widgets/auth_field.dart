import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscure = false,
    this.fillColor = const Color(0xFF4CAF50),
    this.textColor = Colors.white,
    this.hintColor = Colors.white70,
  });

  final String hintText;
  final TextEditingController controller;
  final bool isObscure;
  final Color fillColor;
  final Color textColor;
  final Color hintColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor),
        filled: true,
        fillColor: fillColor,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$hintText не заполнено';
        }
        return null;
      },
    );
  }
}
