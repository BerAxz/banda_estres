import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/register_screen.dart';
import 'package:frontend/screens/home_screen.dart';

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
