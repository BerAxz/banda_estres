import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_user.freezed.dart';
part 'config_user.g.dart';

@freezed
abstract class ConfigUser with _$ConfigUser {
  const factory ConfigUser({
    required int id,
    @JsonKey(name: 'usuario_id')
    required int userId,
    @JsonKey(name: 'notificaciones_push')
    required bool notificacionesPush,
    @JsonKey(name: 'notificaciones_email')
    required bool notificacionesEmail,
    @JsonKey(name: 'umbral_personalizado_bpm')
    required int umbralPersonalizadoBpm,
    @JsonKey(name: 'umbral_personalizado_spo2')
    required int umbralPersonalizadoSpo2,
    @JsonKey(name: 'umbral_personalizado_temp')
    required double umbralPersonalizadoTemp,
    @JsonKey(name: 'modo_privado')
    required bool modoPrivado,
    @JsonKey(name: 'compartir_datos_investigacion')
    required bool compartirDatosInvestigacion,
    @JsonKey(name: 'configuracion_avanzada')
    required Object configuracionAvanzada,
  }) = _ConfigUser;

  factory ConfigUser.fromJson(Map<String, dynamic> json) => _$ConfigUserFromJson(json);
}