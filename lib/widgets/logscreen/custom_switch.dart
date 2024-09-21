import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final String label;
  final Color color;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    required this.label,
    required this.color,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: SwitchListTile(
          inactiveThumbColor: color.withOpacity(0.8),
          inactiveTrackColor: color.withOpacity(0.2),
          title: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w600, color: color),
          ),
          value: value,
          onChanged: onChanged,
          activeColor: color,
        ),
      ),
    );
  }
}
