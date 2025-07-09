import 'package:dio/dio.dart';
import '../../models/physiological_data/physiological_data.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../core/api/api_response.dart';
import '../../core/api/services_interfaces.dart';

/// Implementación concreta del servicio de datos fisiológicos
class PhysiologicalDataService implements IPhysiologicalDataService {
  final ApiClient _apiClient;

  PhysiologicalDataService(this._apiClient);

  @override
  Future<PaginatedResponse<PhysiologicalData>> getPhysiologicalData({
    int page = 1,
    int pageSize = 20,
    int? usuarioId,
    int? sesionId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'page_size': pageSize,
        if (usuarioId != null) 'usuario_id': usuarioId,
        if (sesionId != null) 'sesion_id': sesionId,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
      };

      final response = await _apiClient.client.get(
        '/physiological-data',
        queryParameters: queryParams,
      );

      return PaginatedResponse.fromJson(
        response.data,
        (json) => PhysiologicalData.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<PhysiologicalData>> getPhysiologicalDataById(int id) async {
    try {
      final response = await _apiClient.client.get('/physiological-data/$id');

      return ApiResponse.fromJson(
        response.data,
        (json) => PhysiologicalData.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<PhysiologicalData>> createPhysiologicalData({
    required int sesionId,
    required int usuarioId,
    required int pulseraId,
    required DateTime timestamp,
    required int bpm,
    required int spo2,
    required double temperatura,
    required int calidadSenal,
  }) async {
    try {
      final response = await _apiClient.client.post(
        '/physiological-data',
        data: {
          'sesion_id': sesionId,
          'usuario_id': usuarioId,
          'pulsera_id': pulseraId,
          'timestamp': timestamp.toIso8601String(),
          'bpm': bpm,
          'spo2': spo2,
          'temperatura': temperatura,
          'calidad_senal': calidadSenal,
        },
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => PhysiologicalData.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getStatistics({
    required int usuarioId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'usuario_id': usuarioId,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
      };

      final response = await _apiClient.client.get(
        '/physiological-data/statistics',
        queryParameters: queryParams,
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<List<Map<String, dynamic>>>> getTimeSeriesData({
    required int usuarioId,
    required DateTime startDate,
    required DateTime endDate,
    String interval = 'hour',
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'usuario_id': usuarioId,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'interval': interval,
      };

      final response = await _apiClient.client.get(
        '/physiological-data/time-series',
        queryParameters: queryParams,
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => (json as List).cast<Map<String, dynamic>>(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
