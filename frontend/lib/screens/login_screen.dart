import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/widgets/input.dart';
import 'package:frontend/widgets/custom_checkbox.dart';
import 'package:frontend/api/api.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Por favor, completa todos los campos');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userService = ServiceLocator().userService;
      
      final response = await userService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (response.success) {
        // Login exitoso
        final token = response.data!['access'] as String;
        ServiceLocator().updateAuthToken(token);
        
        // Navegar al home
        if (mounted) {
          context.go('/home');
        }
      }
    } on ApiException catch (e) {
      String errorMessage = e.message;
      
      // Personalizar mensajes según el código de estado
      switch (e.statusCode) {
        case 401:
          errorMessage = 'Credenciales incorrectas';
          break;
        case 429:
          errorMessage = 'Demasiados intentos. Intenta más tarde';
          break;
      }
      
      _showSnackBar(errorMessage);
    } catch (e) {
      _showSnackBar('Error inesperado. Intenta más tarde');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            24.w,
            120.h,
            24.w,
            24.h
          ),
          child: Column(
            spacing: 32.h,
            children: [
              Column(
                spacing: 16.r,
                children: [
                  Container(
                    width: 50.w,
                    height: 50.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 49, 34, 137)
                    ),
                    child: SvgPicture.asset(
                      'assets/svg/heart.svg',
                      width: 24.w,
                    ),
                  ),
                  Text(
                    'Iniciar sesión',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                spacing: 16.h,
                children: [
                  Column(
                  spacing: 12.h,
                  children: [
                      BasicInput(
                        hintText: "Ingresa tu email",
                        labelText: "Email",
                        controller: _emailController,
                      ),
                      BasicInput(
                        hintText: "Ingresa tu contraseña",
                        labelText: "Contraseña",
                        controller: _passwordController,
                        isPassword: true, // Esto habilita la funcionalidad de contraseña
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomCheckbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                        text: 'Recordarme',
                        activeColor: const Color.fromRGBO(245, 129, 163, 1),
                        textColor: Colors.white,
                        fontSize: 14.sp,
                      )
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: const Color.fromRGBO(245, 129, 163, 1),
                      minimumSize: Size(double.infinity, 48.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Iniciar sesión'),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8.h,
                children: [
                  Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navegar a la pantalla de registro
                      if (mounted) {
                        context.push('/register');
                      }
                    },
                    child: Text(
                      'No tienes cuenta? Regístrate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}