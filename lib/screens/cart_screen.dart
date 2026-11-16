import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/cart_service.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_cart_view.dart';
import '../widgets/product_image.dart';

/// Sepet sayfası: eklenen ürünler, toplam tutar ve Checkout butonu.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  /// Demo ödeme: gerçek ödeme yok, sadece bilgi verip sepeti boşaltır.
  Future<void> _checkout(BuildContext context) async {
    final total = cart.formattedTotal;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Order placed'),
        content: Text(
          'Your demo order of $total was received.\n'
          'This is a simulation, no payment was made.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    cart.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Sepet her değiştiğinde sayfa yeniden çizilir
    return ListenableBuilder(
      listenable: cart,
      builder: (context, child) {
        final items = cart.items;
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 4,
            title: TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              label: const Text('Cart'),
            ),
          ),
          body: items.isEmpty
              ? const EmptyCartView()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: items.length,
                  itemBuilder: (context, index) =>
                      _CartItemTile(product: items[index]),
                ),
          // Alt panel bottomNavigationBar'da durur; SnackBar'lar onun üstünde çıkar
          bottomNavigationBar: _buildBottomPanel(context),
        );
      },
    );
  }

  Widget _buildBottomPanel(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!cart.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Text(
                      'Total (${cart.count} items)',
                      style: const TextStyle(fontSize: 15),
                    ),
                    const Spacer(),
                    Text(
                      cart.formattedTotal,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            // Açık gri bilgi kutusu
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.lightGrey,
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: AppTheme.mutedText),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This is a demo store. No real payment will be taken.',
                      style: TextStyle(fontSize: 12, color: AppTheme.mutedText),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Sepet boşken buton görünür ama pasif (onPressed: null)
            FilledButton(
              onPressed: cart.isEmpty ? null : () => _checkout(context),
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sepetteki tek bir ürün satırı
class _CartItemTile extends StatelessWidget {
  final Product product;

  const _CartItemTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 56,
          height: 56,
          child: ProductImage(url: product.image),
        ),
      ),
      title: Text(
        product.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.tagline,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: AppTheme.mutedText),
          ),
          Text(
            product.price,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.priceBlue,
            ),
          ),
        ],
      ),
      isThreeLine: true,
      trailing: IconButton(
        tooltip: 'Remove',
        onPressed: () => cart.remove(product),
        icon: const Icon(
          Icons.remove_circle_outline,
          color: AppTheme.mutedText,
        ),
      ),
    );
  }
}
