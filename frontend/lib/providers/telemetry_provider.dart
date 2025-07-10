import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../api/services/telemetry_service.dart';

/// Provider del servicio de telemetría
final telemetryServiceProvider = Provider<TelemetryService>((ref) {
  final service = TelemetryService();
  
  // Limpia el servicio cuando el provider se elimina
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

/// Provider para los datos de telemetría en tiempo real
final telemetryDataProvider = StreamProvider<TelemetryData>((ref) {
  final service = ref.watch(telemetryServiceProvider);
  
  // Conecta automáticamente cuando se accede al provider
  service.connect().catchError((error) {
    debugPrint('Failed to connect to telemetry: $error');
  });
  
  return service.dataStream;
});

/// Provider para el estado de conexión
final telemetryConnectionProvider = StateProvider<bool>((ref) {
  final service = ref.watch(telemetryServiceProvider);
  return service.isConnected;
});
