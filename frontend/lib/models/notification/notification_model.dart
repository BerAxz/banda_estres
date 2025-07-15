import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

enum NotificationType { 
  anxietyAlert, 
  recommendationBreathing, 
  recommendationBreak, 
  systemMessage 
}

enum MetodoEnvio { push, email }

@freezed
abstract class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required int id,
    @JsonKey(name: 'usuario_id')
    required int usuarioId,
    @JsonKey(name: 'evento_ansiedad_id')
    int? eventoAnsiedadId,
    required NotificationType tipo,
    required String titulo,
    required String mensaje,
    required DateTime timestamp,
    required bool leida,
    required bool enviada,
    @JsonKey(name: 'metodo_envio')
    required MetodoEnvio metodoEnvio,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
}
