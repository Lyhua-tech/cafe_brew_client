import 'api_client.dart';

class SearchService {
  final ApiClient _apiClient = ApiClient();

  /// GET /search
  Future<Map<String, dynamic>> search(
    String query, {
    String type = 'all',
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      '/search',
      queryParameters: {'q': query, 'type': type, 'limit': limit},
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// GET /search/suggestions
  Future<List<String>> getSuggestions(String query, {int limit = 10}) async {
    final response = await _apiClient.get(
      '/search/suggestions',
      queryParameters: {'q': query, 'limit': limit},
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final raw = _unwrap(response.data);
    if (raw is List) return raw.map((e) => e.toString()).toList();
    return [];
  }

  /// GET /search/recent
  Future<List<dynamic>> getRecentSearches() async {
    final response = await _apiClient.get(
      '/search/recent',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final raw = _unwrap(response.data);
    return raw is List ? raw : [];
  }

  /// DELETE /search/recent
  Future<void> clearRecentSearches() async {
    final response = await _apiClient.delete(
      '/search/recent',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
  }

  /// DELETE /search/recent/:searchId
  Future<void> deleteRecentSearch(String searchId) async {
    final response = await _apiClient.delete(
      '/search/recent/$searchId',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
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
