import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

/// Ürün verisini assets klasöründeki JSON dosyasından okur.
class ProductRepository {
  static const String _assetPath = 'assets/products.json';

  Future<List<Product>> loadProducts() async {
    // 1) Dosyayı metin olarak oku
    final jsonString = await rootBundle.loadString(_assetPath);

    // 2) Metni Dart nesnelerine (Map/List) çevir
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) return [];

    // 3) "data" dizisindeki her elemanı Product nesnesine dönüştür
    final data = decoded['data'];
    if (data is! List) return [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(Product.fromJson)
        .toList();
  }
}
