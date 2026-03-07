import 'api_client.dart';

class CheckoutService {
  final ApiClient _apiClient = ApiClient();

  /// POST /checkout/validate
  Future<Map<String, dynamic>> validateCheckout() async {
    final response = await _apiClient.post(
      '/checkout/validate',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// POST /checkout
  Future<Map<String, dynamic>> createCheckout() async {
    final response = await _apiClient.post(
      '/checkout',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// GET /checkout/:checkoutId
  Future<Map<String, dynamic>> getCheckout(String checkoutId) async {
    final response = await _apiClient.get(
      '/checkout/$checkoutId',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// GET /checkout/payment-methods
  Future<List<dynamic>> getPaymentMethods() async {
    final response = await _apiClient.get(
      '/checkout/payment-methods',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final raw = _unwrap(response.data);
    return raw is List ? raw : [];
  }

  /// POST /checkout/:checkoutId/apply-coupon
  Future<Map<String, dynamic>> applyCoupon(
      String checkoutId, String couponCode) async {
    final response = await _apiClient.post(
      '/checkout/$checkoutId/apply-coupon',
      body: {'couponCode': couponCode},
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// DELETE /checkout/:checkoutId/remove-coupon
  Future<Map<String, dynamic>> removeCoupon(String checkoutId) async {
    final response = await _apiClient.delete(
      '/checkout/$checkoutId/remove-coupon',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// GET /checkout/delivery-charges
  Future<Map<String, dynamic>> getDeliveryCharges(String addressId) async {
    final response = await _apiClient.get(
      '/checkout/delivery-charges',
      queryParameters: {'addressId': addressId},
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// POST /checkout/:checkoutId/confirm
  Future<Map<String, dynamic>> confirmCheckout(
      String checkoutId, String paymentMethod) async {
    final response = await _apiClient.post(
      '/checkout/$checkoutId/confirm',
      body: {'paymentMethod': paymentMethod},
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
