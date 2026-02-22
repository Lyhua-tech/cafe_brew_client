class Coffee {
  final String id;
  final String name;
  final String description;
  final double price;

  Coffee({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Coffee.fromJson(Map<String, dynamic> json) {
    return Coffee(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}
