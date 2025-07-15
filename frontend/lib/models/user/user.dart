import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String email,
    required String nombre,
    required String apellido,
    @JsonKey(name: 'fecha_nacimiento')
    required DateTime fechaNacimiento,
    required String genero,
    required String telefono,
    @JsonKey(name: 'tipo_usuario')
    required String tipoUsuario,
    @JsonKey(name: 'consentimiento_datos')
    required bool consentimientoDatos,
    required bool activo,
    @JsonKey(name: 'created_at')
    required DateTime createdAt,
    @JsonKey(name: 'institucion_id')
    int? institucionId,
    @JsonKey(name: 'grupo_id')
    int? grupoId,
    @JsonKey(name: 'pulsera_id')
    int? pulseraId,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}