import 'package:dio/dio.dart';

/// Excepción personalizada para errores de la API
/// Facilita el manejo de errores de manera consistente
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  factory ApiException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const ApiException(
          message: 'Tiempo de conexión agotado',
          statusCode: null,
        );
      case DioExceptionType.sendTimeout:
        return const ApiException(
          message: 'Tiempo de envío agotado',
          statusCode: null,
        );
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'Tiempo de respuesta agotado',
          statusCode: null,
        );
      case DioExceptionType.badResponse:
        return ApiException(
          message: _getErrorMessage(error.response),
          statusCode: error.response?.statusCode,
          data: error.response?.data,
        );
      case DioExceptionType.cancel:
        return const ApiException(
          message: 'Solicitud cancelada',
          statusCode: null,
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'Error de conexión con el servidor',
          statusCode: null,
        );
      default:
        return const ApiException(
          message: 'Error desconocido',
          statusCode: null,
        );
    }
  }

  static String _getErrorMessage(Response? response) {
    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      
      // Buscar mensajes de error comunes
      if (data.containsKey('message')) {
        return data['message'].toString();
      }
      if (data.containsKey('error')) {
        return data['error'].toString();
      }
      if (data.containsKey('detail')) {
        return data['detail'].toString();
      }
    }

    // Mensajes por código de estado HTTP
    switch (response?.statusCode) {
      case 400:
        return 'Solicitud incorrecta';
      case 401:
        return 'No autorizado';
      case 403:
        return 'Acceso prohibido';
      case 404:
        return 'Recurso no encontrado';
      case 500:
        return 'Error interno del servidor';
      default:
        return 'Error del servidor (${response?.statusCode})';
    }
  }

  @override
  String toString() => 'ApiException: $message';
}
