import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/widgets/background_container.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'api/api.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar el sistema UI
  await _configureSystemUI();
  
  // Inicializar servicios
  await _initializeServices();
  
  // Inicializar la aplicación
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

/// Configura el sistema UI para edge-to-edge
Future<void> _configureSystemUI() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}

/// Inicializa los servicios necesarios de la aplicación
Future<void> _initializeServices() async {
  ServiceLocator().initialize();
  await ScreenUtil.ensureScreenSize();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'Banda de Estrés IoT',
          debugShowCheckedModeBanner: false,
          theme: _buildAppTheme(),
          home: child,
          builder: _buildAppWrapper,
        );
      },
      child: const LoginScreen(),
    );
  }

  /// Construye el tema principal de la aplicación
  ThemeData _buildAppTheme() {
    return ThemeData(
      fontFamily: 'SfPro',
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      scaffoldBackgroundColor: Colors.transparent,
    );
  }

  /// Wrapper que aplica configuraciones globales a la aplicación
  Widget _buildAppWrapper(BuildContext context, Widget? child) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: BackgroundContainer(
        child: child ?? const SizedBox(),
      ),
    );
  }
}