import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_practise/core/app_pallet.dart';

class DiscountPage extends StatelessWidget {
  Route get route => MaterialPageRoute(builder: (_) => const DiscountPage());
  const DiscountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppPallete.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Скидки ZAMAN',
          style: TextStyle(
            color: AppPallete.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: AppPallete.lightGreen.withAlpha(200),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 24),
                Text(
                  'Выберите порог для получения скидки',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppPallete.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 32),
                _DiscountOption(
                  icon: Icons.local_offer,
                  label: 'Скидка при обмене на\n500 000 ₸+',
                  accent: AppPallete.gradientStart,
                  onTap: () {
                    // handle selection
                  },
                ),
                SizedBox(height: 16),
                _DiscountOption(
                  icon: Icons.attach_money,
                  label: 'Скидка при обмене на\n\$10 000+',
                  accent: AppPallete.gradientStart,
                  onTap: () {
                    // handle selection
                  },
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // confirm button action
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: AppPallete.darkGreen),
                  child: Text(
                    'Подтвердить',
                    style: TextStyle(
                      color: AppPallete.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DiscountOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent;
  final VoidCallback onTap;

  const _DiscountOption({
    required this.icon,
    required this.label,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPallete.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: accent,
                child: Icon(icon, color: AppPallete.white),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppPallete.darkGreen,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
