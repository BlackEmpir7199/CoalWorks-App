import 'package:flutter/material.dart';
class buildTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  const buildTextField({
    Key? key,
    required this.label,
    required this.placeholder,
  }): super(key: key);
  @override
  State<buildTextField> createState() => _buildTextFieldState();
}

class _buildTextFieldState extends State<buildTextField> {
  
  @override
  Widget build(BuildContext context) {
   return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.placeholder,
          border: const OutlineInputBorder(),
        ),
      ));
  }
}