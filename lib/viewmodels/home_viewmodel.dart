import 'package:flutter/material.dart';
import '../models/coffee.dart';
import '../services/api_service.dart';

class HomeViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Coffee> _coffees = [];
  List<Coffee> get coffees => _coffees;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCoffees() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _coffees = await _apiService.fetchCoffees();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
