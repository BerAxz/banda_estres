import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/widgets/metric_card.dart';
import 'package:frontend/widgets/telemetry_charts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/providers/telemetry_provider.dart';
import 'package:frontend/api/services/telemetry_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha los datos de telemetría
    final telemetryAsync = ref.watch(telemetryDataProvider);
    
    return Scaffold(
      body: SafeArea(
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: const [
                Colors.transparent, // Borde superior transparente
                Colors.black,      // Centro opaco
                Colors.black,      // Centro opaco
                Colors.transparent, // Borde inferior transparente
              ],
              stops: const [0.0, 0.05, 0.95, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: const [
                  Colors.transparent, // Borde izquierdo transparente
                  Colors.black,      // Centro opaco
                  Colors.black,      // Centro opaco
                  Colors.transparent, // Borde derecho transparente
                ],
                stops: const [0.0, 0.02, 0.98, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24.w, 48.h, 24.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 24.h,
              children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'Stress Band',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/menu'),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: SvgPicture.asset(
                        'assets/svg/menu.svg',
                        width: 32.w,
                      ),
                    ),
                  ),
                ],
              ),
              telemetryAsync.when(
                data: (telemetryData) => _statsSection(telemetryData),
                loading: () => _statsSection(null),
                error: (error, stack) => _statsSection(null),
              ),
            ],
          ),
        ),
        ),
        )
      ) 
    );
  }



  Widget _statsSection(TelemetryData? telemetryData) {
    return Column(
      spacing: 24.h,
      children: [
        _firstTwo(telemetryData),
        _temperatureCard(telemetryData),
        const TelemetryChartsWidget(),
      ],
    );
  }

  Widget _temperatureCard(TelemetryData? telemetryData) {
    final temperature = telemetryData?.temperature ?? 0.0;
    return SizedBox(
      width: double.infinity,
      child: MetricCard(
        value: "${temperature.toStringAsFixed(1)}°C",
        label: "Temperatura corporal",
        iconUrl: "assets/svg/temp.svg",
        iconSize: 36.w,
        spacing: 4.h,
        backgroundColor: const Color.fromRGBO(255, 117, 95, 0.8),
        size: Size(double.infinity, 140.h),
        sideIcon: true,
      ),
    );
  }

  Widget _firstTwo(TelemetryData? telemetryData) {
    final bpm = telemetryData?.bpm ?? 0;
    final spo2 = telemetryData?.spo2 ?? 0;
    
    return Row(
      spacing: 24.w,
      children: [
        Expanded(
          child: MetricCard(
            value: "$bpm",
            label: "Frecuencia Cardíaca",
            iconUrl: "assets/svg/heart.svg",
            iconSize: 24.w,
            spacing: 12.h,
            backgroundColor: const Color.fromRGBO(245, 129, 163, 0.8),
          ),
        ),
        Expanded(
          child: MetricCard(
            value: "$spo2%",
            label: "Oxigenación",
            iconUrl: "assets/svg/spo.svg",
            iconSize: 16.w,
            spacing: 12.h,
            backgroundColor: const Color.fromRGBO(0, 191, 189, 0.8),
          ),
        ),
      ],
    );
  }
}