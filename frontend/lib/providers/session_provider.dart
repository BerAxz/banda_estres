import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../api/api.dart';
import '../models/session/session.dart';

// Provider para el servicio de sesiones
final sessionServiceProvider = Provider<ISessionService>((ref) {
  final serviceLocator = ServiceLocator();
  serviceLocator.initialize();
  return serviceLocator.sessionService;
});

// Provider para la sesión activa del usuario
final activeSessionProvider = FutureProvider.autoDispose<Session?>((ref) async {
  final sessionService = ref.watch(sessionServiceProvider);
  // TODO: Reemplazar con el ID del usuario actual cuando esté disponible
  final userId = 1; // Temporalmente hardcoded
  
  try {
    final response = await sessionService.getActiveSession(userId);
    return response.data;
  } catch (e) {
    debugPrint('Error obteniendo la sesión activa: $e');
    return null;
  }
});

// Provider para historial de sesiones
final sessionsHistoryProvider = FutureProvider.autoDispose<List<Session>>((ref) async {
  final sessionService = ref.watch(sessionServiceProvider);
  // TODO: Reemplazar con el ID del usuario actual cuando esté disponible
  final userId = 1; // Temporalmente hardcoded
  
  try {
    final response = await sessionService.getSessionsByUserId(
      usuarioId: userId,
      page: 1,
      pageSize: 10, // Limitar a 10 sesiones inicialmente
    );
    return response.results;
  } catch (e) {
    debugPrint('Error obteniendo el historial de sesiones: $e');
    return [];
  }
});

// Provider para crear una nueva sesión
final createSessionProvider = FutureProvider.autoDispose.family<Session?, Map<String, dynamic>>((ref, sessionData) async {
  final sessionService = ref.watch(sessionServiceProvider);
  
  try {
    final response = await sessionService.createSession(
      usuarioId: sessionData['usuarioId'] as int,
      pulseraId: sessionData['pulseraId'] as int,
      notas: sessionData['notas'] as String?,
    );
    
    // Invalidar providers para refrescar los datos
    ref.invalidate(activeSessionProvider);
    ref.invalidate(sessionsHistoryProvider);
    
    return response.data;
  } catch (e) {
    debugPrint('Error creando nueva sesión: $e');
    return null;
  }
});

// La funcionalidad de finalizar una sesión es manejada por el backend
