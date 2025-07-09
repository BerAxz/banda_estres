import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend/api/api.dart';

class UserInfoCard extends ConsumerWidget {
  const UserInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<ApiResponse<User>>(
      future: ServiceLocator().userService.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.data == null) {
          // Show specific error message if available
          String errorMessage = 'Error al cargar información del usuario';
          if (snapshot.hasData && snapshot.data!.error != null) {
            errorMessage = 'Error: ${snapshot.data!.error}';
          } else if (snapshot.hasError) {
            errorMessage = 'Error de conexión: ${snapshot.error}';
          }
          
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
            ),
          );
        }

        final user = snapshot.data!.data!;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenido/a',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text('${user.nombre} ${user.apellido}'),
                Text('Email: ${user.email}'),
                Text('Tipo: ${user.tipoUsuario}'),
              ],
            ),
          ),
        );
      },
    );
  }
}