import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/profile_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  User? _profile;
  User? get profile => _profile;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  Future<void> loadProfile() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _profile = await _profileService.getProfile();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String dateOfBirth,
    required String gender,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    _successMessage = null;
    try {
      _profile = await _profileService.updateProfile(
        fullName: fullName.trim(),
        email: email.trim(),
        phoneNumber: phoneNumber.trim(),
        dateOfBirth: dateOfBirth.trim(),
        gender: gender,
      );
      _successMessage = 'Profile updated successfully';
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
