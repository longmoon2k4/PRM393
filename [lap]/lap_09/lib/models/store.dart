import 'package:lap_09/models/product.dart';
import 'address.dart';

class Store {
  final String storeName;
  final bool isActive;
  final double rating;
  final String? founder;
  final Address address;
  final List<Product> products;

  Store({
    required this.storeName,
    required this.isActive,
    required this.rating,
    required this.founder,
    required this.address,
    required this.products,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      storeName: (json['store_name'] as String?) ??
          (json['storeName'] as String?) ??
          'Cửa Hàng',
      isActive: (json['is_active'] as bool?) ??
          (json['isActive'] as bool?) ??
          true,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      founder: json['founder'] as String?,
      address: json['address'] != null
          ? Address.fromJson(json['address'] as Map<String, dynamic>)
          : Address(city: '', district: '', street: ''),
      products: json['products'] != null
          ? (json['products'] as List<dynamic>)
              .map((p) => Product.fromJson(p as Map<String, dynamic>))
              .toList()
          : <Product>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_name': storeName,
      'is_active': isActive,
      'rating': rating,
      'founder': founder,
      'address': address.toJson(),
      'products': products.map((p) => p.toJson()).toList(),
    };
  }
}
