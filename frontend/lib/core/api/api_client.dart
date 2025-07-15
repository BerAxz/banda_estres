import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Client HTTP configurado para la aplicación
/// Aplica el principio de responsabilidad única (SRP)
class ApiClient {
  static const String _defaultBaseUrl = 'http://192.168.1.89:8000/api';
  static const String _mockBaseUrl = 'http://192.168.1.89:3000/api';
  static const Duration _connectTimeout = Duration(seconds: 30);
  static const Duration _receiveTimeout = Duration(seconds: 30);

  late final Dio _dio;
  final bool useMock;

  /// Constructor que permite especificar si se usa mock o no
  ApiClient({String? baseUrl, this.useMock = false}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? (useMock ? _mockBaseUrl : _defaultBaseUrl),
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ));

    _setupInterceptors();
  }
  
  /// Constructor nombrado para crear un cliente que use el backend real
  factory ApiClient.real() => ApiClient(useMock: false);
  
  /// Constructor nombrado para crear un cliente que use mockoon
  factory ApiClient.mock() => ApiClient(baseUrl: _mockBaseUrl, useMock: true);

  /// Configura los interceptores para logging y manejo de errores
  void _setupInterceptors() {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint('[API] $obj'),
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
