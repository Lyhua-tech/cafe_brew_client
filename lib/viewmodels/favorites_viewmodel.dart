import 'package:flutter/foundation.dart';
import '../models/product.dart';

class FavoritesViewModel extends ChangeNotifier {
  final List<Product> _favorites = [];

  List<Product> get favorites => _favorites;

  void toggleFavorite(Product product) {
    final index = _favorites.indexWhere((item) => item.id == product.id);

    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }

  bool isFavorite(String productId) {
    return _favorites.any((item) => item.id == productId);
  }
}
