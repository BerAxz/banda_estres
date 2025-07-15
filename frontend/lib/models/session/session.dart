import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
abstract class Session with _$Session {
  const factory Session({
    required int id,
    @JsonKey(name: 'usuario_id')
    required int usuarioId,
    @JsonKey(name: 'pulsera_id')
    required int pulseraId,
    @JsonKey(name: 'fecha_inicio')
    required DateTime fechaInicio,
    @JsonKey(name: 'fecha_fin')
    DateTime? fechaFin,
    @JsonKey(name: 'duracion_minutos')
    required int duracionMinutos,
    required String estado,
    @JsonKey(name: 'ubicacion_lat')
    required double ubicacionLat,
    @JsonKey(name: 'ubicacion_lng')
    required double ubicacionLng,
    required String notas,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
}
