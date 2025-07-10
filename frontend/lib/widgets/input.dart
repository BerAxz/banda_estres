import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BasicInput extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool isPassword;

  const BasicInput({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.isPassword = false,
  });

  @override
  State<BasicInput> createState() => _BasicInputState();
}

class _BasicInputState extends State<BasicInput> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final bool shouldObscureText = widget.isPassword ? !_isPasswordVisible : widget.obscureText;
    return TextFormField(
      controller: widget.controller,
      obscureText: shouldObscureText,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      validator: widget.validator,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Color.fromARGB(255, 129, 129, 129)
        ),
        labelText: widget.labelText,
        filled: true,
        fillColor: Colors.black.withAlpha(50),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none
        ),
        suffixIcon: widget.isPassword 
          ? Padding(
            padding: EdgeInsets.only(right: 8.w),
              child: IconButton(
                icon: SvgPicture.asset(
                  _isPasswordVisible 
                    ? 'assets/svg/iconamoon_eye-off.svg'
                    : 'assets/svg/iconamoon_eye.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    Color.fromARGB(255, 129, 129, 129),
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
          )
          : null,
      ),
    );
  }
}