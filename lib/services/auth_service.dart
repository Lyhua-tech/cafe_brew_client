import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static final String _baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:3000/api';

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // Helper to get SharedPreferences
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // Helper for headers
  Future<Map<String, String>> _getHeaders({bool withAuth = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (withAuth) {
      final token = await getAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

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
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register/initiate'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'email': email,
        'fullName': fullName,
        'password': password,
      }),
    );
    if (response.statusCode >= 400) throw Exception(_parseError(response.body));
  }

  Future<void> verifyRegister(
      String fullName, String email, String password, String otpCode) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register/verify'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'fullName': fullName,
        'email': email,
        'password': password,
        'otpCode': otpCode,
      }),
    );
    if (response.statusCode >= 400) throw Exception(_parseError(response.body));
    final data = jsonDecode(response.body);
    if (data['accessToken'] != null) {
      await saveTokens(data['accessToken'], data['refreshToken']);
    }
  }

  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode >= 400) throw Exception(_parseError(response.body));

    final data = jsonDecode(response.body);
    await saveTokens(data['accessToken'], data['refreshToken']);

    return User.fromJson(data['user'] ?? {});
  }

  Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/forgot-password'),
      headers: await _getHeaders(),
      body: jsonEncode({'email': email}),
    );
    if (response.statusCode >= 400) throw Exception(_parseError(response.body));
  }

  Future<void> resetPassword(
      String email, String otpCode, String newPassword) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/reset-password'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'email': email,
        'otpCode': otpCode,
        'newPassword': newPassword,
      }),
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
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/verify-otp'),
      headers: await _getHeaders(),
      body: jsonEncode(body),
    );
    if (response.statusCode >= 400) throw Exception(_parseError(response.body));
  }

  Future<void> resendOtp(String email, String verificationType) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/resend-otp'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'email': email,
        'verificationType': verificationType,
      }),
    );
    if (response.statusCode >= 400) throw Exception(_parseError(response.body));
  }

  Future<User> getMe() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/auth/me'),
      headers: await _getHeaders(withAuth: true),
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

    final data = jsonDecode(response.body);
    return User.fromJson(
        data['user'] ?? data); // Adjust according to API response structure
  }

  Future<bool> refreshToken() async {
    final rToken = await getRefreshToken();
    if (rToken == null) return false;

    final response = await http.post(
      Uri.parse('$_baseUrl/auth/refresh-token'),
      headers: await _getHeaders(),
      body: jsonEncode({'refreshToken': rToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['accessToken'] != null) {
        await saveTokens(data['accessToken'], data['refreshToken']);
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
        await http.post(
          Uri.parse('$_baseUrl/auth/logout'),
          headers: await _getHeaders(),
          body: jsonEncode({'refreshToken': rToken}),
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
