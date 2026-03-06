class Category {
  final String id;
  final String name;
  final String? slug;
  final String? description;
  final String? imageUrl;
  final int displayOrder;

  Category({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.imageUrl,
    this.displayOrder = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      displayOrder: json['displayOrder'] ?? 0,
    );
  }
}

class Product {
  final String id;
  final String name;
  final String? slug;
  final String? description;
  final double basePrice;
  final String currency;
  final List<String> images;
  final bool isAvailable;
  final bool isFeatured;
  final bool isBestSelling;
  final double? rating;
  final int? reviewCount;
  final int? preparationTime;
  final String? categoryId;
  final String? categoryName;
  final List<String> tags;

  Product({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    required this.basePrice,
    this.currency = 'USD',
    this.images = const [],
    this.isAvailable = true,
    this.isFeatured = false,
    this.isBestSelling = false,
    this.rating,
    this.reviewCount,
    this.preparationTime,
    this.categoryId,
    this.categoryName,
    this.tags = const [],
  });

  String get primaryImage => images.isNotEmpty ? images.first : '';

  String get formattedPrice {
    return '\$${basePrice.toStringAsFixed(2)}';
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    // images can be a List<String> or List<Map> depending on API
    List<String> parseImages(dynamic raw) {
      if (raw == null) return [];
      if (raw is List) {
        return raw
            .map((e) {
              if (e is String) return e;
              if (e is Map) return (e['url'] ?? e['src'] ?? '').toString();
              return '';
            })
            .where((s) => s.isNotEmpty)
            .toList();
      }
      return [];
    }

    final category = json['category'];
    return Product(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'],
      description: json['description'],
      basePrice: (json['basePrice'] ?? json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      images: parseImages(json['images']),
      isAvailable: json['isAvailable'] ?? true,
      isFeatured: json['isFeatured'] ?? false,
      isBestSelling: json['isBestSelling'] ?? false,
      rating: (json['rating'] ?? json['averageRating'])?.toDouble(),
      reviewCount: json['reviewCount'] ?? json['totalReviews'],
      preparationTime: json['preparationTime'],
      categoryId: category is Map
          ? (category['_id'] ?? category['id'])
          : json['categoryId'],
      categoryName: category is Map ? category['name'] : null,
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
