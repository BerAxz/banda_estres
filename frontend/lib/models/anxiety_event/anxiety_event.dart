import 'package:freezed_annotation/freezed_annotation.dart';

part 'anxiety_event.freezed.dart';
part 'anxiety_event.g.dart';

enum AnxietyLevel { low, medium, high }

@freezed
abstract class AnxietyEvent with _$AnxietyEvent {
  const factory AnxietyEvent({
    required int id,
    @JsonKey(name: 'usuario_id')
    required int usuarioId,
    @JsonKey(name: 'sesion_id')
    required int sesionId,
    required DateTime timestamp,
    @JsonKey(name: 'nivel_ansiedad')
    required AnxietyLevel nivelAnsiedad,
    @JsonKey(name: 'bpm_momento')
    required int bpmMomento,
    @JsonKey(name: 'spo2_momento')
    required int spo2Momento,
    @JsonKey(name: 'temperatura_momento')
    required double temperaturaMomento,
    @JsonKey(name: 'duracion_minutos')
    required int duracionMinutos,
    @JsonKey(name: 'factores_detectados')
    required Map<String, dynamic> factoresDetectados,
    @JsonKey(name: 'accion_tomada')
    required String accionTomada,
    required bool resuelto,
    @JsonKey(name: 'notas_usuario')
    required String notasUsuario,
  }) = _AnxietyEvent;

  factory AnxietyEvent.fromJson(Map<String, dynamic> json) => _$AnxietyEventFromJson(json);
}
