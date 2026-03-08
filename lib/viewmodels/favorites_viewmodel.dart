import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/favorite_service.dart';

class FavoritesViewModel extends ChangeNotifier {
  final FavoriteService _service = FavoriteService();

  List<Product> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadFavorites() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getFavorites();
      final items = response['favorites'] as List?;
      if (items != null) {
        _favorites = items.map((e) {
          final js = Map<String, dynamic>.from(e as Map);
          // Map backend 'productId' to 'id' for Product.fromJson
          js['id'] = js['productId'];
          return Product.fromJson(js);
        }).toList();
      } else {
        _favorites = [];
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Product product) async {
    // Optimistic update
    final index = _favorites.indexWhere((item) => item.id == product.id);
    final isAlreadyFav = index >= 0;

    if (isAlreadyFav) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(product);
    }
    notifyListeners();

    try {
      if (isAlreadyFav) {
        await _service.removeFavorite(product.id);
      } else {
        await _service.addFavorite(product.id);
      }
    } catch (e) {
      // Revert if failed
      if (isAlreadyFav) {
        _favorites.insert(index, product);
      } else {
        _favorites.removeWhere((item) => item.id == product.id);
      }
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  bool isFavorite(String productId) {
    return _favorites.any((item) => item.id == productId);
  }
}
