import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/widgets/common_widgets.dart';

/// Modelo para elementos del menú
class MenuItem {
  final String title;
  final IconData icon;
  final String route;
  final VoidCallback? onTap;

  const MenuItem({
    required this.title,
    required this.icon,
    required this.route,
    this.onTap,
  });
}

/// Pantalla del menú principal
class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  /// Lista de elementos del menú organizados por secciones
  static const List<MenuItem> _personalDataItems = [
    MenuItem(
      title: 'Datos personales',
      icon: Icons.person_outline,
      route: '/profile',
    ),
    MenuItem(
      title: 'Cuenta',
      icon: Icons.account_circle_outlined,
      route: '/account',
    ),
    MenuItem(
      title: 'Dispositivo',
      icon: Icons.watch_outlined,
      route: '/device',
    ),
  ];

  static const List<MenuItem> _sessionItems = [
    MenuItem(
      title: 'Sesiones',
      icon: Icons.timeline_outlined,
      route: '/sessions',
    ),
    MenuItem(
      title: 'Historial de eventos',
      icon: Icons.history_outlined,
      route: '/history',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommonScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenHeader(title: 'Menu'),
          SizedBox(height: 32.h),
          _buildPersonalDataSection(context),
          SizedBox(height: 24.h),
          _buildSessionSection(context),
        ],
      ),
    );
  }

  /// Sección de datos personales
  Widget _buildPersonalDataSection(BuildContext context) {
    final personalOptions = _personalDataItems.map((item) => OptionItem(
      title: item.title,
      icon: item.icon,
      onTap: () => _handleMenuTap(context, item),
    )).toList();

    return OptionsSection(options: personalOptions);
  }

  /// Sección de sesiones
  Widget _buildSessionSection(BuildContext context) {
    final sessionOptions = _sessionItems.map((item) => OptionItem(
      title: item.title,
      icon: item.icon,
      onTap: () => _handleMenuTap(context, item),
    )).toList();

    return OptionsSection(options: sessionOptions);
  }

  /// Maneja el tap en elementos del menú
  void _handleMenuTap(BuildContext context, MenuItem item) {
    // Por ahora solo navega, después se pueden implementar las rutas específicas
    context.push(item.route);
  }
}
