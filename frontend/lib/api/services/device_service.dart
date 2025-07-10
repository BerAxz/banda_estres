import 'package:dio/dio.dart';
import '../../models/dispositivo/dispositivo.dart';
import '../../core/api/api_client_factory.dart';
import '../../core/api/api_exception.dart';
import '../../core/api/api_response.dart';
import '../../core/api/services_interfaces.dart';

/// Implementación concreta del servicio de dispositivos
class DeviceService implements IDeviceService {
  final ApiClientFactory _apiClientFactory;

  DeviceService(_) : _apiClientFactory = ApiClientFactory();

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

      final endpoint = '/devices';
      final client = _apiClientFactory.getClientForEndpoint(endpoint);
      
      final response = await client.get(
        endpoint,
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
      final endpoint = '/devices/$id';
      final client = _apiClientFactory.getClientForEndpoint(endpoint);
      final response = await client.get(endpoint);

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
      final endpoint = '/devices';
      final client = _apiClientFactory.getClientForEndpoint(endpoint);
      
      final response = await client.post(
        endpoint,
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
      final endpoint = '/devices/$id';
      final client = _apiClientFactory.getClientForEndpoint(endpoint);
      
      final response = await client.put(
        endpoint,
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
      final endpoint = '/devices/$id';
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
  Future<ApiResponse<Dispositivo>> assignDevice({
    required int deviceId,
    required int usuarioId,
  }) async {
    try {
      final endpoint = '/devices/$deviceId/assign';
      final client = _apiClientFactory.getClientForEndpoint(endpoint);
      
      final response = await client.patch(
        endpoint,
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
      final endpoint = '/devices/$deviceId/unassign';
      final client = _apiClientFactory.getClientForEndpoint(endpoint);
      
      final response = await client.patch(
        endpoint,
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
      final endpoint = '/devices/$id/status';
      final client = _apiClientFactory.getClientForEndpoint(endpoint);
      
      final response = await client.get(endpoint);

      return ApiResponse.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
