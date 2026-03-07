import 'api_client.dart';

class AddressService {
  final ApiClient _apiClient = ApiClient();

  /// GET /users/me/addresses
  Future<List<dynamic>> getAddresses() async {
    final response = await _apiClient.get(
      '/users/me/addresses',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final raw = _unwrap(response.data);
    return raw is List ? raw : [];
  }

  /// POST /users/me/addresses
  Future<Map<String, dynamic>> addAddress(
      Map<String, dynamic> addressData) async {
    final response = await _apiClient.post(
      '/users/me/addresses',
      body: addressData,
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// PATCH /cart/address
  Future<Map<String, dynamic>> setAddressForCart(String addressId) async {
    final response = await _apiClient.patch(
      '/cart/address',
      body: {'addressId': addressId},
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// Helper logic to bypass the "address required" checkout rule.
  /// Checks if the user has an address, creates a default "Pickup - CAMKO" address if not,
  /// and applies it to the cart.
  Future<String> ensurePickupAddressForCart() async {
    final addresses = await getAddresses();

    String addressId;
    if (addresses.isEmpty) {
      // Create a dummy CAMKO address for store pickups
      final createdResult = await addAddress({
        "label": "Pickup",
        "fullName": "Pickup User",
        "phoneNumber": "0123456789",
        "addressLine1": "CAMKO - 123 Main St, Apt 4B",
        "city": "Phnom Penh",
        "state": "Phnom Penh",
        "country": "Cambodia",
      });
      addressId = createdResult['_id'] ?? createdResult['id'] ?? '';
    } else {
      // Just use the first available address
      final firstAddress = addresses.first;
      addressId = firstAddress['_id'] ?? firstAddress['id'] ?? '';
    }

    if (addressId.isNotEmpty) {
      await setAddressForCart(addressId);
    }

    return addressId;
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
