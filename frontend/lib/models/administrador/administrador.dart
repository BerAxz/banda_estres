import 'package:freezed_annotation/freezed_annotation.dart';

part 'administrador.freezed.dart';
part 'administrador.g.dart';

@freezed
abstract class Administrador with _$Administrador {
  const factory Administrador({
    required int id,
    @JsonKey(name: 'institucion_id')
    required int institucionId,
    required String nombre,
    required String apellido,
    required String email,
    required String rol,
    required bool activo,
    @JsonKey(name: 'ultimo_acceso')
    required DateTime ultimoAcceso,
  }) = _Administrador;

  factory Administrador.fromJson(Map<String, dynamic> json) => _$AdministradorFromJson(json);
}