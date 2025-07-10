import 'package:dio/dio.dart';
import '../../models/user/user.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../core/api/api_response.dart';
import '../../core/api/services_interfaces.dart';

/// Implementación concreta del servicio de usuarios
/// Aplica el principio de responsabilidad única (SRP)
class UserService implements IUserService {
  final ApiClient _apiClient;

  UserService(this._apiClient);

  @override
  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.client.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
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
  Future<ApiResponse<Map<String, dynamic>>> logout() async {
    try {
      final response = await _apiClient.client.post('/auth/logout');
      
      return ApiResponse.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<User>> register({
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    required String tipoUsuario,
  }) async {
    try {
      final response = await _apiClient.client.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'nombre': nombre,
          'apellido': apellido,
          'tipo_usuario': tipoUsuario,
        },
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<PaginatedResponse<User>> getUsers({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? tipoUsuario,
    bool? activo,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'page_size': pageSize,
        if (search != null) 'search': search,
        if (tipoUsuario != null) 'tipo_usuario': tipoUsuario,
        if (activo != null) 'activo': activo,
      };

      final response = await _apiClient.client.get(
        '/users',
        queryParameters: queryParams,
      );

      return PaginatedResponse.fromJson(
        response.data,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<User>> getUserById(int id) async {
    try {
      final response = await _apiClient.client.get('/users/$id');

      return ApiResponse.fromJson(
        response.data,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<User>> getCurrentUser() async {
    try {
      final response = await _apiClient.client.get('/auth/me');
      
      return ApiResponse.fromJson(
        response.data,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<User>> updateUser(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.client.put('/users/$id', data: data);

      return ApiResponse.fromJson(
        response.data,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<void>> deleteUser(int id) async {
    try {
      final response = await _apiClient.client.delete('/users/$id');

      return ApiResponse.fromJson(
        response.data,
        (json) => {},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<User>> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.client.put('/users/profile', data: data);

      return ApiResponse.fromJson(
        response.data,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ApiResponse<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.client.put(
        '/users/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
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
}
