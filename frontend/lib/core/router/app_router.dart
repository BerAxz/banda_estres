import 'package:frontend/screens/account_screen.dart';
import 'package:frontend/screens/device_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/register_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/menu_screen.dart';
import 'package:frontend/screens/personal_data_screen.dart';
import 'package:frontend/screens/placeholder_screen.dart';

/// Configuración de rutas de la aplicación usando GoRouter
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      // Ruta de login
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      
      // Ruta de registro
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
        ),
      ),
      
      // Ruta del home/dashboard
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
      ),
      
      // Ruta del menú
      GoRoute(
        path: '/menu',
        name: 'menu',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const MenuScreen(),
        ),
      ),
      
      // Rutas placeholder para el menú
      GoRoute(
        path: '/profile',
        name: 'profile',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const PersonalDataScreen(),
        ),
      ),
      GoRoute(
        path: '/account',
        name: 'account',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const AccountScreen(),
        ),
      ),
      GoRoute(
        path: '/device',
        name: 'device',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const DeviceScreen(),
        ),
      ),
      GoRoute(
        path: '/sessions',
        name: 'sessions',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const PlaceholderScreen(
            title: 'Sesiones',
            icon: Icons.timeline_outlined,
            description: 'Revisa tus sesiones de monitoreo y análisis.',
          ),
        ),
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const PlaceholderScreen(
            title: 'Historial de eventos',
            icon: Icons.history_outlined,
            description: 'Consulta el historial completo de eventos de estrés.',
          ),
        ),
      ),
      
      // Ruta por defecto - redirige al login
      GoRoute(
        path: '/',
        redirect: (context, state) => '/login',
      ),
    ],
    
    // Configuraciones adicionales
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              'Página no encontrada',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'La ruta "${state.uri}" no existe',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: Text('Ir al Login'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Extension para facilitar la navegación
extension AppRouterExtension on BuildContext {
  /// Navegar al login
  void goToLogin() => go('/login');
  
  /// Navegar al registro
  void goToRegister() => go('/register');
  
  /// Navegar al home
  void goToHome() => go('/home');
  
  /// Reemplazar la ruta actual con login
  void replaceWithLogin() => pushReplacement('/login');
  
  /// Reemplazar la ruta actual con home
  void replaceWithHome() => pushReplacement('/home');
}
