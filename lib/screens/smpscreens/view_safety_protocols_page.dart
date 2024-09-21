import 'package:flutter/material.dart';

class SafetyProtocols extends StatefulWidget {
  const SafetyProtocols({super.key});

  @override
  State<SafetyProtocols> createState() => _SafetyProtocolsState();
}

class _SafetyProtocolsState extends State<SafetyProtocols> {
  final List<Map<String, String>> protocols = [
    {
      'title': 'Underground Mining Safety',
      'details': '1. Proper ventilation must be ensured in all underground workings.\n'
          '2. Adequate illumination is mandatory in underground mines.\n'
          '3. Regular inspection of roof and side walls to prevent falls.\n'
          '4. Use of approved personal protective equipment (PPE) like helmets, boots, and gloves.\n'
          '5. Emergency exit plans must be clearly marked and accessible.\n'
          '6. All workers must be trained in first-aid and firefighting.\n'
          '7. Regular safety drills and inspections must be conducted.\n'
          '8. All electrical installations must be flameproof and regularly inspected.'
    },
    {
      'title': 'Machinery Operation',
      'details': '1. Onlytrained and certified operator must handle mining machinery.\n'
          '2. Daily pre-shift inspectio of all machinery is mandatory.\n'
          '3. Emergency stop device must be installed and accessible on all machinery.\n'
          '4. Proper guarding ofmoving part to prevent accidental contact.\n'
          '5. Regularmaintenance schedule must be adhered to as per manufacturer guidelines.\n'
          '6. Use oflockout/tagout procedure during maintenance to prevent accidental startup.\n'
          '7. Ensure that all vehicles are equipped withfunctional lights and alarm.\n'
          '8. Seat belt and other safety devices must be used at all times.'
    },
    {
      'title': 'Handling Explosives',
      'details': '1. Onlyauthorized personne must handle and use explosives.\n'
          '2. Explosives must be stored insecure, well-ventilated magazine.\n'
          '3. A strictinventory of explosive must be maintained.\n'
          '4. Detonators and explosive must be stored separately to prevent accidental detonation.\n'
          '5. Propersignag must be displayed in areas where explosives are stored or used.\n'
          '6. All personnel must beevacuate to a safe distance before detonation.\n'
          '7. Regulartraining on the safe handlin of explosives must be provided.\n'
          '8. Compliance with all statutory regulations regarding theuse and storag of explosives.'
    },
    {
      'title': 'Fire Prevention and Control',
      'details': '1. All mines must have a fire prevention plan approved by DGMS.\n'
          '2. Regular fire drill must be conducted for all personnel.\n'
          '3. Firefighting equipment must be readily available and accessible.\n'
          '4. Smoking is strictly prohibite in all hazardous areas.\n'
          '5. Electrical wirin must be regularly inspected for faults that could lead to fire.\n'
          '6. Flammable material must be stored away from heat sources.\n'
          '7. Adequate ventilatio must be maintained to prevent the buildup of flammable gases.\n'
          '8. Emergency exit must be clearly marked and unobstructed at all times.'
    },
    {
      'title': 'Emergency Response',
      'details': '1. All mines must have an emergency response plan in place, approved by DGMS.\n'
          '2. All workers must be trained in emergency evacuation procedure.\n'
          '3. Communication systems must be in place to alert workers of emergencies.\n'
          '4. First aid station must be equipped and manned at all times.\n'
          '5. Rescue team must be trained and equipped to handle any emergency.\n'
          '6. Emergency shelters must be available in underground mines.\n'
          '7. Regular audits of emergency equipment and procedure must be conducted.\n'
          '8. Coordination with local authoritie and hospitals for emergency support.'
    },
  ];

  final Map<String, IconData> protocolIcons = {
    'Underground Mining Safety': Icons.construction,
    'Machinery Operation': Icons.precision_manufacturing,
    'Handling Explosives': Icons.warning,
    'Fire Prevention and Control': Icons.local_fire_department,
    'Emergency Response': Icons.health_and_safety,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Protocols'),
      ),
      body: ListView.builder(
        itemCount: protocols.length,
        itemBuilder: (context, index) {
          return ProtocolCard(
            icon: protocolIcons[protocols[index]['title']]!,
            title: protocols[index]['title']!,
            onTap: () => _showProtocolDetails(context,
                protocols[index]['title']!, protocols[index]['details']!),
          );
        },
      ),
    );
  }

  void _showProtocolDetails(
      BuildContext context, String title, String details) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: _buildAccordion(details),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
      },
    );
  }

  Widget _buildAccordion(String details) {
    final sections = details.split('\n');
    return ListView.builder(
      shrinkWrap: true,
      itemCount: sections.length,
      itemBuilder: (context, index) {
        return ExpansionTile(
          title: Text(
            'Step ${index + 1}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),

              child: Text(
                sections[index],
                style: const TextStyle(color: Colors.black54, height: 1.5),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProtocolCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData icon;

  const ProtocolCard(
      {required this.title, required this.onTap, required this.icon, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
