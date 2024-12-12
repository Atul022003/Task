import 'dart:convert';

class Product {
  final String name;
  final double price;
  final String imagePath;

  const Product({
    required this.name,
    required this.price,
    required this.imagePath,
  });

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source));

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      imagePath: map['imagePath'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'imagePath': imagePath,
    };
  }
}