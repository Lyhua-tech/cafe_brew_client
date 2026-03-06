import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  static const String _accessTokenKey = ApiClient.accessTokenKey;
  static const String _refreshTokenKey = 'refresh_token';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // ── Token management ────────────────────────────────────────────────────────

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

  // ── API Endpoints ───────────────────────────────────────────────────────────

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
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
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
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final data = _unwrap(response.data);
    if (data['accessToken'] != null) {
      await saveTokens(
          data['accessToken'] as String, data['refreshToken'] as String?);
    }
  }

  Future<User> login(String email, String password) async {
    final response = await _apiClient.post(
      '/auth/login',
      body: {'email': email, 'password': password},
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final data = _unwrap(response.data);
    final accessToken = data['accessToken'] as String?;
    if (accessToken == null) {
      throw Exception('Login failed: no access token in response');
    }
    await saveTokens(accessToken, data['refreshToken'] as String?);
    return User.fromJson(data['user'] ?? {});
  }

  Future<void> forgotPassword(String email) async {
    final response = await _apiClient.post(
      '/auth/forgot-password',
      body: {'email': email},
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
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
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
  }

  Future<void> verifyOtp(String email, String otpCode,
      {String? verificationType}) async {
    final body = <String, String>{
      'email': email,
      'otpCode': otpCode,
    };
    if (verificationType != null) {
      body['verificationType'] = verificationType;
    }
    final response = await _apiClient.post('/auth/verify-otp', body: body);
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
  }

  Future<void> resendOtp(String email, String verificationType) async {
    final response = await _apiClient.post(
      '/auth/resend-otp',
      body: {'email': email, 'verificationType': verificationType},
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
  }

  Future<User> getMe({bool isRetry = false}) async {
    final response = await _apiClient.get('/auth/me', withAuth: true);

    if (response.statusCode == 401) {
      // Only attempt a token refresh once.
      // If we already refreshed and still get 401, it's not a token-expiry
      // issue (e.g. suspended account, revoked token) — stop immediately.
      if (isRetry) {
        await clearTokens();
        throw Exception(_parseError(response.data));
      }
      final refreshed = await refreshToken();
      if (refreshed) {
        return getMe(isRetry: true); // one retry only
      } else {
        await clearTokens();
        throw Exception('Unauthorized');
      }
    } else if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }

    final data = _unwrap(response.data);
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
      final data = _unwrap(response.data);
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
      } catch (_) {
        // Ignore logout errors — tokens are already cleared locally
      }
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  /// Unwraps the standard `{ data: ... }` envelope if present.
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
