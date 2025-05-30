import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_practise/core/app_pallet.dart';

Widget buildIconButton(
    IconData icon, String label, BuildContext context, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        CircleAvatar(
          backgroundColor: AppPallete.lightGreen.withAlpha(60),
          child: Icon(icon, color: AppPallete.lightGreen),
        ),
        SizedBox(height: 8),
        Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppPallete.darkGreen)),
      ],
    ),
  );
}
