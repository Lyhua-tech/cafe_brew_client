import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    setLoading(true);
    setError(null);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    setLoading(false);

    // Simplistic validation mock
    if (email.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      notifyListeners();
      return true;
    } else {
      setError("Please enter valid credentials.");
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    setLoading(true);
    setError(null);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    setLoading(false);

    if (name.isNotEmpty && email.isNotEmpty && password.length >= 6) {
      return true;
    } else {
      setError("Please fill all details correctly.");
      return false;
    }
  }
}
