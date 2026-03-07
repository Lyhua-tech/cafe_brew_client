import 'api_client.dart';

class NotificationService {
  final ApiClient _apiClient = ApiClient();

  /// POST /notifications/devices/register
  Future<Map<String, dynamic>> registerDevice({
    required String fcmToken,
    required String deviceType,
    String? deviceId,
    String? deviceModel,
    String? osVersion,
    String? appVersion,
  }) async {
    final payload = <String, dynamic>{
      'fcmToken': fcmToken,
      'deviceType': deviceType,
    };
    if (deviceId != null) payload['deviceId'] = deviceId;
    if (deviceModel != null) payload['deviceModel'] = deviceModel;
    if (osVersion != null) payload['osVersion'] = osVersion;
    if (appVersion != null) payload['appVersion'] = appVersion;

    final response = await _apiClient.post(
      '/notifications/devices/register',
      body: payload,
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// DELETE /notifications/devices/:tokenId
  Future<void> unregisterDevice(String tokenId) async {
    final response = await _apiClient.delete(
      '/notifications/devices/$tokenId',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
  }

  /// GET /notifications
  Future<List<dynamic>> getNotifications({
    String? type,
    bool? isRead,
    int limit = 50,
    int skip = 0,
  }) async {
    final query = <String, dynamic>{'limit': limit, 'skip': skip};
    if (type != null) query['type'] = type;
    if (isRead != null) query['isRead'] = isRead.toString();

    final response = await _apiClient.get(
      '/notifications',
      queryParameters: query,
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final raw = _unwrap(response.data);
    return raw is List ? raw : [];
  }

  /// GET /notifications/unread-count
  Future<int> getUnreadCount() async {
    final response = await _apiClient.get(
      '/notifications/unread-count',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final raw = _unwrapMap(response.data);
    return raw['count'] as int? ?? 0;
  }

  /// PATCH /notifications/:id/read
  Future<void> markAsRead(String id) async {
    final response = await _apiClient.patch(
      '/notifications/$id/read',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
  }

  /// PATCH /notifications/read-all
  Future<void> markAllAsRead() async {
    final response = await _apiClient.patch(
      '/notifications/read-all',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
  }

  /// DELETE /notifications/:id
  Future<void> deleteNotification(String id) async {
    final response = await _apiClient.delete(
      '/notifications/$id',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
  }

  /// DELETE /notifications
  Future<void> deleteAllNotifications() async {
    final response = await _apiClient.delete(
      '/notifications',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
  }

  /// GET /notifications/settings
  Future<Map<String, dynamic>> getSettings() async {
    final response = await _apiClient.get(
      '/notifications/settings',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// PATCH /notifications/settings
  Future<Map<String, dynamic>> updateSettings(
      Map<String, dynamic> settings) async {
    final response = await _apiClient.patch(
      '/notifications/settings',
      body: settings,
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  dynamic _unwrap(dynamic raw) {
    if (raw is Map<String, dynamic> && raw.containsKey('data')) {
      return raw['data'];
    }
    return raw;
  }

  Map<String, dynamic> _unwrapMap(dynamic raw) {
    final u = _unwrap(raw);
    return u is Map<String, dynamic> ? u : {};
  }

  String _parseError(dynamic data) {
    if (data is Map) {
      return (data['message'] as String?) ?? 'Unknown error occurred';
    }
    return 'Unknown error occurred';
  }
}
