import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../services/cart_service.dart';

class CartViewModel extends ChangeNotifier {
  final CartService _service = CartService();

  Cart? _cart;
  Cart? get cart => _cart;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isActionLoading = false;
  bool get isActionLoading => _isActionLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  CartValidation? _lastValidation;
  CartValidation? get lastValidation => _lastValidation;

  Future<void> loadCart() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cart = await _service.getCart();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(Product product, int quantity) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cart = await _service.addItem(product.id, quantity);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateQuantity(String itemId, int newQuantity) async {
    if (newQuantity < 1) {
      return removeItem(itemId);
    }

    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cart = await _service.updateItemQuantity(itemId, newQuantity);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeItem(String itemId) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cart = await _service.removeItem(itemId);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cart = await _service.clearCart();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<bool> validateCheckout() async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _lastValidation = await _service.validateCart();
      return _lastValidation!.isValid;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }
}
