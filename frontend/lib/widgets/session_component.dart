import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class SessionComponent extends StatelessWidget {
  final DateTime startDate;
  final Duration duration;
  final int bpmAvg;
  final double tempAvg;

  final double width;

  const SessionComponent({
    super.key,
    required this.startDate,
    required this.duration,
    required this.bpmAvg,
    required this.tempAvg,
    this.width = 300.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16.r),
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
          _buildSessionHeader(),
          _buildStats(),
        ],
      ),
    );
  }

  Widget _buildSessionHeader() {
    return Row(
      spacing: 12.w,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(37, 10, 93, 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.favorite, size: 24.sp, color: Colors.red),
        ),
        _buildDateAndDuration(),
      ],
    );
  }


  Widget _buildDateAndDuration() {
    return Column(
      spacing: 2.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('dd MMM yyyy').format(startDate),
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          spacing: 4.w,
          children: [
            Icon(Icons.access_time, size: 16.sp, color: Colors.black54),
            Text(
              '${duration.inHours}h ${duration.inMinutes.remainder(60)}m',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        )
      ],
    );
  }


  Widget _buildStats() {
    return Column(
      spacing: 8.h,
      children: [
        _buildStat(Icons.monitor_heart, 'BPM Prom', bpmAvg.toString()),
        _buildStat(Icons.thermostat, 'Temperatura Prom', '${tempAvg.toStringAsFixed(1)} °C'),
      ],
    );
  }

  Widget _buildStat(IconData icon, String label, String value) {
    return Row(
      spacing: 8.w,
      children: [
        Icon(icon, size: 20.sp, color: const Color.fromRGBO(228, 46, 172, 1)),
        Text(
          '$label: $value',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}