import 'package:freezed_annotation/freezed_annotation.dart';

part 'physiological_data.freezed.dart';
part 'physiological_data.g.dart';

@freezed
abstract class PhysiologicalData with _$PhysiologicalData {
  const factory PhysiologicalData({
    required int id,
    @JsonKey(name: 'sesion_id')
    required int sesionId,
    @JsonKey(name: 'usuario_id')
    required int usuarioId,
    @JsonKey(name: 'pulsera_id')
    required int pulseraId,
    required DateTime timestamp,
    required int bpm,
    required int spo2,
    required double temperatura,
    @JsonKey(name: 'calidad_senal')
    required int calidadSenal,
  }) = _PhysiologicalData;

  factory PhysiologicalData.fromJson(Map<String, dynamic> json) => _$PhysiologicalDataFromJson(json);
}
