import 'package:coalworks/screens/smpscreens/hazard_report_tool.dart';
import 'package:coalworks/screens/smpscreens/interactive_checklist_page.dart';
import 'package:coalworks/screens/smpscreens/view_safety_protocols_page.dart';
import 'package:flutter/material.dart';

class SmpPage extends StatefulWidget {
  const SmpPage({super.key});

  @override
  State<SmpPage> createState() => _SmpPageState();
}

class _SmpPageState extends State<SmpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Safety Management Plan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Digital Protocols Section
              _buildDigitalProtocolsSection(),

              SizedBox(height: 20),

              // Interactive Checklists Section
              _buildInteractiveChecklistsSection(),

              SizedBox(height: 20),

              // Hazard Reporting Tool Section
              _buildHazardReportingToolSection(),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Navigate to hazard reporting form
      //   },
      //   backgroundColor: Colors.black,
      //   child: Icon(Icons.add,color: Colors.white,),
      // ),
    );
  }

  Widget _buildDigitalProtocolsSection() {
    return Card(
      // color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3.0,
      shadowColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Digital Protocols',
              style: TextStyle(
                // color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Access all DGMS-required safety protocols digitally. Review them anytime during your shift.',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to digital protocols list
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SafetyProtocols()));
              },
              icon: Icon(Icons.article),
              label: Text('View Safety Protocols'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveChecklistsSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interactive Checklists',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Follow step-by-step checklists for safety inspections. Ensure that all safety procedures are followed without missing any steps.',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to interactive checklists
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CheckListPage()));
              },
              icon: Icon(Icons.checklist),
              label: Text('View Checklists'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHazardReportingToolSection() {
    return Card(
      // color: const Color.fromARGB(255, 123, 18, 11).withOpacity(0.5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(width: 1.5, color: Colors.redAccent)),
      shadowColor: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hazard Reporting Tool',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Report any hazards immediately. Attach relevant photos or descriptions to the report, which will be sent to supervisors and stored for audit purposes.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to hazard reporting form
                                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HazardReport()));
              },
              icon: Icon(Icons.report_problem),
              label: Text(
                'Report a Hazard',
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
