import 'package:freezed_annotation/freezed_annotation.dart';

part 'dispositivo.freezed.dart';
part 'dispositivo.g.dart';

@freezed
abstract class Dispositivo with _$Dispositivo {
  const factory Dispositivo({
    required int id,
    @JsonKey(name: 'device_id')
    required String deviceId,
    @JsonKey(name: 'numero_serie')
    required String numeroSerie,
    required String modelo,
    @JsonKey(name: 'api_key_iot')
    required String apiKeyIot,
    @JsonKey(name: 'fecha_fabricacion')
    required DateTime fechaFabricacion,
    @JsonKey(name: 'fecha_activacion')
    required DateTime fechaActivacion,
    required String estado,
    @JsonKey(name: 'version_firmware')
    required String versionFirmware,
    @JsonKey(name: 'configuracion_hardware')
    required Object configuracionHardware,
    @JsonKey(name: 'created_at')
    required DateTime createdAt,
    @JsonKey(name: 'institucion_id')
    int? institucionId
  }) = _Dispositivo;

  factory Dispositivo.fromJson(Map<String, dynamic> json) => _$DispositivoFromJson(json);
}