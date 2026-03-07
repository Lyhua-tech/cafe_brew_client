import 'dart:io';
import 'api_client.dart';
import 'package:dio/dio.dart'; // Using Dio MultipartFile assuming ApiClient uses Dio

class ConfigService {
  final ApiClient _apiClient = ApiClient();

  /// GET /config/app
  Future<Map<String, dynamic>> getAppConfig() async {
    final response = await _apiClient.get(
      '/config/app',
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// GET /config/delivery-zones
  Future<List<dynamic>> getDeliveryZones() async {
    final response = await _apiClient.get(
      '/config/delivery-zones',
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    final raw = _unwrap(response.data);
    return raw is List ? raw : [];
  }

  /// GET /config/health
  Future<Map<String, dynamic>> getHealth() async {
    final response = await _apiClient.get(
      '/config/health',
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// POST /upload
  Future<Map<String, dynamic>> uploadFile(File file) async {
    // Assuming _apiClient uses Dio under the hood
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });

    final response = await _apiClient.post(
      '/upload',
      body: formData,
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
    return _unwrapMap(response.data);
  }

  /// DELETE /upload
  Future<void> deleteFile(String fileIdOrUrl) async {
    final response = await _apiClient.delete(
      '/upload',
      body: {
        'file': fileIdOrUrl
      }, // Specific payload might vary backend implementation
      withAuth: true,
    );
    if ((response.statusCode ?? 0) >= 400) {
      throw Exception(_parseError(response.data));
    }
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
