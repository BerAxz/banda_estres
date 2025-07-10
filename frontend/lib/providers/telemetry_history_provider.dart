import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../api/services/telemetry_service.dart';
import 'telemetry_provider.dart';

/// Modelo para datos históricos de telemetría
class TelemetryHistory {
  final List<TelemetryDataPoint> bpmHistory;
  final List<TelemetryDataPoint> spo2History;
  final List<TelemetryDataPoint> temperatureHistory;

  TelemetryHistory({
    required this.bpmHistory,
    required this.spo2History,
    required this.temperatureHistory,
  });

  TelemetryHistory copyWith({
    List<TelemetryDataPoint>? bpmHistory,
    List<TelemetryDataPoint>? spo2History,
    List<TelemetryDataPoint>? temperatureHistory,
  }) {
    return TelemetryHistory(
      bpmHistory: bpmHistory ?? this.bpmHistory,
      spo2History: spo2History ?? this.spo2History,
      temperatureHistory: temperatureHistory ?? this.temperatureHistory,
    );
  }
}

/// Punto de datos para el gráfico
class TelemetryDataPoint {
  final DateTime timestamp;
  final double value;

  TelemetryDataPoint({
    required this.timestamp,
    required this.value,
  });
}

/// Notifier para manejar el historial de datos
class TelemetryHistoryNotifier extends StateNotifier<TelemetryHistory> {
  static const int maxDataPoints = 20; // Máximo 20 puntos en el gráfico

  TelemetryHistoryNotifier() : super(TelemetryHistory(
    bpmHistory: [],
    spo2History: [],
    temperatureHistory: [],
  ));

  void addTelemetryData(TelemetryData data) {
    final now = DateTime.now();
    
    // Crear nuevos puntos de datos
    final bpmPoint = TelemetryDataPoint(
      timestamp: now,
      value: data.bpm.toDouble(),
    );
    
    final spo2Point = TelemetryDataPoint(
      timestamp: now,
      value: data.spo2.toDouble(),
    );
    
    final temperaturePoint = TelemetryDataPoint(
      timestamp: now,
      value: data.temperature,
    );

    // Actualizar listas manteniendo solo los últimos maxDataPoints
    final newBpmHistory = [...state.bpmHistory, bpmPoint];
    final newSpo2History = [...state.spo2History, spo2Point];
    final newTemperatureHistory = [...state.temperatureHistory, temperaturePoint];

    // Mantener solo los últimos puntos
    if (newBpmHistory.length > maxDataPoints) {
      newBpmHistory.removeAt(0);
    }
    if (newSpo2History.length > maxDataPoints) {
      newSpo2History.removeAt(0);
    }
    if (newTemperatureHistory.length > maxDataPoints) {
      newTemperatureHistory.removeAt(0);
    }

    state = state.copyWith(
      bpmHistory: newBpmHistory,
      spo2History: newSpo2History,
      temperatureHistory: newTemperatureHistory,
    );
  }

  void clearHistory() {
    state = TelemetryHistory(
      bpmHistory: [],
      spo2History: [],
      temperatureHistory: [],
    );
  }
}

/// Provider para el historial de datos de telemetría
final telemetryHistoryProvider = StateNotifierProvider<TelemetryHistoryNotifier, TelemetryHistory>((ref) {
  final notifier = TelemetryHistoryNotifier();
  
  // Escuchar cambios en los datos de telemetría y agregarlos al historial
  ref.listen(telemetryDataProvider, (previous, next) {
    next.whenData((data) {
      notifier.addTelemetryData(data);
    });
  });
  
  return notifier;
});
