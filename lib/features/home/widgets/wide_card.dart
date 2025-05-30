import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_practise/core/app_pallet.dart';

Widget buildWideCard(BuildContext context,
    {String? image, String? title, String? subtitle, String? value}) {
  final img = (image != null && image.isNotEmpty)
      ? AssetImage(image)
      : AssetImage('assets/images/placeholder.png');
  final txt = (title != null && title.isNotEmpty) ? title : 'не найдено';
  final sub = (subtitle != null && subtitle.isNotEmpty) ? subtitle : '';
  final val = (value != null && value.isNotEmpty) ? value : '';
  return Container(
    height: 120,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      image: DecorationImage(image: img, fit: BoxFit.cover),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [AppPallete.darkGreen.withAlpha(80), Colors.transparent],
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(txt,
              style: TextStyle(
                  color: AppPallete.white, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sub,
                  style: TextStyle(color: AppPallete.white, fontSize: 12)),
              Text(val,
                  style: TextStyle(color: AppPallete.white, fontSize: 14)),
            ],
          ),
        ],
      ),
    ),
  );
}
