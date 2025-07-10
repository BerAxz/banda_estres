import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../api/api.dart';
import '../models/anxiety_event/anxiety_event.dart';

// Provider para el servicio de eventos de ansiedad
final anxietyEventServiceProvider = Provider<IAnxietyEventService>((ref) {
  final serviceLocator = ServiceLocator();
  serviceLocator.initialize();
  return serviceLocator.anxietyEventService;
});

// Provider para obtener eventos de ansiedad por usuario
final anxietyEventsProvider = FutureProvider.autoDispose<List<AnxietyEvent>>((ref) async {
  final anxietyEventService = ref.watch(anxietyEventServiceProvider);
  // TODO: Reemplazar con el ID del usuario actual cuando esté disponible
  final userId = 1; // Temporalmente hardcoded
  
  try {
    final response = await anxietyEventService.getAnxietyEventsByUserId(
      usuarioId: userId,
      page: 1,
      pageSize: 20,
    );
    return response.results;
  } catch (e) {
    debugPrint('Error obteniendo eventos de ansiedad: $e');
    return [];
  }
});

// Provider para obtener un evento de ansiedad por ID
final anxietyEventByIdProvider = FutureProvider.autoDispose.family<AnxietyEvent?, int>((ref, eventId) async {
  final anxietyEventService = ref.watch(anxietyEventServiceProvider);
  
  try {
    final response = await anxietyEventService.getAnxietyEventById(eventId);
    return response.data;
  } catch (e) {
    debugPrint('Error obteniendo evento de ansiedad: $e');
    return null;
  }
});

// Provider para marcar un evento como resuelto
final resolveEventProvider = FutureProvider.autoDispose.family<AnxietyEvent?, ResolveEventParams>((ref, params) async {
  final anxietyEventService = ref.watch(anxietyEventServiceProvider);
  
  try {
    final response = await anxietyEventService.markAsResolved(
      params.eventId,
      notasUsuario: params.notes,
    );
    
    // Invalidar providers para refrescar los datos
    ref.invalidate(anxietyEventsProvider);
    ref.invalidate(anxietyEventByIdProvider(params.eventId));
    
    return response.data;
  } catch (e) {
    debugPrint('Error marcando evento como resuelto: $e');
    return null;
  }
});

// Clase auxiliar para pasar parámetros al provider de resolución de eventos
class ResolveEventParams {
  final int eventId;
  final String? notes;
  
  ResolveEventParams({
    required this.eventId,
    this.notes,
  });
}
