import 'package:flutter/foundation.dart';

import '../models/product.dart';

/// Sepet durumunu tutar. Değişince dinleyen widget'lara haber verir
/// (notifyListeners), böylece ekranlar kendini yeniden çizer.
class CartService extends ChangeNotifier {
  final List<Product> _items = [];

  /// Dışarıdan değiştirilemeyen sepet listesi
  List<Product> get items => List.unmodifiable(_items);

  int get count => _items.length;

  bool get isEmpty => _items.isEmpty;

  bool contains(Product product) {
    return _items.any((item) => item.id == product.id);
  }

  /// Ürünü sepete ekler. Aynı ürün ikinci kez eklenmez.
  void add(Product product) {
    if (contains(product)) return;
    _items.add(product);
    notifyListeners();
  }

  void remove(Product product) {
    _items.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// Sepetteki ürünlerin toplam fiyatı
  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.priceValue);
  }

  /// Toplam fiyatı "$3,347" biçiminde döndürür.
  String get formattedTotal {
    final digits = totalPrice.round().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      // Sağdan her 3 basamakta bir virgül koy
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return '\$$buffer';
  }
}

/// Uygulama genelinde kullanılan tek sepet örneği.
final CartService cart = CartService();
