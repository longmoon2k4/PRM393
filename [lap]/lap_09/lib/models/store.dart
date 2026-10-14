import 'package:lap_09/models/product.dart';

import 'address.dart';

class Store {
  final String store_name;
  final bool is_active;
  final double rating;
  final String? founder;
  final Address address;
  final List<Product> products;

  Store({
    required this.store_name,
    required this.is_active,
    required this.rating,
    required this.founder,
    required this.address,
    required this.products,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      store_name: json['store_name'] as String,
      is_active: json['is_active'] as bool,
      rating: json['rating'] as double,
      founder: json['founder'] as String?,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      products: (json['products'] as List<dynamic>)
          .map((p) => Product.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_name': store_name,
      'is_active': is_active,
      'rating': rating,
      'founder': founder,
      'address': address.toJson(),
      'products': products.map((p) => p.toJson()).toList(),
    };
  }
}
