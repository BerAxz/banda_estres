import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/models/anxiety_event/anxiety_event.dart';
import 'package:frontend/providers/anxiety_event_provider.dart';
import 'package:frontend/widgets/common_widgets.dart';
import 'package:frontend/widgets/event.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
} 

class _EventsScreenState extends ConsumerState<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    final anxietyEventsAsync = ref.watch(anxietyEventsProvider);
    
    return CommonScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenHeader(title: 'Eventos'),
          SizedBox(height: 16.h),
          
          // Filtros de eventos (podrían implementarse más adelante)
          
          SizedBox(height: 16.h),
          
          // Lista de eventos
          anxietyEventsAsync.when(
            data: (events) {
              if (events.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Text(
                      'No hay eventos de ansiedad registrados',
                      style: TextStyle(color: Colors.white70, fontSize: 16.sp),
                    ),
                  ),
                );
              }
              
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                  final event = events[index];
                  
                  // Convertir los datos del modelo de backend al widget de UI
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Event(
                      date: event.timestamp,
                      duration: Duration(minutes: event.duracionMinutos),
                      maxBPM: event.bpmMomento,
                      maxTemp: event.temperaturaMomento,
                      maxSpO2: event.spo2Momento,
                      level: _mapAnxietyLevel(event.nivelAnsiedad),
                      width: double.infinity,
                      eventId: event.id,
                      resolved: event.resuelto,
                      onTap: () => _showEventDetails(event.id),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Error: ${error.toString()}', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
  
  // Mapea el nivel de ansiedad del backend al enum de UI
  EventLevel _mapAnxietyLevel(AnxietyLevel backendLevel) {
    switch (backendLevel) {
      case AnxietyLevel.low:
        return EventLevel.low;
      case AnxietyLevel.medium:
        return EventLevel.medium;
      case AnxietyLevel.high:
        return EventLevel.high;
    }
  }
  
  void _showEventDetails(int eventId) {
    // Usar el provider para obtener los detalles del evento
    ref.read(anxietyEventByIdProvider(eventId)).whenData((event) {
      if (event != null) {
        showDialog(
          context: context,
          builder: (context) => _buildEventDetailsDialog(event),
        );
      } else {
        _showErrorSnackbar('No se pudieron cargar los detalles del evento');
      }
    });
  }
  
  Widget _buildEventDetailsDialog(AnxietyEvent event) {
    return AlertDialog(
      title: Text('Detalles del evento'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('ID', event.id.toString()),
            _buildDetailItem('Fecha', DateFormat('dd/MM/yyyy HH:mm').format(event.timestamp)),
            _buildDetailItem('Duración', '${event.duracionMinutos} minutos'),
            _buildDetailItem('Nivel', event.nivelAnsiedad.name.toUpperCase()),
            _buildDetailItem('BPM', event.bpmMomento.toString()),
            _buildDetailItem('SpO2', '${event.spo2Momento}%'),
            _buildDetailItem('Temperatura', '${event.temperaturaMomento}°C'),
            _buildDetailItem('Estado', event.resuelto ? 'Resuelto' : 'Pendiente'),
            if (event.notasUsuario.isNotEmpty)
              _buildDetailItem('Notas', event.notasUsuario),
            
            SizedBox(height: 16),
            if (!event.resuelto)
              ElevatedButton(
                onPressed: () => _markAsResolved(event),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text('Marcar como resuelto'),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cerrar'),
        ),
      ],
    );
  }
  
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
  
  void _markAsResolved(AnxietyEvent event) async {
    // Solicitar notas adicionales al usuario
    final notesController = TextEditingController();
    
    final notes = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Añadir notas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Puedes agregar notas adicionales (opcional):'),
            SizedBox(height: 8),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Notas...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, notesController.text),
            child: Text('Guardar'),
          ),
        ],
      ),
    );
    
    // Si el usuario cancela, no hacemos nada
    if (notes == null) return;
    
    // Mostrar un diálogo de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    
    try {
      final params = ResolveEventParams(
        eventId: event.id,
        notes: notes.isNotEmpty ? notes : null,
      );
      
      final result = await ref.read(resolveEventProvider(params).future);
      Navigator.of(context).pop(); // Cerrar diálogo de carga
      Navigator.of(context).pop(); // Cerrar diálogo de detalles
      
      if (result == null) {
        _showErrorSnackbar('No se pudo marcar como resuelto');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Evento marcado como resuelto'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Cerrar diálogo de carga
      _showErrorSnackbar('Error: ${e.toString()}');
    }
  }
  
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}