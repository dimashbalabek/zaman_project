import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_practise/core/app_pallet.dart';

Widget buildRateCard(
    BuildContext context, String currency, String buy, String sell) {
  return Container(
    width: 180,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(currency,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppPallete.darkGreen)),
          Spacer()
        ]),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text('Покупка',
                    style:
                        TextStyle(fontSize: 12, color: AppPallete.darkGreen)),
                Text('$buy',
                    style:
                        TextStyle(fontSize: 12, color: AppPallete.darkGreen)),
              ],
            ),
            Column(
              children: [
                Text('Продажа',
                    style:
                        TextStyle(fontSize: 12, color: AppPallete.darkGreen)),
                Text('$sell',
                    style:
                        TextStyle(fontSize: 12, color: AppPallete.darkGreen)),
              ],
            )
          ],
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppPallete.lightGreen,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            minimumSize: Size(double.infinity, 32),
          ),
          child: Text('Бронировать',
              style: TextStyle(fontSize: 12, color: AppPallete.white)),
        ),
      ],
    ),
  );
}
