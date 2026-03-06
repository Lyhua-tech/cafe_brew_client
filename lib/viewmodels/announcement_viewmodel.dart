import 'package:flutter/material.dart';
import '../models/announcement.dart';
import '../services/announcement_service.dart';

class AnnouncementViewModel extends ChangeNotifier {
  final AnnouncementService _service = AnnouncementService();

  List<Announcement> _announcements = [];
  List<Announcement> get announcements => _announcements;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  Future<void> loadAnnouncements() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _announcements = await _service.getAnnouncements();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> trackView(String id) async {
    try {
      await _service.trackView(id);
    } catch (_) {}
  }

  Future<void> trackClick(String id) async {
    try {
      await _service.trackClick(id);
    } catch (_) {}
  }
}
