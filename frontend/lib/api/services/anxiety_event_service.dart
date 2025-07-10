import 'package:dio/dio.dart';
import '../../models/anxiety_event/anxiety_event.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../core/api/api_response.dart';
import '../../core/api/services_interfaces.dart';

/// Implementación concreta del servicio de eventos de ansiedad
class AnxietyEventService implements IAnxietyEventService {
  final ApiClient _apiClient;

  AnxietyEventService(this._apiClient);

  @override
  Future<PaginatedResponse<AnxietyEvent>> getAnxietyEventsByUserId({
    required int usuarioId,
    int page = 1,
    int pageSize = 20,
    int? sesionId,
    AnxietyLevel? nivelAnsiedad,
    DateTime? startDate,
    DateTime? endDate,
    bool? resuelto,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'page_size': pageSize,
        if (sesionId != null) 'sesion_id': sesionId,
        if (nivelAnsiedad != null) 'nivel_ansiedad': nivelAnsiedad.name,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
        if (resuelto != null) 'resuelto': resuelto,
      };

      final response = await _apiClient.client.get(
        '/usuarios/$usuarioId/eventos_ansiedad',
        queryParameters: queryParams,
      );

      return PaginatedResponse.fromJson(
        response.data,
        (json) => AnxietyEvent.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<AnxietyEvent>> getAnxietyEventById(int id) async {
    try {
      final response = await _apiClient.client.get('/anxiety-events/$id');

      return ApiResponse.fromJson(
        response.data,
        (json) => AnxietyEvent.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<AnxietyEvent>> createAnxietyEvent({
    required int usuarioId,
    required int sesionId,
    required DateTime timestamp,
    required AnxietyLevel nivelAnsiedad,
    required int bpmMomento,
    required int spo2Momento,
    required double temperaturaMomento,
    required int duracionMinutos,
    required Map<String, dynamic> factoresDetectados,
    required String accionTomada,
    String? notasUsuario,
  }) async {
    try {
      final response = await _apiClient.client.post(
        '/anxiety-events',
        data: {
          'usuario_id': usuarioId,
          'sesion_id': sesionId,
          'timestamp': timestamp.toIso8601String(),
          'nivel_ansiedad': nivelAnsiedad.name,
          'bpm_momento': bpmMomento,
          'spo2_momento': spo2Momento,
          'temperatura_momento': temperaturaMomento,
          'duracion_minutos': duracionMinutos,
          'factores_detectados': factoresDetectados,
          'accion_tomada': accionTomada,
          'notas_usuario': notasUsuario ?? '',
        },
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => AnxietyEvent.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<AnxietyEvent>> updateAnxietyEvent(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiClient.client.put(
        '/anxiety-events/$id',
        data: data,
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => AnxietyEvent.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<void>> deleteAnxietyEvent(int id) async {
    try {
      final response = await _apiClient.client.delete('/anxiety-events/$id');

      return ApiResponse.fromJson(
        response.data,
        (json) => {},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<AnxietyEvent>> markAsResolved(
    int id, {
    String? notasUsuario,
  }) async {
    try {
      final response = await _apiClient.client.patch(
        '/anxiety-events/$id/resolve',
        data: {
          'resuelto': true,
          if (notasUsuario != null) 'notas_usuario': notasUsuario,
        },
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => AnxietyEvent.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
