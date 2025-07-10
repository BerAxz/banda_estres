import 'package:dio/dio.dart';
import '../../models/session/session.dart';
import '../../core/api/api_client_factory.dart';
import '../../core/api/api_exception.dart';
import '../../core/api/api_response.dart';
import '../../core/api/services_interfaces.dart';

/// Implementación concreta del servicio de sesiones
class SessionService implements ISessionService {
  final ApiClientFactory _apiClientFactory;

  SessionService(_) : _apiClientFactory = ApiClientFactory();


  @override
  Future<PaginatedResponse<Session>> getSessionsByUserId({
    required int usuarioId,
    int page = 1,
    int pageSize = 20,
    bool? activa,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'page_size': pageSize,
        if (activa != null) 'activa': activa,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
      };

      final endpoint = '/usuarios/$usuarioId/sesiones';
      final client = _apiClientFactory.getClientForEndpoint(endpoint);
      
      final response = await client.get(
        endpoint,
        queryParameters: queryParams,
      );

      return PaginatedResponse.fromJson(
        response.data,
        (json) => Session.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }


  @override
  Future<PaginatedResponse<Session>> getSessions({
    int page = 1,
    int pageSize = 20,
    int? usuarioId,
    bool? activa,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'page_size': pageSize,
        if (usuarioId != null) 'usuario_id': usuarioId,
        if (activa != null) 'activa': activa,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
      };

      final endpoint = '/sesiones';
      final client = _apiClientFactory.getClientForEndpoint(endpoint);
      
      final response = await client.get(
        endpoint,
        queryParameters: queryParams,
      );

      return PaginatedResponse.fromJson(
        response.data,
        (json) => Session.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<Session>> getSessionById(int id) async {
    try {
      final endpoint = '/sesiones/$id';
      final client = _apiClientFactory.getClientForEndpoint(endpoint);
      
      final response = await client.get(endpoint);

      return ApiResponse.fromJson(
        response.data,
        (json) => Session.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<Session>> createSession({
    required int usuarioId,
    required int pulseraId,
    String? notas,
  }) async {
    try {
      final endpoint = '/sesiones';
      final client = _apiClientFactory.getClientForEndpoint(endpoint);
      
      final response = await client.post(
        endpoint,
        data: {
          'usuario_id': usuarioId,
          'pulsera_id': pulseraId,
          if (notas != null) 'notas': notas,
        },
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => Session.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<Session>> updateSession(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final endpoint = '/sesiones/$id';
      final client = _apiClientFactory.getClientForEndpoint(endpoint);
      
      final response = await client.put(
        endpoint,
        data: data,
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => Session.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<Session>> endSession(int id) async {
    try {
      final endpoint = '/sesiones/$id/end';
      final client = _apiClientFactory.getClientForEndpoint(endpoint);
      
      final response = await client.patch(
        endpoint,
        data: {
          'activa': false,
          'fecha_fin': DateTime.now().toIso8601String(),
        },
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => Session.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<void>> deleteSession(int id) async {
    try {
      final endpoint = '/sesiones/$id';
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

  @override
  Future<ApiResponse<Session?>> getActiveSession(int usuarioId) async {
    try {
      final endpoint = '/sesiones/active';
      final client = _apiClientFactory.getClientForEndpoint(endpoint);
      
      final response = await client.get(
        endpoint,
        queryParameters: {'usuario_id': usuarioId},
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => json != null 
            ? Session.fromJson(json as Map<String, dynamic>)
            : null,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
