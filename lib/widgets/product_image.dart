import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// İnternetten ürün görseli yükler.
/// Yüklenirken dönen bir gösterge, hata olursa (ör. internet yok) ikon gösterir.
class ProductImage extends StatelessWidget {
  final String url;
  final BoxFit fit;

  const ProductImage({super.key, required this.url, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.lightGrey,
      child: Image.network(
        url,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child; // Yükleme bitti
          return const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: AppTheme.mutedText,
              size: 32,
            ),
          );
        },
      ),
    );
  }
}
