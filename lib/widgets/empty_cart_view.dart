import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Sepet boşken ortada gösterilen görünüm.
class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    // Yatay ekranda alan daralırsa taşmasın diye kaydırılabilir
    return const Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: AppTheme.mutedText,
            ),
            SizedBox(height: 12),
            Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Add items to start shopping',
              style: TextStyle(fontSize: 13, color: AppTheme.mutedText),
            ),
          ],
        ),
      ),
    );
  }
}
