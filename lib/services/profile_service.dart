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
