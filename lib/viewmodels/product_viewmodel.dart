import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _service = ProductService();

  // ── Categories ──────────────────────────────────────────────────────────────

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  // ── Products ────────────────────────────────────────────────────────────────

  List<Product> _products = [];
  List<Product> get products => _products;

  // ── State ───────────────────────────────────────────────────────────────────

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _selectedCategoryId;
  String? get selectedCategoryId => _selectedCategoryId;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Timer? _debounce;

  // ── Public API ──────────────────────────────────────────────────────────────

  Future<void> init() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await Future.wait([
        _loadCategories(),
        _loadProducts(),
      ]);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  void selectCategory(String? categoryId) {
    if (_selectedCategoryId == categoryId) return;
    _selectedCategoryId = categoryId;
    _searchQuery = '';
    _loadProducts();
    notifyListeners();
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      _loadProducts();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 450), () {
      _runSearch(query.trim());
    });
  }

  Future<void> refresh() => init();

  // ── Private ─────────────────────────────────────────────────────────────────

  Future<void> _loadCategories() async {
    _categories = await _service.getCategories();
  }

  Future<void> _loadProducts() async {
    _setLoading(true);
    try {
      _products = await _service.getProducts(
        categoryId: _selectedCategoryId,
        isAvailable: true,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _runSearch(String q) async {
    _isSearching = true;
    notifyListeners();
    try {
      _products =
          await _service.searchProducts(q, categoryId: _selectedCategoryId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
