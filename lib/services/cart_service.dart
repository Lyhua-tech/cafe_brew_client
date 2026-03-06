import '../models/cart.dart';
import 'api_client.dart';

class CartService {
  final ApiClient _apiClient = ApiClient();

  /// GET /cart
  Future<Cart> getCart() async {
    final response = await _apiClient.get('/cart', withAuth: true);
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return Cart.fromJson(_unwrapMap(response.data));
  }

  /// POST /cart/items
  Future<Cart> addItem(
    String productId,
    int quantity, {
    Map<String, dynamic>? customization,
    List<String>? addOns,
    String? notes,
  }) async {
    final payload = {
      'productId': productId,
      'quantity': quantity,
      if (customization != null) 'customization': customization,
      if (addOns != null) 'addOns': addOns,
      if (notes != null) 'notes': notes,
    };

    final response =
        await _apiClient.post('/cart/items', body: payload, withAuth: true);
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return Cart.fromJson(_unwrapMap(response.data));
  }

  /// PATCH /cart/items/:itemId
  Future<Cart> updateItemQuantity(String itemId, int quantity) async {
    final response = await _apiClient.patch('/cart/items/$itemId',
        body: {'quantity': quantity}, withAuth: true);
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return Cart.fromJson(_unwrapMap(response.data));
  }

  /// DELETE /cart/items/:itemId
  Future<Cart> removeItem(String itemId) async {
    final response =
        await _apiClient.delete('/cart/items/$itemId', withAuth: true);
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return Cart.fromJson(_unwrapMap(response.data));
  }

  /// DELETE /cart
  Future<Cart> clearCart() async {
    final response = await _apiClient.delete('/cart', withAuth: true);
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return Cart.fromJson(_unwrapMap(response.data));
  }

  /// POST /cart/validate
  Future<CartValidation> validateCart() async {
    final response = await _apiClient.post('/cart/validate', withAuth: true);
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return CartValidation.fromJson(_unwrapMap(response.data));
  }

  /// PATCH /cart/address
  Future<Cart> setAddress(String addressId) async {
    final response = await _apiClient.patch('/cart/address',
        body: {'addressId': addressId}, withAuth: true);
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return Cart.fromJson(_unwrapMap(response.data));
  }

  /// PATCH /cart/notes
  Future<Cart> setNotes(String notes) async {
    final response = await _apiClient.patch('/cart/notes',
        body: {'notes': notes}, withAuth: true);
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return Cart.fromJson(_unwrapMap(response.data));
  }

  /// GET /cart/summary
  Future<CartSummary> getSummary() async {
    final response = await _apiClient.get('/cart/summary', withAuth: true);
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return CartSummary.fromJson(_unwrapMap(response.data));
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
