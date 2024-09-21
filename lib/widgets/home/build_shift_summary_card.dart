import 'package:flutter/material.dart';

class buildshiftsummarycard extends StatefulWidget {
  const buildshiftsummarycard({super.key});

  @override
  State<buildshiftsummarycard> createState() => _buildshiftsummarycardState();
}

class _buildshiftsummarycardState extends State<buildshiftsummarycard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shift Summary',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildSummaryMetric('Tasks Completed', '23'),
            const SizedBox(height: 5),
            _buildSummaryMetric('Issues Logged', '5'),
            const SizedBox(height: 5),
            _buildSummaryMetric('Critical Alerts', '2'),
          ],
        ),
      ),
    );
  }
}
  Widget _buildSummaryMetric(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[500], fontSize: 16, fontWeight: FontWeight.w700),
        ),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
