import 'api_client.dart';

class FavoriteService {
  final ApiClient _apiClient = ApiClient();

  /// GET /favorites
  Future<Map<String, dynamic>> getFavorites() async {
    final response = await _apiClient.get(
      '/favorites',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// POST /favorites/:productId
  Future<Map<String, dynamic>> addFavorite(String productId) async {
    final response = await _apiClient.post(
      '/favorites/$productId',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// DELETE /favorites/:productId
  Future<Map<String, dynamic>> removeFavorite(String productId) async {
    final response = await _apiClient.delete(
      '/favorites/$productId',
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
