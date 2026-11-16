import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../data/product_repository.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';

/// Ana sayfa (Discover): başlık, arama, banner ve ürün grid'i.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductRepository _repository = ProductRepository();

  // Future'ı bir kez oluşturuyoruz; her setState'te dosya tekrar okunmasın.
  late Future<List<Product>> _productsFuture;

  // Arama kutusuna yazılan metin
  String _query = '';

  @override
  void initState() {
    super.initState();
    _productsFuture = _repository.loadProducts();
  }

  void _retry() {
    setState(() {
      _productsFuture = _repository.loadProducts();
    });
  }

  /// Ürünleri ada göre filtreler (büyük/küçük harf duyarsız).
  List<Product> _filter(List<Product> products) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return products;
    return products
        .where((product) => product.name.toLowerCase().contains(query))
        .toList();
  }

  void _openDetail(Product product) {
    // Ürün nesnesi Route Argument olarak detay sayfasına gönderilir
    Navigator.pushNamed(context, AppRoutes.detail, arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeader(),
            const SizedBox(height: 4),
            const Text(
              'Find your perfect device.',
              style: TextStyle(fontSize: 14, color: AppTheme.mutedText),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) => setState(() => _query = value),
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Search products',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            // Banner, assets klasöründen yüklenir
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radius),
              child: Image.asset('assets/images/banner.png', fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            _buildProductGrid(),
          ],
        ),
      ),
    );
  }

  /// "Discover" başlığı ve sağda sepet ikonu (rozetli)
  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Discover',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        // Sepet değişince sadece bu ikon yeniden çizilir
        ListenableBuilder(
          listenable: cart,
          builder: (context, child) {
            return IconButton(
              tooltip: 'Cart',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
              icon: Badge(
                isLabelVisible: cart.count > 0,
                label: Text('${cart.count}'),
                child: const Icon(Icons.shopping_bag_outlined, size: 28),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProductGrid() {
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        // 1) Veri yükleniyor
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // 2) Hata oluştu
        if (snapshot.hasError) {
          return _buildMessage(
            'Products could not be loaded.',
            action: TextButton(onPressed: _retry, child: const Text('Retry')),
          );
        }

        // 3) Veri geldi, arama filtresini uygula
        final products = _filter(snapshot.data ?? []);
        if (products.isEmpty) {
          return _buildMessage('No products found');
        }

        // Geniş ekranda (ör. yatay) 4 sütun, telefonda 2 sütun
        final width = MediaQuery.sizeOf(context).width;
        final columns = width > 600 ? 4 : 2;

        return GridView.builder(
          // Grid, dıştaki ListView ile birlikte kaysın
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.68,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => _openDetail(product),
            );
          },
        );
      },
    );
  }

  Widget _buildMessage(String text, {Widget? action}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Text(text, style: const TextStyle(color: AppTheme.mutedText)),
          // "?action": action null değilse listeye eklenir
          ?action,
        ],
      ),
    );
  }
}
