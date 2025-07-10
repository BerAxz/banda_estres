import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/widgets/common_widgets.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenHeader(title: 'Cuenta'),
          SizedBox(height: 32.h),
          _buildAccountSection(context),
          SizedBox(height: 24.h),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  /// Sección de cuenta usando widgets comunes
  Widget _buildAccountSection(BuildContext context) {
    final accountOptions = [
      OptionItem(
        title: 'Correo electrónico',
        subtitle: 'Harr***anc@gmail.com',
        icon: Icons.email_outlined,
        onTap: () => _showEditEmailDialog(context),
      ),
      OptionItem(
        title: 'Cambiar contraseña',
        icon: Icons.lock_outline,
        onTap: () => _showChangePasswordDialog(context),
      ),
    ];

    return OptionsSection(options: accountOptions);
  }

  /// Botón de cerrar sesión
  Widget _buildLogoutButton() {
    return Builder(
      builder: (context) => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _showLogoutDialog(context),
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
            'Cerrar sesión',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// Muestra modal para editar email usando estilo común
  void _showEditEmailDialog(BuildContext context) {
    CommonTextEditModal.show(
      context: context,
      title: 'Cambiar correo electrónico',
      initialValue: '',
      keyboardType: TextInputType.emailAddress,
      hintText: 'Nuevo correo electrónico',
      onSave: (newEmail) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Correo actualizado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
  }

  /// Muestra modal para cambiar contraseña usando estilo común
  void _showChangePasswordDialog(BuildContext context) {
    CommonPasswordChangeModal.show(
      context: context,
      onSave: () {
        // Lógica de guardado aquí
      },
    );
  }

  /// Muestra modal de confirmación para logout
  void _showLogoutDialog(BuildContext context) {
    CommonConfirmationModal.show(
      context: context,
      title: '¿Cerrar sesión?',
      message: '¿Estás seguro de que deseas cerrar sesión?',
      confirmText: 'Cerrar sesión',
      onConfirm: () {
        context.go('/login');
      },
    );
  }
}
