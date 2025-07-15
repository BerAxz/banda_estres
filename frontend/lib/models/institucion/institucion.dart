import 'package:freezed_annotation/freezed_annotation.dart';

part 'institucion.freezed.dart';
part 'institucion.g.dart';

@freezed
abstract class Institucion with _$Institucion{
  const factory Institucion({
    required int id,
    required String nombre,
    required String direccion,
    required String telefono,
    required String email,
    @JsonKey(name: 'fecha_registro')
    required DateTime fechaRegistro,
    required bool activo,
  }) = _Institucion;

  factory Institucion.fromJson(Map<String, dynamic> json) => _$InstitucionFromJson(json);
}