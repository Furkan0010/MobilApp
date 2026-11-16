import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog/main.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/services/cart_service.dart';

// Testlerde kullanılan örnek ürün
const testProduct = Product(
  id: 99,
  name: 'Test Phone',
  tagline: 'Just for tests.',
  description: 'A product used in unit tests.',
  price: r'$1,250',
  currency: 'USD',
  image: '',
  specs: {'chip': 'T1'},
);

/// Uygulamayı açar ve ürünler asset'ten yüklenene kadar bekler.
Future<void> pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const MiniKatalogApp());
  // Asset okuma gerçek bir I/O işlemi olduğu için runAsync içinde bekliyoruz
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 200)),
  );
  await tester.pump();
}

void main() {
  setUp(() {
    // Sepet global olduğu için her testten önce boşalt
    cart.clear();
    // rootBundle okunan dosyayı önbellekte tutar; her test dosyayı yeniden okusun
    rootBundle.evict('assets/products.json');
  });

  group('Product model', () {
    test('fromJson reads all fields', () {
      final product = Product.fromJson({
        'id': 1,
        'name': 'iPhone 15 Pro',
        'tagline': 'Titanium.',
        'description': 'Desc',
        'price': r'$999',
        'currency': 'USD',
        'image': 'https://example.com/a.png',
        'specs': {'chip': 'A17 Pro', 'camera': '48MP Main'},
      });

      expect(product.id, 1);
      expect(product.name, 'iPhone 15 Pro');
      expect(product.specs['chip'], 'A17 Pro');
      expect(product.priceValue, 999);
      expect(product.toJson()['name'], 'iPhone 15 Pro');
    });

    test('fromJson is safe with missing fields', () {
      final product = Product.fromJson({'name': 'Only name'});

      expect(product.id, 0);
      expect(product.price, '');
      expect(product.specs, isEmpty);
    });
  });

  group('CartService', () {
    test('add, remove and clear update the count', () {
      cart.add(testProduct);
      cart.add(testProduct); // Aynı ürün ikinci kez eklenmez
      expect(cart.count, 1);
      expect(cart.formattedTotal, r'$1,250');

      cart.remove(testProduct);
      expect(cart.isEmpty, isTrue);

      cart.add(testProduct);
      cart.clear();
      expect(cart.count, 0);
    });
  });

  group('App', () {
    testWidgets('home screen shows header and products', (tester) async {
      await pumpApp(tester);

      expect(find.text('Discover'), findsOneWidget);
      expect(find.text('Find your perfect device.'), findsOneWidget);
      expect(find.text('iPhone 15 Pro'), findsOneWidget);
    });

    testWidgets('search filters products by name', (tester) async {
      await pumpApp(tester);

      await tester.enterText(find.byType(TextField), 'macbook');
      await tester.pump();

      expect(find.text('iPhone 15 Pro'), findsNothing);
      expect(find.textContaining('MacBook'), findsWidgets);

      await tester.enterText(find.byType(TextField), 'xyz');
      await tester.pump();
      expect(find.text('No products found'), findsOneWidget);
    });

    testWidgets('detail -> add to cart -> cart -> checkout', (tester) async {
      await pumpApp(tester);

      // Karta dokun, detay sayfası açılsın
      await tester.tap(find.text('iPhone 15 Pro'));
      await tester.pumpAndSettle();
      expect(find.text('Description'), findsOneWidget);

      // Sepete ekle
      await tester.tap(find.text('Add to cart'));
      await tester.pump();
      expect(cart.count, 1);
      expect(find.text('Added to cart'), findsOneWidget);

      // Geri dön: çanta ikonundaki rozet 1 göstermeli
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);

      // Sepete git
      await tester.tap(find.byTooltip('Cart'));
      await tester.pumpAndSettle();
      expect(find.text(r'$999'), findsWidgets);

      // Demo ödeme: diyalog kapanınca sepet boşalır
      await tester.tap(find.text('Checkout'));
      await tester.pumpAndSettle();
      expect(find.text('Order placed'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(cart.isEmpty, isTrue);
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('no overflow on a small landscape screen', (tester) async {
      // Yatay tutulmuş küçük bir telefon ekranı
      tester.view.physicalSize = const Size(780, 360);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await pumpApp(tester);
      // Kart ekranın altında kaldığı için önce ona kaydır
      await tester.ensureVisible(find.text('iPhone 15 Pro'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('iPhone 15 Pro'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to cart'));
      await tester.pumpAndSettle(); // SnackBar'ın açılma animasyonu bitsin
      await tester.tap(find.text('View cart'));
      await tester.pumpAndSettle();
      expect(find.text('Checkout'), findsOneWidget);

      await tester.tap(find.byTooltip('Remove'));
      await tester.pump();
      expect(find.text('Your cart is empty'), findsOneWidget);

      // Taşma olsaydı Flutter bir hata fırlatırdı
      expect(tester.takeException(), isNull);
    });
  });
}
