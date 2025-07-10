import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ActiveSession extends StatelessWidget {
  final bool isActive;
  final int bpm;
  final double temp;
  final int spo;
  final bool deviceConnected;
  final int batteryLevel;
  final DateTime startDate;
  final Duration duration;

  final double width;

  const ActiveSession({
    super.key,
    required this.isActive,
    required this.bpm,
    required this.temp,
    required this.spo,
    required this.deviceConnected,
    required this.batteryLevel,
    required this.startDate,
    required this.duration,
    this.width = 300.0,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.h,
          children: [
            _buildTitle(),
            _buildSessionStats(),
          ],
        ),
    );
  }

  Widget _buildTitle() {
    return Row(
      spacing: 16.w,
      children: [
        Icon(
          isActive ? Icons.check_circle : Icons.pause_circle,
          color: isActive ? const Color.fromRGBO(134, 255, 174, 1) : Colors.red,
          size: 32.0,
        ),
        Text(
          isActive ? 'Sesión Activa' : 'Sesión Pausada',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSessionStats() {
    return Column(
      spacing: 12.h,
      children: [
        _buildStat(Icons.favorite, 'BPM', bpm.toString()),
        _buildStat(Icons.thermostat, 'Temperatura', '$temp °C'),
        _buildStat(Icons.water_drop_rounded, 'SpO₂', '$spo %'),
        _buildStat(
          Icons.bluetooth_connected,
          'Pulsera',
          deviceConnected ? 'Conectada' : 'Desconectada',
        ),
        _buildStat(Icons.battery_full, 'Batería', '$batteryLevel%'),
        _buildStat(
              Icons.calendar_today,
              'Fecha de Inicio',
              // Solo muestra la fecha en formato dd/MM/yyyy
            DateFormat('d/M HH:mm').format(startDate)
        ),
        _buildStat(Icons.watch_later, 'Duración', '${duration.inMinutes} min'),
      ],
    );
  }

  Widget _buildStat(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Color.fromRGBO(250, 250, 250, 1), size: 20.w),
        SizedBox(width: 8.w),
        Text(
          '$label: $value',
          style: TextStyle(
            color: Color.fromRGBO(250, 250, 250, 1),
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
    
  }
}