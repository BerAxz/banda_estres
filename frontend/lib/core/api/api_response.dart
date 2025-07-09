import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

/// Respuesta genérica de la API
/// Proporciona una estructura consistente para todas las respuestas
@freezed
abstract class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required bool success,
    T? data,
    Map<String, dynamic>? error,
    @JsonKey(name: 'status_code') int? statusCode,
  }) = _ApiResponse<T>;

  /// Factory method personalizado para manejar la deserialización
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) {
    // Determinar si es una respuesta exitosa basándose en la presencia de 'data' vs 'error'
    final bool isSuccess = json.containsKey('data') && !json.containsKey('error');
    
    T? data;
    if (isSuccess && json['data'] != null) {
      try {
        data = fromJsonT(json['data']);
      } catch (e) {
        // Si hay error en la deserialización, tratarlo como error
        return ApiResponse(
          success: false,
          data: null,
          error: {'detail': 'Error deserializando datos: $e'},
          statusCode: json['status_code'] as int?,
        );
      }
    }
    
    return ApiResponse(
      success: isSuccess,
      data: data,
      error: !isSuccess ? json['error'] as Map<String, dynamic>? : null,
      statusCode: json['status_code'] as int?,
    );
  }
}

extension ApiResponseExtensions<T> on ApiResponse<T> {
  /// Indica si la respuesta es exitosa y tiene datos
  bool get isSuccess => success && data != null;
  
  /// Indica si la respuesta es de error
  bool get isError => !success || error != null;
  
  /// Obtiene el mensaje de error si existe
  String? get errorMessage {
    if (error != null) {
      if (error!.containsKey('message')) {
        return error!['message'] as String?;
      }
      if (error!.containsKey('detail')) {
        return error!['detail'] as String?;
      }
      if (error!.containsKey('error')) {
        return error!['error'] as String?;
      }
    }
    return null;
  }
  
  /// Obtiene los datos de forma segura
  T? get safeData => success ? data : null;
}


/// Respuesta paginada de la API
@Freezed(genericArgumentFactories: true)
abstract class PaginatedResponse<T> with _$PaginatedResponse<T> {
  const factory PaginatedResponse({
    required List<T> results,
    required int count,
    @JsonKey(name: 'next') String? nextUrl,
    @JsonKey(name: 'previous') String? previousUrl,
    @JsonKey(name: 'total_pages') int? totalPages,
    @JsonKey(name: 'current_page') int? currentPage,
  }) = _PaginatedResponse<T>;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$PaginatedResponseFromJson(json, fromJsonT);
}
