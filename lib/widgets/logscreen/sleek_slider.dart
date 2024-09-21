import 'package:flutter/material.dart';
class SleekSlider extends StatelessWidget {
  const SleekSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14.0,fontWeight:FontWeight.w700)),
          Slider(
            value: value,
            min: 1.0,
            max: 10.0,
            divisions: 9,
            label: value.round().toString(),
            onChanged: onChanged,
            activeColor: Colors.black,
            inactiveColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
