import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_log.freezed.dart';
part 'system_log.g.dart';

@freezed
abstract class SystemLog with _$SystemLog {
  const factory SystemLog({
    required int id,
    @JsonKey(name: 'usuario_id')
    int? usuarioId,
    @JsonKey(name: 'pulsera_id')
    int? pulseraId,
    @JsonKey(name: 'tipo_evento')
    required String tipoEvento,
    required String descripcion,
    @JsonKey(name: 'ip_address')
    required String ipAddress,
    @JsonKey(name: 'user_agent')
    required String userAgent,
    @JsonKey(name: 'datos_adicionales')
    required Map<String, dynamic> datosAdicionales,
    required DateTime timestamp,
  }) = _SystemLog;

  factory SystemLog.fromJson(Map<String, dynamic> json) => _$SystemLogFromJson(json);
}
