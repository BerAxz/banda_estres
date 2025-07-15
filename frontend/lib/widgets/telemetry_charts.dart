import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/telemetry_history_provider.dart';

class TelemetryChartsWidget extends ConsumerWidget {
  const TelemetryChartsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(telemetryHistoryProvider);

    return Column(
      spacing: 24.h,
      children: [
        _buildChart(
          title: '💖 Ritmo cardíaco',
          data: history.bpmHistory,
          color: const Color.fromRGBO(245, 129, 163, 1),
          unit: 'BPM',
          minY: 60,
          maxY: 180,
        ),
        _buildChart(
          title: '🫁 Temperatura',
          data: history.temperatureHistory,
          color: const Color.fromRGBO(255, 117, 95, 1),
          unit: '°C',
          minY: 35,
          maxY: 39,
        ),
        _buildChart(
          title: '💧 Oxigenación',
          data: history.spo2History,
          color: const Color.fromRGBO(0, 191, 189, 1),
          unit: '%',
          minY: 90,
          maxY: 100,
        ),
      ],
    );
  }

  Widget _buildChart({
    required String title,
    required List<TelemetryDataPoint> data,
    required Color color,
    required String unit,
    required double minY,
    required double maxY,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título del gráfico
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16.h),
          
          // Gráfico
          SizedBox(
            height: 140.h,
            child: data.isEmpty
                ? _buildEmptyChart()
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        drawHorizontalLine: true,
                        horizontalInterval: (maxY - minY) / 4,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey.withValues(alpha: 0.3),
                          strokeWidth: 1,
                        ),
                        getDrawingVerticalLine: (value) => FlLine(
                          color: Colors.grey.withValues(alpha: 0.3),
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40.w,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      minX: 0,
                      maxX: (data.length - 1).toDouble(),
                      minY: minY,
                      maxY: maxY,
                      lineBarsData: [
                        LineChartBarData(
                          spots: data.asMap().entries.map((entry) {
                            return FlSpot(
                              entry.key.toDouble(),
                              entry.value.value,
                            );
                          }).toList(),
                          isCurved: true,
                          color: color,
                          barWidth: 3.w,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4.r,
                                color: color,
                                strokeWidth: 2.w,
                                strokeColor: Colors.white,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: color.withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          
          // Valor actual
          if (data.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Actual: ${data.last.value.toStringAsFixed(1)} $unit',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
                Text(
                  '${data.length} puntos',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyChart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart,
            size: 32.w,
            color: Colors.grey[400],
          ),
          SizedBox(height: 8.h),
          Text(
            'Esperando datos...',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
