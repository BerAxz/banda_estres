import 'package:dio/dio.dart';
import '../../models/dispositivo/dispositivo.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../core/api/api_response.dart';
import '../../core/api/services_interfaces.dart';

/// Implementación concreta del servicio de dispositivos
class DeviceService implements IDeviceService {
  final ApiClient _apiClient;

  DeviceService(this._apiClient);

  @override
  Future<PaginatedResponse<Dispositivo>> getDevices({
    int page = 1,
    int pageSize = 20,
    String? search,
    bool? activo,
    int? usuarioAsignado,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'page_size': pageSize,
        if (search != null) 'search': search,
        if (activo != null) 'activo': activo,
        if (usuarioAsignado != null) 'usuario_asignado': usuarioAsignado,
      };

      final response = await _apiClient.client.get(
        '/devices',
        queryParameters: queryParams,
      );

      return PaginatedResponse.fromJson(
        response.data,
        (json) => Dispositivo.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<Dispositivo>> getDeviceById(int id) async {
    try {
      final response = await _apiClient.client.get('/devices/$id');

      return ApiResponse.fromJson(
        response.data,
        (json) => Dispositivo.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<Dispositivo>> createDevice({
    required String numeroSerie,
    required String modelo,
    String? ubicacion,
  }) async {
    try {
      final response = await _apiClient.client.post(
        '/devices',
        data: {
          'numero_serie': numeroSerie,
          'modelo': modelo,
          if (ubicacion != null) 'ubicacion': ubicacion,
        },
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => Dispositivo.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<Dispositivo>> updateDevice(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiClient.client.put(
        '/devices/$id',
        data: data,
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => Dispositivo.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<void>> deleteDevice(int id) async {
    try {
      final response = await _apiClient.client.delete('/devices/$id');

      return ApiResponse.fromJson(
        response.data,
        (json) => null,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<Dispositivo>> assignDevice({
    required int deviceId,
    required int usuarioId,
  }) async {
    try {
      final response = await _apiClient.client.patch(
        '/devices/$deviceId/assign',
        data: {
          'usuario_asignado': usuarioId,
        },
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => Dispositivo.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<Dispositivo>> unassignDevice(int deviceId) async {
    try {
      final response = await _apiClient.client.patch(
        '/devices/$deviceId/unassign',
        data: {
          'usuario_asignado': null,
        },
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => Dispositivo.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getDeviceStatus(int id) async {
    try {
      final response = await _apiClient.client.get('/devices/$id/status');

      return ApiResponse.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
