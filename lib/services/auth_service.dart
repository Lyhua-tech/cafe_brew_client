import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  static const String _accessTokenKey = ApiClient.accessTokenKey;
  static const String _refreshTokenKey = 'refresh_token';

  // Helper to get SharedPreferences
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // Token management
  Future<void> saveTokens(String accessToken, String? refreshToken) async {
    final prefs = await _prefs;
    await prefs.setString(_accessTokenKey, accessToken);
    if (refreshToken != null) {
      await prefs.setString(_refreshTokenKey, refreshToken);
    }
  }

  Future<String?> getAccessToken() async {
    final prefs = await _prefs;
    return prefs.getString(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await _prefs;
    return prefs.getString(_refreshTokenKey);
  }

  Future<void> clearTokens() async {
    final prefs = await _prefs;
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  // API Endpoints

  Future<void> initiateRegister(
      String email, String fullName, String password) async {
    final response = await _apiClient.post(
      '/auth/register/initiate',
      body: {
        'email': email,
        'fullName': fullName,
        'password': password,
      },
    );
    if (response.statusCode >= 400) throw Exception(_parseError(response.body));
  }

  Future<void> verifyRegister(
      String fullName, String email, String password, String otpCode) async {
    final response = await _apiClient.post(
      '/auth/register/verify',
      body: {
        'fullName': fullName,
        'email': email,
        'password': password,
        'otpCode': otpCode,
      },
    );
    if (response.statusCode >= 400) throw Exception(_parseError(response.body));
    final body = jsonDecode(response.body);
    final data = body['data'] ?? body;
    if (data['accessToken'] != null) {
      await saveTokens(
          data['accessToken'] as String, data['refreshToken'] as String?);
    }
  }

  Future<User> login(String email, String password) async {
    final response = await _apiClient.post(
      '/auth/login',
      body: {
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode >= 400) throw Exception(_parseError(response.body));

    final body = jsonDecode(response.body);
    final data = body['data'] ?? body;
    final accessToken = data['accessToken'] as String?;
    if (accessToken == null)
      throw Exception('Login failed: no access token in response');
    await saveTokens(accessToken, data['refreshToken'] as String?);

    return User.fromJson(data['user'] ?? {});
  }

  Future<void> forgotPassword(String email) async {
    final response = await _apiClient.post(
      '/auth/forgot-password',
      body: {'email': email},
    );
    if (response.statusCode >= 400) throw Exception(_parseError(response.body));
  }

  Future<void> resetPassword(
      String email, String otpCode, String newPassword) async {
    final response = await _apiClient.post(
      '/auth/reset-password',
      body: {
        'email': email,
        'otpCode': otpCode,
        'newPassword': newPassword,
      },
    );
    if (response.statusCode >= 400) throw Exception(_parseError(response.body));
  }

  Future<void> verifyOtp(String email, String otpCode,
      {String? verificationType}) async {
    final body = {
      'email': email,
      'otpCode': otpCode,
    };
    if (verificationType != null) {
      body['verificationType'] = verificationType;
    }
    final response = await _apiClient.post(
      '/auth/verify-otp',
      body: body,
    );
    if (response.statusCode >= 400) throw Exception(_parseError(response.body));
  }

  Future<void> resendOtp(String email, String verificationType) async {
    final response = await _apiClient.post(
      '/auth/resend-otp',
      body: {
        'email': email,
        'verificationType': verificationType,
      },
    );
    if (response.statusCode >= 400) throw Exception(_parseError(response.body));
  }

  Future<User> getMe() async {
    final response = await _apiClient.get(
      '/auth/me',
      withAuth: true,
    );
    if (response.statusCode == 401) {
      // Trying to refresh token
      final refreshed = await refreshToken();
      if (refreshed) {
        return getMe();
      } else {
        await clearTokens();
        throw Exception('Unauthorized');
      }
    } else if (response.statusCode >= 400) {
      throw Exception(_parseError(response.body));
    }

    final body = jsonDecode(response.body);
    final data = body['data'] ?? body;
    return User.fromJson(data['user'] ?? data);
  }

  Future<bool> refreshToken() async {
    final rToken = await getRefreshToken();
    if (rToken == null) return false;

    final response = await _apiClient.post(
      '/auth/refresh-token',
      body: {'refreshToken': rToken},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final data = body['data'] ?? body;
      if (data['accessToken'] != null) {
        await saveTokens(
          data['accessToken'] as String,
          data['refreshToken'] as String?,
        );
        return true;
      }
    }

    return false;
  }

  Future<void> logout() async {
    final rToken = await getRefreshToken();
    await clearTokens();

    if (rToken != null) {
      try {
        await _apiClient.post(
          '/auth/logout',
          body: {'refreshToken': rToken},
        );
      } catch (e) {
        // Ignore logout errors, tokens are already cleared
      }
    }
  }

  String _parseError(String body) {
    try {
      final data = jsonDecode(body);
      return data['message'] ?? 'Unknown error occurred';
    } catch (e) {
      return 'Unknown error occurred';
    }
  }
}
