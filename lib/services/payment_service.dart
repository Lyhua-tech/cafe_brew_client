import 'api_client.dart';

class PaymentService {
  final ApiClient _apiClient = ApiClient();

  /// POST /payments/:orderId/intent
  Future<Map<String, dynamic>> createIntent(String orderId) async {
    final response = await _apiClient.post(
      '/payments/$orderId/intent',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// POST /payments/:orderId/confirm
  Future<Map<String, dynamic>> confirmPayment(
    String orderId,
    String paymentMethod, {
    String? transactionId,
    Map<String, dynamic>? paymentDetails,
  }) async {
    final payload = <String, dynamic>{'paymentMethod': paymentMethod};
    if (transactionId != null) payload['transactionId'] = transactionId;
    if (paymentDetails != null) payload['paymentDetails'] = paymentDetails;

    final response = await _apiClient.post(
      '/payments/$orderId/confirm',
      body: payload,
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
