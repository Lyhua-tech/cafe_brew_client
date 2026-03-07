import 'api_client.dart';

class OrderService {
  final ApiClient _apiClient = ApiClient();

  /// GET /orders
  Future<Map<String, dynamic>> getOrders({
    int page = 1,
    int limit = 20,
    String? status,
    String? storeId,
    String? dateFrom,
    String? dateTo,
  }) async {
    final query = <String, dynamic>{'page': page, 'limit': limit};
    if (status != null) query['status'] = status;
    if (storeId != null) query['storeId'] = storeId;
    if (dateFrom != null) query['dateFrom'] = dateFrom;
    if (dateTo != null) query['dateTo'] = dateTo;

    final response = await _apiClient.get(
      '/orders',
      queryParameters: query,
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// GET /orders/:orderId
  Future<Map<String, dynamic>> getOrder(String orderId) async {
    final response = await _apiClient.get(
      '/orders/$orderId',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// GET /orders/:orderId/tracking
  Future<Map<String, dynamic>> getOrderTracking(String orderId) async {
    final response = await _apiClient.get(
      '/orders/$orderId/tracking',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// GET /orders/:orderId/invoice
  /// Returns a byte array (List<int>) of the PDF PDF invoice.
  Future<List<int>> getOrderInvoice(String orderId) async {
    final response = await _apiClient.get(
      '/orders/$orderId/invoice',
      withAuth: true,
      // To properly get a byte array you may need configuration on ApiClient (e.g. responseType: bytes)
      // Since ApiClient is custom, we'll try to get it out from response.data directly.
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return (response.data as List).cast<int>();
  }

  /// POST /orders/:orderId/cancel
  Future<Map<String, dynamic>> cancelOrder(
      String orderId, String reason) async {
    final response = await _apiClient.post(
      '/orders/$orderId/cancel',
      body: {'reason': reason},
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// POST /orders/:orderId/rate
  Future<void> rateOrder(String orderId, int rating, {String? review}) async {
    final payload = <String, dynamic>{'rating': rating};
    if (review != null) payload['review'] = review;

    final response = await _apiClient.post(
      '/orders/$orderId/rate',
      body: payload,
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
  }

  /// POST /orders/:orderId/reorder
  Future<void> reorder(String orderId) async {
    final response = await _apiClient.post(
      '/orders/$orderId/reorder',
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
