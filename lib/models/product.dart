/// Tek bir ürünü temsil eden model sınıfı.
class Product {
  final int id;
  final String name;
  final String tagline;
  final String description;
  final String price; // JSON'da metin olarak gelir, ör. "$999"
  final String currency;
  final String image; // Görselin internet adresi (URL)
  final Map<String, String> specs; // Anahtarlar ürüne göre değişir

  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.currency,
    required this.image,
    required this.specs,
  });

  /// JSON'dan nesne üretir. Eksik ya da null alanlarda boş değer kullanılır.
  factory Product.fromJson(Map<String, dynamic> json) {
    // specs içindeki her değeri güvenli şekilde String'e çevir
    final specs = <String, String>{};
    final rawSpecs = json['specs'];
    if (rawSpecs is Map) {
      rawSpecs.forEach((key, value) {
        specs[key.toString()] = value?.toString() ?? '';
      });
    }

    return Product(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      tagline: json['tagline']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      currency: json['currency']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      specs: specs,
    );
  }

  /// Nesneyi tekrar JSON'a (Map) çevirir.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'price': price,
      'currency': currency,
      'image': image,
      'specs': specs,
    };
  }

  /// "$2,499" gibi bir metni hesaplamada kullanmak için sayıya çevirir.
  double get priceValue {
    final digitsOnly = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(digitsOnly) ?? 0;
  }
}
