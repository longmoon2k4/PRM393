class Product {
  final int id;
  String name;
  double price;
  List<String> colors;
  bool inStock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.colors,
    required this.inStock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
      name: (json['name'] as String?) ?? 'Chưa có tên',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      colors: json['colors'] != null
          ? List<String>.from((json['colors'] as List<dynamic>).map((e) => e.toString()))
          : <String>[],
      inStock: (json['in_stock'] as bool?) ?? (json['inStock'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'colors': colors,
      'in_stock': inStock,
    };
  }
}
