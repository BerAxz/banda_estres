import 'package:dio/dio.dart';

/// Client HTTP configurado para la aplicación
/// Aplica el principio de responsabilidad única (SRP)
class ApiClient {
  static const String _baseUrl = 'http://192.168.1.82:3000/api';
  static const Duration _connectTimeout = Duration(seconds: 30);
  static const Duration _receiveTimeout = Duration(seconds: 30);

  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ));

    _setupInterceptors();
  }

  /// Configura los interceptores para logging y manejo de errores
  void _setupInterceptors() {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('[API] $obj'),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Aquí se puede agregar el token de autenticación
          // options.headers['Authorization'] = 'Bearer $token';
          handler.next(options);
        },
        onError: (error, handler) {
          // Manejo centralizado de errores
          handler.next(error);
        },
      ),
    );
  }

  /// Getter para acceder al cliente Dio
  Dio get client => _dio;

  /// Actualiza el token de autenticación
  void updateAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remueve el token de autenticación
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}
