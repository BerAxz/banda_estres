import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

enum EventLevel {
  low,
  medium,
  high,
}

class Event extends StatelessWidget{
  final DateTime date;
  final Duration duration;
  final int maxBPM;
  final double maxTemp;
  final int maxSpO2;
  final EventLevel level;
  final int eventId;
  final bool resolved;
  final VoidCallback? onTap;

  final double width;

  const Event({
    super.key,
    required this.date,
    required this.duration,
    required this.maxBPM,
    required this.maxTemp,
    required this.maxSpO2,
    this.width = 300.0,
    this.level = EventLevel.low,
    this.eventId = 0,
    this.resolved = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Icon(
                  Icons.warning_rounded,
                  size: 40.sp,
                  color: level == EventLevel.high ? Colors.red : 
                        level == EventLevel.medium ? Colors.orange : Colors.green,
                ),
                if (resolved)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.all(2.r),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                children: [
                  _buildDetails()
                ],
              ),
            ),
            
          ],
        )
      ),
    );
  }

  Widget _buildDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLeftDetails(),
        _buildRightDetails(),
      ],
    );
  }
  Widget _buildLeftDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4.h,
      children: [
        Text(
          level.name.toUpperCase(),
          style: TextStyle(
            fontSize: 20.sp,
            color: level == EventLevel.high ? Colors.red : 
                   level == EventLevel.medium ? Colors.orange : Colors.green,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          DateFormat('dd MMM yyyy').format(date),
          style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.w300),
        ),
        Row(
          spacing: 6.w,
          children: [
            Text(
              DateFormat('HH:mm').format(date),
              style: TextStyle(fontSize: 16.sp, color: Colors.white),
            ),
            Icon(Icons.access_time, size: 16.sp, color: Colors.white),
            Text(
              duration.inHours > 0
                  ? '${duration.inHours}h ${duration.inMinutes.remainder(60)}m'
                  : '${duration.inMinutes}m',
              style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        
      ],
    );
  }

  Widget _buildRightDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.h,
      children: [
        _buildStat(Icons.favorite, '${maxBPM.toString()} bpm', ),
        _buildStat(Icons.thermostat, '${maxTemp.toStringAsFixed(1)} °C'),
        _buildStat(Icons.battery_charging_full, '$maxSpO2%'),
      ],
    );
  }

  Widget _buildStat(IconData icon, String value) {
    return Row(
      spacing: 8.w,
      children: [
        Icon(icon, size: 20.sp, color: Colors.white.withValues(alpha: 0.7)),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}