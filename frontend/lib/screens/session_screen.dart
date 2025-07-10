import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/providers/session_provider.dart';
import 'package:frontend/widgets/active_session.dart';
import 'package:frontend/widgets/common_widgets.dart';
import 'package:frontend/widgets/session_component.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  @override
  Widget build(BuildContext context) {
    final activeSessionAsync = ref.watch(activeSessionProvider);
    final sessionsHistoryAsync = ref.watch(sessionsHistoryProvider);
    
    return CommonScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          const ScreenHeader(title: 'Sesiones'),
          
          // Sesión activa
          activeSessionAsync.when(
            data: (activeSession) {
              print('Active session: $activeSession');
              if (activeSession != null) {
                // Calcular duración basada en la fecha de inicio hasta ahora
                final duration = DateTime.now().difference(activeSession.fechaInicio);
                return ActiveSession(
                  isActive: true,
                  bpm: 0, // Estos valores vendrían de otro provider
                  temp: 0,
                  spo: 0,
                  deviceConnected: true,
                  batteryLevel: 100,
                  startDate: activeSession.fechaInicio,
                  duration: duration,
                  width: double.infinity,
                );
              } else {
                return _buildNoActiveSession();
              }
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Error: ${error.toString()}', style: TextStyle(color: Colors.red)),
            ),
          ),
          
          SizedBox(height: 16.h),
          
          Text(
            'Historial de sesiones',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          // Historial de sesiones
          sessionsHistoryAsync.when(
            data: (sessions) {
              print('Sessions history: $sessions');
              if (sessions.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Text(
                      'No hay sesiones en el historial',
                      style: TextStyle(color: Colors.white70, fontSize: 16.sp),
                    ),
                  ),
                );
              }
              
              return ListView.builder(
                shrinkWrap: true,
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    print('Sessions at index $index: ${sessions[index]}');
                    final session = sessions[index];
                    // Calcular la duración en base a fechaInicio y fechaFin
                    final Duration duration;
                    if (session.fechaFin != null) {
                      duration = session.fechaFin!.difference(session.fechaInicio);
                    } else {
                      duration = Duration(minutes: session.duracionMinutos);
                    }
                    
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: SessionComponent(
                        startDate: session.fechaInicio,
                        duration: duration,
                        bpmAvg: 75, // Estos valores deberían venir de la sesión
                        tempAvg: 36.5,
                        width: double.infinity,
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
  
  Widget _buildNoActiveSession() {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Text(
              'No hay sesión activa',
              style: TextStyle(fontSize: 18.sp, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
  

}
