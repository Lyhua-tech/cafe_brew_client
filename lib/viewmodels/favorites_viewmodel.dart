import 'package:flutter/foundation.dart';

// Since we don't have a rigid Product model yet, we will just use a simple Map for products.
// In a real scenario, this would be a Product model class.
class FavoritesViewModel extends ChangeNotifier {
  // List to hold the currently favorited items
  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  void toggleFavorite(Map<String, dynamic> product) {
    // Check if the product is already in favorites
    final index = _favorites.indexWhere((item) => item['id'] == product['id']);

    if (index >= 0) {
      // Product is already favorited, remove it
      _favorites.removeAt(index);
    } else {
      // Product is not favorited, add it
      _favorites.add(product);
    }

    // Notify listeners so the UI rebuilds
    notifyListeners();
  }

  bool isFavorite(String productId) {
    return _favorites.any((item) => item['id'] == productId);
  }
}
