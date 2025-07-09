import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/widgets/input.dart';
import 'package:frontend/widgets/custom_checkbox.dart';
import 'package:frontend/api/api.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  
  bool _isLoading = false;
  bool _acceptTerms = false;

  Future<void> _register() async {
    if (!_validateForm()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userService = ServiceLocator().userService;
      
      final response = await userService.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        nombre: _nombreController.text.trim(),
        apellido: _apellidoController.text.trim(),
        tipoUsuario: 'estudiante', // Valor por defecto
      );

      if (response.data != null) {
        // Registro exitoso, navegar al login
        _showSnackBar('Registro exitoso. Ahora puedes iniciar sesión');
        if (mounted) {
          context.go('/login');
        }
      }
    } on ApiException catch (e) {
      String errorMessage = e.message;
      
      // Personalizar mensajes según el código de estado
      switch (e.statusCode) {
        case 400:
          errorMessage = 'El email ya está registrado';
          break;
        case 422:
          errorMessage = 'Datos inválidos. Revisa los campos';
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

  bool _validateForm() {
    if (_emailController.text.isEmpty || 
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _nombreController.text.isEmpty ||
        _apellidoController.text.isEmpty) {
      _showSnackBar('Por favor, completa todos los campos obligatorios');
      return false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar('Las contraseñas no coinciden');
      return false;
    }

    if (_passwordController.text.length < 8) {
      _showSnackBar('La contraseña debe tener al menos 8 caracteres');
      return false;
    }

    if (!_acceptTerms) {
      _showSnackBar('Debes aceptar los términos y condiciones');
      return false;
    }

    return true;
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            if (mounted && context.canPop()) {
              context.pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            24.w,
            20.h,
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
                    'Crear cuenta',
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
                      // Información personal
                      Row(
                        children: [
                          Expanded(
                            child: BasicInput(
                              hintText: "Nombre",
                              labelText: "Nombre *",
                              controller: _nombreController,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: BasicInput(
                              hintText: "Apellido",
                              labelText: "Apellido *",
                              controller: _apellidoController,
                            ),
                          ),
                        ],
                      ),
                      
                      // Email
                      BasicInput(
                        hintText: "Ingresa tu email",
                        labelText: "Email *",
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      
                      // Contraseñas
                      BasicInput(
                        hintText: "Ingresa tu contraseña",
                        labelText: "Contraseña *",
                        controller: _passwordController,
                        isPassword: true,
                      ),
                      BasicInput(
                        hintText: "Confirma tu contraseña",
                        labelText: "Confirmar contraseña *",
                        controller: _confirmPasswordController,
                        isPassword: true,
                      ),
                    ],
                  ),
                  
                  // Términos y condiciones
                  Row(
                    children: [
                      Expanded(
                        child: CustomCheckbox(
                          value: _acceptTerms,
                          onChanged: (value) {
                            setState(() {
                              _acceptTerms = value ?? false;
                            });
                          },
                          text: 'Acepto los términos y condiciones',
                          activeColor: const Color.fromRGBO(245, 129, 163, 1),
                          textColor: Colors.white,
                          fontSize: 14.sp,
                        ),
                      )
                    ],
                  ),
                  
                  // Botón de registro
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
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Crear cuenta'),
                  ),
                ],
              ),
              
              // Link para ir al login
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8.h,
                children: [
                  Text(
                    '¿Ya tienes una cuenta?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (mounted) {
                        context.go('/login');
                      }
                    },
                    child: Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
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
    _confirmPasswordController.dispose();
    _nombreController.dispose();
    _apellidoController.dispose();
    super.dispose();
  }
}
