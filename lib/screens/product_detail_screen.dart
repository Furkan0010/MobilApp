import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import '../theme/app_theme.dart';
import '../widgets/product_image.dart';
import '../widgets/spec_chip.dart';

/// Ürün detay sayfası. Ürün, Route Argument olarak gelir.
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  void _addToCart(BuildContext context, Product product) {
    cart.add(product);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${product.name} added to cart'),
          // Aksiyonlu SnackBar varsayılan olarak kalıcıdır; birkaç saniye sonra kapansın.
          persist: false,
          action: SnackBarAction(
            label: 'View cart',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    // pushNamed ile gönderilen argümanı oku
    final arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 4,
        title: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          label: const Text('Back'),
        ),
      ),
      // Argüman beklenen tipte değilse uygulama çökmesin
      body: arguments is Product
          ? _buildBody(arguments)
          : const Center(child: Text('Product not found')),
      bottomNavigationBar: arguments is Product
          ? _buildAddToCartButton(context, arguments)
          : null,
    );
  }

  Widget _buildBody(Product product) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          // Sabit yükseklik: yatay ekranda da görsel tüm sayfayı kaplamaz
          child: SizedBox(height: 320, child: ProductImage(url: product.image)),
        ),
        const SizedBox(height: 16),
        Text(
          product.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          product.tagline,
          style: const TextStyle(fontSize: 14, color: AppTheme.mutedText),
        ),
        const SizedBox(height: 8),
        Text(
          product.price,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.priceBlue,
          ),
        ),
        const SizedBox(height: 20),
        const _SectionTitle('Description'),
        Text(
          product.description,
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
        if (product.specs.isNotEmpty) ...[
          const SizedBox(height: 20),
          const _SectionTitle('Specifications'),
          // Wrap: kutucuklar sığmazsa alt satıra geçer
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: product.specs.entries
                .map((entry) => SpecChip(label: entry.key, value: entry.value))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildAddToCartButton(BuildContext context, Product product) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        // Sepet değişince buton yazısı/durumu güncellenir
        child: ListenableBuilder(
          listenable: cart,
          builder: (context, child) {
            final inCart = cart.contains(product);
            return FilledButton(
              onPressed: inCart ? null : () => _addToCart(context, product),
              child: Text(inCart ? 'Added to cart' : 'Add to cart'),
            );
          },
        ),
      ),
    );
  }
}

/// "Description", "Specifications" gibi bölüm başlıkları
class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }
}
