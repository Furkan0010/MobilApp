import 'package:flutter/material.dart';

import 'screens/cart_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';

/// Named route adları ve route tablosu tek bir yerde tutulur.
class AppRoutes {
  // Bu sınıftan nesne üretilmesin, sadece sabitler için kullanılıyor.
  AppRoutes._();

  static const String home = '/';
  static const String detail = '/detail';
  static const String cart = '/cart';

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeScreen(),
    detail: (context) => const ProductDetailScreen(),
    cart: (context) => const CartScreen(),
  };
}
