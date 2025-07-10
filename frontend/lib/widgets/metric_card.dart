import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget genérico para mostrar métricas o información con ícono
/// Completamente personalizable en colores, tamaños, textos e íconos
class MetricCard extends StatelessWidget {
  /// Valor principal a mostrar (número, texto, etc.)
  final String value;
  
  /// Texto descriptivo debajo del valor
  final String label;
  
  /// Ícono a mostrar, puede ser un IconData, una ruta de asset SVG o un Widget personalizado
  final String iconUrl;
  
  /// Color de fondo del card
  final Color backgroundColor;
  
  /// Color del ícono
  final Color iconColor;
  
  /// Color del texto del valor
  final Color valueColor;
  
  /// Color del texto de la etiqueta
  final Color labelColor;
  
  /// Tamaño del card
  final Size? size;
  
  /// Tamaño del ícono
  final double iconSize;

  /// Si el ícono debe ir a un lado del texto (true) o encima (false)
  final bool sideIcon;
  
  /// Tamaño de fuente del valor
  final double valueFontSize;
  
  /// Tamaño de fuente de la etiqueta
  final double labelFontSize;
  
  /// Peso de la fuente del valor
  final FontWeight valueFontWeight;
  
  /// Peso de la fuente de la etiqueta
  final FontWeight labelFontWeight;
  
  /// Border radius del card
  final double borderRadius;
  
  /// Padding interno del card
  final EdgeInsetsGeometry? padding;
  
  /// Función a ejecutar cuando se toca el card
  final VoidCallback? onTap;
  
  /// Sombra del card
  final List<BoxShadow>? boxShadow;
  
  /// Gradiente de fondo (opcional, sobrescribe backgroundColor)
  final Gradient? gradient;
  
  /// Espaciado entre elementos
  final double spacing;

  const MetricCard({
    super.key,
    required this.value,
    required this.label,
    required this.iconUrl,
    this.backgroundColor = const Color.fromRGBO(245, 129, 163, 1),
    this.iconColor = Colors.white,
    this.valueColor = Colors.white,
    this.labelColor = Colors.white,
    this.size,
    this.iconSize = 24,
    this.sideIcon = false,
    this.valueFontSize = 36,
    this.labelFontSize = 14,
    this.valueFontWeight = FontWeight.bold,
    this.labelFontWeight = FontWeight.w400,
    this.borderRadius = 16,
    this.padding,
    this.onTap,
    this.boxShadow,
    this.gradient,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    final cardSize = size ?? Size(140.w, 120.h);
    final cardPadding = padding ?? EdgeInsets.all(16.w);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardSize.width,
        padding: cardPadding,
        decoration: BoxDecoration(
          color: gradient == null ? backgroundColor : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius.r),
          boxShadow: boxShadow ?? [
            BoxShadow(
              color: Colors.black.withAlpha(1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: sideIcon ? _buildSideIconLayout() : _buildVerticalLayout(),
      ),
    );
  }

  Widget _buildVerticalLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: spacing.h,
      children: [
        // Ícono
        SvgPicture.asset(
          iconUrl,
          width: iconSize.w,
        ),
        // Valor principal
        Text(
          value,
          style: TextStyle(
            fontSize: valueFontSize.sp,
            fontWeight: valueFontWeight,
            color: valueColor,
          ),
          textAlign: TextAlign.center,
        ),
        // Etiqueta
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize.sp,
            fontWeight: labelFontWeight,
            color: labelColor,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildSideIconLayout() {
    return Stack(
      children: [
        // Contenido centrado en toda la card (sin padding)
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: spacing.h,
            children: [
              // Valor principal
              Text(
                value,
                style: TextStyle(
                  fontSize: valueFontSize.sp,
                  fontWeight: valueFontWeight,
                  color: valueColor,
                ),
                textAlign: TextAlign.center,
              ),
              // Etiqueta
              Text(
                label,
                style: TextStyle(
                  fontSize: labelFontSize.sp,
                  fontWeight: labelFontWeight,
                  color: labelColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        // Ícono posicionado absolutamente a la izquierda
        Positioned(
          left: 16.w,
          top: 0,
          bottom: 0,
          child: Center(
            child: SvgPicture.asset(
              iconUrl,
              width: iconSize.w,
            ),
          ),
        ),
      ],
    );
  }
}
