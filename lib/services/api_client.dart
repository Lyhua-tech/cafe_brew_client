import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static final String _baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:3000/api';

  static const String accessTokenKey = 'access_token';

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  Future<Map<String, String>> _headers({bool withAuth = false}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (withAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(accessTokenKey);
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<http.Response> get(String path, {bool withAuth = false}) async {
    return _client.get(
      _uri(path),
      headers: await _headers(withAuth: withAuth),
    );
  }

  Future<http.Response> post(
    String path, {
    Object? body,
    bool withAuth = false,
  }) async {
    return _client.post(
      _uri(path),
      headers: await _headers(withAuth: withAuth),
      body: body == null ? null : jsonEncode(body),
    );
  }
}
