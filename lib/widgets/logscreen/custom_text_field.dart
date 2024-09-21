import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final int maxLines;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;

  const CustomTextField({
    required this.label,
    required this.placeholder,
    this.maxLines = 1,
    required this.validator,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
