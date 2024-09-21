import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class buildDatePicker extends StatefulWidget {
    final TextEditingController dateTimeController;
    final String label;
    final String hint;
    const buildDatePicker({
    Key? key,
    required this.dateTimeController,
    required this.label,
    required this.hint,
    required Function(DateTime) onDateSelected,
  }): super(key: key);
  @override
  State<buildDatePicker> createState() => _buildDatePickerState();
}

class _buildDatePickerState extends State<buildDatePicker> {
  @override
  Widget build(BuildContext context) {
     return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: widget.dateTimeController,
        readOnly: true,
        onTap: () => _selectDateTime(context),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
      ),
    );
  }
  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      widget.dateTimeController.text = formattedDate;
    }
  }
}
