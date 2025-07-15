import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String text;
  final Color? activeColor;
  final Color? textColor;
  final double? fontSize;
  final bool enabled;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.text,
    this.activeColor,
    this.textColor,
    this.fontSize,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: enabled ? onChanged : null,
          activeColor: activeColor ?? Colors.white,
          checkColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
          fillColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return Colors.grey.withAlpha(30);
              }
              if (states.contains(WidgetState.selected)) {
                return activeColor ?? Colors.white;
              }
              return Colors.transparent;
            },
          ),
          side: WidgetStateBorderSide.resolveWith(
            (states) => BorderSide(
              color: enabled 
                ? (activeColor ?? Colors.white)
                : Colors.grey.withAlpha(30),
              width: 2,
            ),
          ),
        ),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: enabled 
                ? (textColor ?? Colors.white)
                : Colors.grey.withAlpha(50),
              fontSize: fontSize ?? 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
