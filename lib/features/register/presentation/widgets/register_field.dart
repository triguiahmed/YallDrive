import 'package:flutter/material.dart';

class RegisterField extends StatelessWidget {
  final String label;
  final TextInputType inputType;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final Future<void> Function(String input)? onChanged;

  const RegisterField({
    super.key,
    required this.label,
    this.inputType = TextInputType.text,
    required this.controller,
    required this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: inputType,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
