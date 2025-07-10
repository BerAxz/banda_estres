import 'package:dio/dio.dart';
import '../../models/notification/notification_model.dart';
import '../../core/api/api_client_factory.dart';
import '../../core/api/api_exception.dart';
import '../../core/api/api_response.dart';
import '../../core/api/services_interfaces.dart';

/// Implementación concreta del servicio de notificaciones
class NotificationService implements INotificationService {
  final ApiClientFactory _apiClientFactory;

  NotificationService(_) : _apiClientFactory = ApiClientFactory();

  @override
  Future<PaginatedResponse<NotificationModel>> getNotifications({
    int page = 1,
    int pageSize = 20,
    int? usuarioId,
    bool? leida,
    String? tipo,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'page_size': pageSize,
        if (usuarioId != null) 'usuario_id': usuarioId,
        if (leida != null) 'leida': leida,
        if (tipo != null) 'tipo': tipo,
      };

      final endpoint = '/notifications';
      final client = _apiClientFactory.getClientForEndpoint(endpoint);
      
      final response = await client.get(
        endpoint,
        queryParameters: queryParams,
      );

      return PaginatedResponse.fromJson(
        response.data,
        (json) => NotificationModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<NotificationModel>> getNotificationById(int id) async {
    try {
      final endpoint = '/notifications/$id';
      final client = _apiClientFactory.getClientForEndpoint(endpoint);
      
      final response = await client.get(endpoint);

      return ApiResponse.fromJson(
        response.data,
        (json) => NotificationModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<NotificationModel>> createNotification({
    required int usuarioId,
    required String titulo,
    required String mensaje,
    required String tipo,
    Map<String, dynamic>? metadatos,
  }) async {
    try {
      final endpoint = '/notifications';
      final client = _apiClientFactory.getClientForEndpoint(endpoint);
      
      final response = await client.post(
        endpoint,
        data: {
          'usuario_id': usuarioId,
          'titulo': titulo,
          'mensaje': mensaje,
          'tipo': tipo,
          if (metadatos != null) 'metadatos': metadatos,
        },
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => NotificationModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<NotificationModel>> markAsRead(int id) async {
    try {
      final endpoint = '/notifications/$id/read';
      final client = _apiClientFactory.getClientForEndpoint(endpoint);
      
      final response = await client.patch(
        endpoint,
        data: {
          'leida': true,
          'fecha_leida': DateTime.now().toIso8601String(),
        },
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => NotificationModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<void>> markAllAsRead(int usuarioId) async {
    try {
      final endpoint = '/notifications/mark-all-read';
      final client = _apiClientFactory.getClientForEndpoint(endpoint);
      
      final response = await client.patch(
        endpoint,
        data: {
          'usuario_id': usuarioId,
        },
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => {},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<void>> deleteNotification(int id) async {
    try {
      final endpoint = '/notifications/$id';
      final client = _apiClientFactory.getClientForEndpoint(endpoint);
      
      final response = await client.delete(endpoint);

      return ApiResponse.fromJson(
        response.data,
        (json) => {},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
