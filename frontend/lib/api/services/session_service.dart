import 'package:dio/dio.dart';
import '../../models/session/session.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../core/api/api_response.dart';
import '../../core/api/services_interfaces.dart';

/// Implementación concreta del servicio de sesiones
class SessionService implements ISessionService {
  final ApiClient _apiClient;

  SessionService(this._apiClient);


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

      final response = await _apiClient.client.get(
        '/usuarios/$usuarioId/sesiones',
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

      final response = await _apiClient.client.get(
        '/sesiones',
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
      final response = await _apiClient.client.get('/sesiones/$id');

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
      final response = await _apiClient.client.post(
        '/sesiones',
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
      final response = await _apiClient.client.put(
        '/sesiones/$id',
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
      final response = await _apiClient.client.patch(
        '/sesiones/$id/end',
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
      final response = await _apiClient.client.delete('/sesiones/$id');

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
      final response = await _apiClient.client.get(
        '/sesiones/active',
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
