import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_export.freezed.dart';
part 'data_export.g.dart';

enum TipoDatos { full, summary }
enum FormatoExport { csv, json, xlsx }
enum EstadoExport { pending, ready, failed }

@freezed
abstract class DataExport with _$DataExport {
  const factory DataExport({
    required int id,
    @JsonKey(name: 'usuario_id')
    required int usuarioId,
    @JsonKey(name: 'fecha_solicitud')
    required DateTime fechaSolicitud,
    @JsonKey(name: 'fecha_desde')
    required DateTime fechaDesde,
    @JsonKey(name: 'fecha_hasta')
    required DateTime fechaHasta,
    @JsonKey(name: 'tipo_datos')
    required TipoDatos tipoDatos,
    required FormatoExport formato,
    required EstadoExport estado,
    @JsonKey(name: 'url_descarga')
    String? urlDescarga,
    @JsonKey(name: 'fecha_expiracion')
    DateTime? fechaExpiracion,
  }) = _DataExport;

  factory DataExport.fromJson(Map<String, dynamic> json) => _$DataExportFromJson(json);
}
