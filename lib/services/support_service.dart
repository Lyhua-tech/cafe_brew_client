import 'api_client.dart';

class SupportService {
  final ApiClient _apiClient = ApiClient();

  /// GET /announcements
  Future<List<dynamic>> getAnnouncements() async {
    final response = await _apiClient.get(
      '/announcements',
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final raw = _unwrap(response.data);
    return raw is List ? raw : [];
  }

  /// GET /announcements/:id
  Future<Map<String, dynamic>> getAnnouncement(String id) async {
    final response = await _apiClient.get(
      '/announcements/$id',
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// POST /announcements/:id/view
  Future<void> trackAnnouncementView(String id) async {
    final response = await _apiClient.post(
      '/announcements/$id/view',
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
  }

  /// POST /announcements/:id/click
  Future<void> trackAnnouncementClick(String id) async {
    final response = await _apiClient.post(
      '/announcements/$id/click',
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
  }

  /// GET /support/faq
  Future<List<dynamic>> getFaqs({String? category}) async {
    final query = <String, dynamic>{};
    if (category != null) query['category'] = category;

    final response = await _apiClient.get(
      '/support/faq',
      queryParameters: query,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final raw = _unwrap(response.data);
    return raw is List ? raw : [];
  }

  /// POST /support/tickets
  Future<Map<String, dynamic>> createTicket({
    required String subject,
    required String category,
    required String message,
    String? priority,
  }) async {
    final payload = <String, dynamic>{
      'subject': subject,
      'category': category,
      'message': message,
    };
    if (priority != null) payload['priority'] = priority;

    final response = await _apiClient.post(
      '/support/tickets',
      body: payload,
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// GET /support/tickets
  Future<Map<String, dynamic>> getTickets({
    String? status,
    String? category,
    int page = 1,
    int limit = 20,
  }) async {
    final query = <String, dynamic>{'page': page, 'limit': limit};
    if (status != null) query['status'] = status;
    if (category != null) query['category'] = category;

    final response = await _apiClient.get(
      '/support/tickets',
      queryParameters: query,
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// GET /support/tickets/:id
  Future<Map<String, dynamic>> getTicket(String id) async {
    final response = await _apiClient.get(
      '/support/tickets/$id',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// POST /support/tickets/:id/messages
  Future<Map<String, dynamic>> sendMessage(String ticketId, String message,
      {List<String>? attachments}) async {
    final payload = <String, dynamic>{'message': message};
    if (attachments != null) payload['attachments'] = attachments;

    final response = await _apiClient.post(
      '/support/tickets/$ticketId/messages',
      body: payload,
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// GET /support/tickets/:id/messages
  Future<List<dynamic>> getTicketMessages(String ticketId) async {
    final response = await _apiClient.get(
      '/support/tickets/$ticketId/messages',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final raw = _unwrap(response.data);
    return raw is List ? raw : [];
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
