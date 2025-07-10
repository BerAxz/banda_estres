import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend/widgets/common_widgets.dart';

/// Modelo para campos de datos personales
class PersonalDataField {
  final String label;
  final String value;
  final TextInputType inputType;
  final bool isDate;

  const PersonalDataField({
    required this.label,
    required this.value,
    this.inputType = TextInputType.text,
    this.isDate = false,
  });
}

/// Pantalla de datos personales
class PersonalDataScreen extends ConsumerStatefulWidget {
  const PersonalDataScreen({super.key});

  @override
  ConsumerState<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends ConsumerState<PersonalDataScreen> {
  /// Datos personales actuales (simulados)
  final List<PersonalDataField> _personalFields = [
    PersonalDataField(
      label: 'Nombre',
      value: 'Harryano',
    ),
    PersonalDataField(
      label: 'Apellido',
      value: 'Mariano',
    ),
    PersonalDataField(
      label: 'Fecha de nacimiento',
      value: '01/02/2005',
      isDate: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenHeader(title: 'Datos personales'),
          SizedBox(height: 32.h),
          _buildPersonalDataSection(),
        ],
      ),
    );
  }

  /// Sección de datos personales usando widgets comunes
  Widget _buildPersonalDataSection() {
    final personalOptions = _personalFields.map((field) => OptionItem(
      title: field.label,
      subtitle: field.value,
      onTap: () => _handleFieldTap(field),
    )).toList();

    return OptionsSection(options: personalOptions);
  }

  /// Maneja el tap en campos de datos
  void _handleFieldTap(PersonalDataField field) {
    if (field.isDate) {
      CommonDatePickerModal.show(
        context: context,
        currentValue: field.value,
        onSave: (newValue) => _updateFieldValue(field, newValue),
      );
    } else {
      CommonTextEditModal.show(
        context: context,
        title: 'Editar ${field.label}',
        initialValue: field.value,
        keyboardType: field.inputType,
        hintText: 'Ingrese ${field.label.toLowerCase()}',
        onSave: (newValue) => _updateFieldValue(field, newValue),
      );
    }
  }

  /// Actualiza el valor del campo
  void _updateFieldValue(PersonalDataField field, String newValue) {
    setState(() {
      final index = _personalFields.indexWhere((f) => f.label == field.label);
      if (index != -1) {
        _personalFields[index] = PersonalDataField(
          label: field.label,
          value: newValue,
          inputType: field.inputType,
          isDate: field.isDate,
        );
      }
    });
  }
}
