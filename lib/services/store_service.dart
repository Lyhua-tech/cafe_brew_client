import 'api_client.dart';

class StoreService {
  final ApiClient _apiClient = ApiClient();

  /// GET /stores
  Future<Map<String, dynamic>> getStores({
    double? latitude,
    double? longitude,
    double? radius,
    int page = 1,
    int limit = 20,
  }) async {
    final query = <String, dynamic>{'page': page, 'limit': limit};
    if (latitude != null) query['latitude'] = latitude;
    if (longitude != null) query['longitude'] = longitude;
    if (radius != null) query['radius'] = radius;

    final response = await _apiClient.get('/stores', queryParameters: query);
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// GET /stores/slug/:slug
  Future<Map<String, dynamic>> getStoreBySlug(String slug) async {
    final response = await _apiClient.get('/stores/slug/$slug');
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// GET /stores/:id
  Future<Map<String, dynamic>> getStoreById(String id) async {
    final response = await _apiClient.get('/stores/$id');
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// GET /stores/:id/pickup-times
  Future<List<dynamic>> getPickupTimes(String id, {String? date}) async {
    final query = <String, dynamic>{};
    if (date != null) query['date'] = date;

    final response = await _apiClient.get('/stores/$id/pickup-times',
        queryParameters: query);
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final raw = _unwrap(response.data);
    return raw is List ? raw : [];
  }

  /// GET /stores/:storeId/gallery
  Future<List<dynamic>> getStoreGallery(String storeId) async {
    final response = await _apiClient.get('/stores/$storeId/gallery');
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final raw = _unwrap(response.data);
    return raw is List ? raw : [];
  }

  /// GET /stores/:storeId/hours
  Future<Map<String, dynamic>> getStoreHours(String storeId) async {
    final response = await _apiClient.get('/stores/$storeId/hours');
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// GET /stores/:storeId/location
  Future<Map<String, dynamic>> getStoreLocation(String storeId) async {
    final response = await _apiClient.get('/stores/$storeId/location');
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// GET /stores/:storeId/menu
  Future<Map<String, dynamic>> getStoreMenu(
    String storeId, {
    String? categoryId,
    bool? isFeatured,
    bool? isBestSelling,
    dynamic tags,
    double? minPrice,
    double? maxPrice,
    int page = 1,
    int limit = 20,
  }) async {
    final query = <String, dynamic>{'page': page, 'limit': limit};
    if (categoryId != null) query['categoryId'] = categoryId;
    if (isFeatured != null) query['isFeatured'] = isFeatured.toString();
    if (isBestSelling != null)
      query['isBestSelling'] = isBestSelling.toString();
    if (tags != null) query['tags'] = tags;
    if (minPrice != null) query['minPrice'] = minPrice;
    if (maxPrice != null) query['maxPrice'] = maxPrice;

    final response =
        await _apiClient.get('/stores/$storeId/menu', queryParameters: query);
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
