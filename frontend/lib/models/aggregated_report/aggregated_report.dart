import 'package:freezed_annotation/freezed_annotation.dart';

part 'aggregated_report.freezed.dart';
part 'aggregated_report.g.dart';

@freezed
abstract class AggregatedReport with _$AggregatedReport {
  const factory AggregatedReport({
    required int id,
    @JsonKey(name: 'institucion_id')
    required int institucionId,
    @JsonKey(name: 'grupo_id')
    int? grupoId,
    @JsonKey(name: 'fecha_reporte')
    required DateTime fechaReporte,
    required String periodo,
    @JsonKey(name: 'total_usuarios')
    required int totalUsuarios,
    @JsonKey(name: 'total_eventos')
    required int totalEventos,
    @JsonKey(name: 'promedio_bpm')
    required double promedioBpm,
    @JsonKey(name: 'promedio_spo2')
    required double promedioSpo2,
    @JsonKey(name: 'promedio_temperatura')
    required double promedioTemperatura,
    @JsonKey(name: 'eventos_por_nivel')
    required Map<String, dynamic> eventosPorNivel,
    @JsonKey(name: 'horas_pico')
    required Map<String, dynamic> horasPico,
    @JsonKey(name: 'datos_agregados')
    required Map<String, dynamic> datosAgregados,
  }) = _AggregatedReport;

  factory AggregatedReport.fromJson(Map<String, dynamic> json) => _$AggregatedReportFromJson(json);
}
