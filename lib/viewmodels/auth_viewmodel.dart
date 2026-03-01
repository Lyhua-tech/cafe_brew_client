import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  User? _currentUser;
  User? get currentUser => _currentUser;

  // Temporary storage for multi-step registration
  String? _tempFullName;
  String? _tempPassword;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    if (message != null) notifyListeners();
  }

  Future<void> checkAuth() async {
    setLoading(true);
    try {
      final token = await _authService.getAccessToken();
      if (token != null) {
        _currentUser = await _authService.getMe();
        _isLoggedIn = true;
      }
    } catch (e) {
      _isLoggedIn = false;
      _currentUser = null;
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    setLoading(true);
    setError(null);

    try {
      _currentUser = await _authService.login(email, password);
      _isLoggedIn = true;
      notifyListeners();
      return true;
    } catch (e) {
      setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> signUp(String fullName, String email, String password) async {
    setLoading(true);
    setError(null);

    try {
      await _authService.initiateRegister(email, fullName, password);
      // Store temporarily for the verify step
      _tempFullName = fullName;
      _tempPassword = password;
      return true;
    } catch (e) {
      setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> verifyRegistration(String email, String otpCode) async {
    setLoading(true);
    setError(null);

    if (_tempFullName == null || _tempPassword == null) {
      setError(
          "Registration session expired or invalid state. Please try signing up again.");
      setLoading(false);
      return false;
    }

    try {
      await _authService.verifyRegister(
          _tempFullName!, email, _tempPassword!, otpCode);
      // After verification, we usually get tokens and log in
      _currentUser = await _authService.getMe();
      _isLoggedIn = true;

      // Clear temp data
      _tempFullName = null;
      _tempPassword = null;

      notifyListeners();
      return true;
    } catch (e) {
      setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> logout() async {
    setLoading(true);
    await _authService.logout();
    _isLoggedIn = false;
    _currentUser = null;
    setLoading(false);
    notifyListeners();
  }

  Future<bool> forgotPassword(String email) async {
    setLoading(true);
    setError(null);
    try {
      await _authService.forgotPassword(email);
      return true;
    } catch (e) {
      setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> resetPassword(
      String email, String otpCode, String newPassword) async {
    setLoading(true);
    setError(null);
    try {
      await _authService.resetPassword(email, otpCode, newPassword);
      return true;
    } catch (e) {
      setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> verifyOtp(String email, String otpCode,
      {String? verificationType}) async {
    setLoading(true);
    setError(null);
    try {
      await _authService.verifyOtp(email, otpCode,
          verificationType: verificationType);
      return true;
    } catch (e) {
      setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> resendOtp(String email, String verificationType) async {
    setLoading(true);
    setError(null);
    try {
      await _authService.resendOtp(email, verificationType);
      return true;
    } catch (e) {
      setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      setLoading(false);
    }
  }
}
