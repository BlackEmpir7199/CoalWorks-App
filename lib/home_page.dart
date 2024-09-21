import 'package:flutter/material.dart';
import 'package:coalworks/widgets/home/build_shift_summary_card.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body:SingleChildScrollView (
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildshiftsummarycard(),
                  SizedBox(height: 20),
                  _buildSafetyAlertsSection(),
                  SizedBox(height: 20),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyAlertsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Safety Alerts',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        _buildSafetyAlertCard(
          title: 'Fire Hazard near Conveyor Belt',
          description:
              'Immediate action required to control the fire near the main conveyor belt.',
          timestamp: '5 mins ago',
        ),
        SizedBox(height: 10),
        _buildSafetyAlertCard(
          title: 'Equipment Malfunction',
          description: 'Critical equipment malfunction detected in section B.',
          timestamp: '20 mins ago',
        ),
      ],
    );
  }

  Widget _buildSafetyAlertCard(
      {required String title,
      required String description,
      required String timestamp}) {
    return Card(
      color: const Color.fromARGB(255, 245, 245, 245),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          description,
          style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),

        ),
        trailing: Text(
          timestamp,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

