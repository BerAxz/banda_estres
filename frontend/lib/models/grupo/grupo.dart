import 'package:freezed_annotation/freezed_annotation.dart';

part 'grupo.freezed.dart';
part 'grupo.g.dart';

@freezed
abstract class Grupo with _$Grupo{
  const factory Grupo({
    required int id,
    @JsonKey(name: 'institucion_id')
    required int institucionId,
    required String nombre,
    required String descripcion,
    @JsonKey(name: 'codigo_activacion')
    required String codigoActivacion,
    required bool activo,
    @JsonKey(name: 'created_at')
    required DateTime createdAt,
  }) = _Grupo;

  factory Grupo.fromJson(Map<String, dynamic> json) => _$GrupoFromJson(json);
}