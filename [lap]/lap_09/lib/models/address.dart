class Address {
  final String city;
  final String district;
  final String street;

  Address({
    required this.city,
    required this.district,
    required this.street,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: (json['city'] as String?) ?? '',
      district: (json['district'] as String?) ?? '',
      street: (json['street'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'district': district,
      'street': street,
    };
  }
}
