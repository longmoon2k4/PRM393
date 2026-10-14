class Product {
  final int id;
  final String name;
  final double price;
  final List<String> colors;
  final bool in_stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.colors,
    required this.in_stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as double,
      colors: List<String>.from(json['colors'] as List<dynamic>),
      in_stock: json['in_stock'] as bool,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'name': name,
      'price': price,
      'colors': colors,
      'in_stock': in_stock,
    };
  }
}
