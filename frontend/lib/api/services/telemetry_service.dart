import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Modelo para los datos de telemetría
class TelemetryData {
  final int bpm;
  final int spo2;
  final double temperature;
  final int signalQuality;

  TelemetryData({
    required this.bpm,
    required this.spo2,
    required this.temperature,
    required this.signalQuality,
  });

  factory TelemetryData.fromJson(Map<String, dynamic> json) {
    return TelemetryData(
      bpm: json['bpm'] ?? 0,
      spo2: json['spo2'] ?? 0,
      temperature: (json['temperatura'] ?? 0.0).toDouble(),
      signalQuality: json['calidad_senal'] ?? 0,
    );
  }
}

/// Servicio para manejar la conexión WebSocket de telemetría
class TelemetryService {
  static const String _wsUrl = 'ws://192.168.1.89:8000/ws/datos-tiempo-real/2/';
  
  WebSocketChannel? _channel;
  StreamController<TelemetryData>? _dataController;
  
  /// Stream de datos de telemetría
  Stream<TelemetryData> get dataStream => _dataController!.stream;
  
  /// Estado de conexión
  bool get isConnected => _channel != null;

  /// Conecta al WebSocket
  Future<void> connect() async {
    if (_channel != null) {
      await disconnect();
    }

    try {
      _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));
      _dataController = StreamController<TelemetryData>.broadcast();
      
      _channel!.stream.listen(
        (data) {
          try {
            final jsonData = json.decode(data);
            if (jsonData['type'] == 'nuevos_datos' && jsonData['data'] != null) {
              final telemetryData = TelemetryData.fromJson(jsonData['data']);
              _dataController!.add(telemetryData);
            }
          } catch (e) {
            debugPrint('Error parsing telemetry data: $e');
          }
        },
        onError: (error) {
          debugPrint('WebSocket error: $error');
          _dataController!.addError(error);
        },
        onDone: () {
          debugPrint('WebSocket connection closed');
          _dataController!.close();
        },
      );
      
      debugPrint('Connected to telemetry WebSocket');
    } catch (e) {
      debugPrint('Failed to connect to WebSocket: $e');
      rethrow;
    }
  }

  /// Desconecta del WebSocket
  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
    await _dataController?.close();
    _dataController = null;
    debugPrint('Disconnected from telemetry WebSocket');
  }

  /// Limpia recursos
  void dispose() {
    disconnect();
  }
}
