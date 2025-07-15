import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend/widgets/common_widgets.dart';

class DeviceScreen extends ConsumerWidget {
  const DeviceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommonScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenHeader(title: 'Dispositivo'),
          SizedBox(height: 32.h),
          _buildDeviceCard(),
          SizedBox(height: 32.h),
          _buildDisconnectButton(context),
        ],
      ),
    );
  }

  /// Tarjeta principal del dispositivo
  Widget _buildDeviceCard() {
    return Row(
      spacing: 12.h,
      children: [
        // Imagen del dispositivo
        _buildDeviceImage(),
        
        // Información del dispositivo
        _buildDeviceInfo(),
      ],
    );
  }

  /// Imagen del dispositivo
  Widget _buildDeviceImage() {
    return SizedBox(
      width: 150.w,
      height: 255.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.asset(
          'assets/images/pulsera_imagen.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.watch_outlined,
              size: 60.w,
              color: Colors.white.withValues(alpha: 0.6),
            );
          },
        ),
      ),
    );
  }

  /// Información del dispositivo
  Widget _buildDeviceInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.h,
      children: [
        // Nombre del dispositivo con icono de edición
        _buildDeviceNameRow(),
        
        // MAC Address
        _buildInfoColumn('Mac Address:', '00:1A:2B:3C:4D:5E'),
        
        // Estado de conexión
        _buildConnectionStatus(),

        // Nivel de batería
        _buildBatteryLevel(),
      ],
    );
  }

  /// Fila con nombre del dispositivo y botón de edición
  Widget _buildDeviceNameRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'PapuBand',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: () {
            // TODO: Implementar edición del nombre
          },
          child: Icon(
            Icons.edit_outlined,
            color: Colors.white.withValues(alpha: 0.7),
            size: 20.w,
          ),
        ),
      ],
    );
  }

  /// Fila de información genérica
  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Estado de conexión
  Widget _buildConnectionStatus() {
    return Text(
        'Conectado',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white
        ),
      );
  }

  /// Nivel de batería
  Widget _buildBatteryLevel() {
    const batteryLevel = 91; // Valor hardcodeado, después se puede hacer dinámico
    
    return Row(
      spacing: 9.w,
      children: [
        Row(
          children: [
            Icon(
              Icons.battery_full,
              color: Colors.white.withValues(alpha: 0.7),
              size: 20.w,
            ),
            SizedBox(width: 8.w),
            Text(
              'Batería:',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          '$batteryLevel%',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Botón de desconectar
  Widget _buildDisconnectButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showDisconnectDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
        ),
        child: Text(
          'Desvincular',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Muestra el diálogo de confirmación para desconectar
  void _showDisconnectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            '¿Desvincular dispositivo?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Esta acción desconectará el dispositivo PapuBand. Tendrás que vincularlo nuevamente para volver a usarlo.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14.sp,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implementar lógica de desconexión
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dispositivo desvinculado'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: Text(
                'Desvincular',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
