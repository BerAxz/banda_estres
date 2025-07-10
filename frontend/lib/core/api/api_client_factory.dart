import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_client.dart';

/// Factory para manejar diferentes instancias de ApiClient
/// Permite usar una mezcla de backend real y mock dependiendo del endpoint
class ApiClientFactory {
  // Instancia única de la factory (Singleton)
  static final ApiClientFactory _instance = ApiClientFactory._internal();
  factory ApiClientFactory() => _instance;
  ApiClientFactory._internal();
  
  // Cliente para el backend real
  final ApiClient _realClient = ApiClient.real();
  
  // Cliente para el mock
  final ApiClient _mockClient = ApiClient.mock();
  
  // Lista de endpoints que usan el backend real
  final List<String> _realEndpoints = [
    '/auth/login',
    '/auth/register',
    '/ws/', // WebSockets
    // Añade aquí otros endpoints que funcionen con el backend real
  ];

  /// Verifica si un endpoint debería usar el backend real
  bool _shouldUseRealBackend(String endpoint) {
    return _realEndpoints.any((pattern) => endpoint.contains(pattern));
  }
  
  /// Obtiene el cliente Dio adecuado según el endpoint
  Dio getClientForEndpoint(String endpoint) {
    if (_shouldUseRealBackend(endpoint)) {
      debugPrint('[API Factory] Using real backend for: $endpoint');
      return _realClient.client;
    } else {
      debugPrint('[API Factory] Using mock backend for: $endpoint');
      return _mockClient.client;
    }
  }
  
  /// Actualiza el token de autenticación en ambos clientes
  void updateAuthToken(String token) {
    _realClient.updateAuthToken(token);
    _mockClient.updateAuthToken(token);
  }
  
  /// Remueve el token de autenticación de ambos clientes
  void removeAuthToken() {
    _realClient.removeAuthToken();
    _mockClient.removeAuthToken();
  }
}
