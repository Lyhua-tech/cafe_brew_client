import '../models/announcement.dart';
import 'api_client.dart';

class AnnouncementService {
  final ApiClient _apiClient = ApiClient();

  /// GET /announcements — list of active announcements
  Future<List<Announcement>> getAnnouncements() async {
    final response = await _apiClient.get('/announcements');
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final data = _unwrap(response.data);
    final list =
        data is List ? data : (data['announcements'] ?? data['items'] ?? []);
    return (list as List)
        .map((e) => Announcement.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /announcements/:id — single announcement detail
  Future<Announcement> getAnnouncement(String id) async {
    final response = await _apiClient.get('/announcements/$id');
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final data = _unwrapMap(response.data);
    return Announcement.fromJson(data);
  }

  /// POST /announcements/:id/view — track view
  Future<void> trackView(String id) async {
    await _apiClient.post('/announcements/$id/view');
  }

  /// POST /announcements/:id/click — track click
  Future<void> trackClick(String id) async {
    await _apiClient.post('/announcements/$id/click');
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  dynamic _unwrap(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      final d = raw['data'];
      if (d != null) return d;
    }
    return raw;
  }

  Map<String, dynamic> _unwrapMap(dynamic raw) {
    final u = _unwrap(raw);
    if (u is Map<String, dynamic>) return u;
    return {};
  }

  String _parseError(dynamic data) {
    if (data is Map) {
      return (data['message'] as String?) ?? 'Unknown error occurred';
    }
    return 'Unknown error occurred';
  }
}
