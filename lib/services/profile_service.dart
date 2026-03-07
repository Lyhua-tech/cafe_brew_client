import '../models/user.dart';
import 'api_client.dart';

class ProfileService {
  final ApiClient _apiClient = ApiClient();

  Future<User> getProfile() async {
    final response = await _apiClient.get('/profile', withAuth: true);
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final data = _unwrap(response.data);
    return User.fromJson(data);
  }

  Future<User> updateProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? dateOfBirth,
    String? gender,
  }) async {
    final payload = <String, dynamic>{};
    if (fullName != null && fullName.isNotEmpty) {
      payload['fullName'] = fullName;
    }
    if (email != null && email.isNotEmpty) {
      payload['email'] = email;
    }
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      payload['phoneNumber'] = phoneNumber;
    }
    if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
      payload['dateOfBirth'] = dateOfBirth;
    }
    if (gender != null && gender.isNotEmpty) {
      payload['gender'] = gender;
    }

    final response = await _apiClient.put(
      '/profile',
      body: payload,
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final data = _unwrap(response.data);
    return User.fromJson(data);
  }

  Future<User> updateProfileImage(String imageUrl) async {
    final response = await _apiClient.post(
      '/profile/image',
      body: {'imageUrl': imageUrl},
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final data = _unwrap(response.data);
    return User.fromJson(data);
  }

  Future<Map<String, dynamic>> updatePassword(
      String currentPassword, String newPassword) async {
    final response = await _apiClient.put(
      '/profile/password',
      body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrap(response.data);
  }

  Future<User> updateSettings(Map<String, dynamic> settings) async {
    final response = await _apiClient.put(
      '/profile/settings',
      body: settings,
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final data = _unwrap(response.data);
    return User.fromJson(data);
  }

  Future<Map<String, dynamic>> getReferralStats() async {
    final response = await _apiClient.get(
      '/profile/referral',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrap(response.data);
  }

  Future<void> deleteAccount(String password, [String? reason]) async {
    final body = <String, dynamic>{'password': password};
    if (reason != null) body['reason'] = reason;

    final response = await _apiClient.delete(
      '/profile',
      body: body,
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
  }

  Future<List<dynamic>> getAddresses() async {
    final response = await _apiClient.get(
      '/users/me/addresses',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final val = response.data;
    if (val is List) return val;
    if (val is Map && val['data'] is List) return val['data'];
    return [];
  }

  Future<Map<String, dynamic>> addAddress(Map<String, dynamic> payload) async {
    final response = await _apiClient.post(
      '/users/me/addresses',
      body: payload,
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrap(response.data);
  }

  Future<Map<String, dynamic>> updateAddress(
      String addressId, Map<String, dynamic> payload) async {
    final response = await _apiClient.patch(
      '/users/me/addresses/$addressId',
      body: payload,
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrap(response.data);
  }

  Future<void> deleteAddress(String addressId) async {
    final response = await _apiClient.delete(
      '/users/me/addresses/$addressId',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
  }

  Future<Map<String, dynamic>> setDefaultAddress(String addressId) async {
    final response = await _apiClient.patch(
      '/users/me/addresses/$addressId/default',
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrap(response.data);
  }

  Map<String, dynamic> _unwrap(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      return raw['data'] is Map<String, dynamic>
          ? raw['data'] as Map<String, dynamic>
          : raw;
    }
    return {};
  }

  String _parseError(dynamic data) {
    if (data is Map) {
      return (data['message'] as String?) ?? 'Unknown error occurred';
    }
    return 'Unknown error occurred';
  }
}
