import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  const AuthGradientButton(
      {super.key, required this.buttonText, required this.onPressed});
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [])),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(fixedSize: Size(395, 55)),
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          )),
    );
  }
}
