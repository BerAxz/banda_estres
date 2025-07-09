import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_grupo.freezed.dart';
part 'config_grupo.g.dart';

@freezed
abstract class ConfigGrupo with _$ConfigGrupo {
  const factory ConfigGrupo({
    required int id,
    @JsonKey(name: 'grupo_id')
    required int grupoId,
    @JsonKey(name: 'umbral_bpm_min')
    required int umbralBpmMin,
    @JsonKey(name: 'umbral_bpm_max')
    required int umbralBpmMax,
    @JsonKey(name: 'umbral_spo2_min')
    required int umbralSpo2Min,
    @JsonKey(name: 'umbral_spo2_max')
    required int umbralSpo2Max,
    @JsonKey(name: 'umbral_temp_min')
    required double umbralTempMin,
    @JsonKey(name: 'umbral_temp_max')
    required double umbralTempMax,
    @JsonKey(name: 'intervalo_medicion')
    required int intervaloMedicion,
    @JsonKey(name: 'notificaciones_activas')
    required bool notificacionesActivas,
    @JsonKey(name: 'configuracion_avanzada')
    required bool configuracionAvanzada,
  }) = _ConfigGrupo;

  factory ConfigGrupo.fromJson(Map<String, dynamic> json) => _$ConfigGrupoFromJson(json);
}