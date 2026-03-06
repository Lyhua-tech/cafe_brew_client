import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── App-wide logger (kept from before) ──────────────────────────────────────

class AppLogger {
  AppLogger._();

  static final Logger log = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 100,
      colors: true,
      printEmojis: true,
    ),
    level: kDebugMode ? Level.trace : Level.off,
  );
}

// ─── Token interceptor ────────────────────────────────────────────────────────

class _TokenInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['withAuth'] == true) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(ApiClient.accessTokenKey);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}

// ─── Logging interceptor ──────────────────────────────────────────────────────

class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final sanitizedHeaders = Map<String, dynamic>.from(options.headers);
    if (sanitizedHeaders.containsKey('Authorization')) {
      sanitizedHeaders['Authorization'] = 'Bearer [REDACTED]';
    }
    AppLogger.log.i(
      '⬆️  ${options.method} ${options.path}\n'
      'Headers : $sanitizedHeaders\n'
      'Body    : ${options.data ?? 'none'}',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.log.d(
      '⬇️  ${response.requestOptions.method} '
      '${response.requestOptions.path} → ${response.statusCode}\n'
      '${response.data}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.log.e(
      '⬇️  ${err.requestOptions.method} '
      '${err.requestOptions.path} → ${err.response?.statusCode}\n'
      '${err.response?.data ?? err.message}',
    );
    handler.next(err);
  }
}

// ─── ApiClient ────────────────────────────────────────────────────────────────

class ApiClient {
  ApiClient._internal()
      : _dio = Dio(
          BaseOptions(
            baseUrl: dotenv.env['BASE_URL'] ?? 'http://localhost:3000/api',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {'Content-Type': 'application/json'},
            validateStatus: (_) => true,
          ),
        ) {
    _dio.interceptors.addAll([
      _TokenInterceptor(),
      _LogInterceptor(),
    ]);
  }

  static ApiClient? _instance;
  factory ApiClient() => _instance ??= ApiClient._internal();

  final Dio _dio;

  static const String accessTokenKey = 'access_token';

  Future<Response<dynamic>> get(
    String path, {
    bool withAuth = false,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(extra: {'withAuth': withAuth}),
    );
  }

  Future<Response<dynamic>> post(
    String path, {
    Object? body,
    bool withAuth = false,
  }) {
    return _dio.post(
      path,
      data: body,
      options: Options(extra: {'withAuth': withAuth}),
    );
  }

  Future<Response<dynamic>> put(
    String path, {
    Object? body,
    bool withAuth = false,
  }) {
    return _dio.put(
      path,
      data: body,
      options: Options(extra: {'withAuth': withAuth}),
    );
  }

  Future<Response<dynamic>> patch(
    String path, {
    Object? body,
    bool withAuth = false,
  }) {
    return _dio.patch(
      path,
      data: body,
      options: Options(extra: {'withAuth': withAuth}),
    );
  }

  Future<Response<dynamic>> delete(
    String path, {
    Object? body,
    bool withAuth = false,
  }) {
    return _dio.delete(
      path,
      data: body,
      options: Options(extra: {'withAuth': withAuth}),
    );
  }
}
