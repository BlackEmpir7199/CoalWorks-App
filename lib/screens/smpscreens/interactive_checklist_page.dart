import 'package:flutter/material.dart';

class CheckListPage extends StatefulWidget {
  const CheckListPage({super.key});

  @override
  State<CheckListPage> createState() => _CheckListPageState();
}

class _CheckListPageState extends State<CheckListPage> {
  final List<Map<String, dynamic>> checkListItems = [
    {
      'title': 'Personal Protective Equipment (PPE)',
      'description': 'Ensure all workers are equipped with necessary PPE: helmets, gloves, boots, goggles, etc.',
      'isChecked': false,
    },
    {
      'title': 'Ventilation Systems',
      'description': 'Check that all ventilation systems are operational and providing adequate airflow.',
      'isChecked': false,
    },
    {
      'title': 'Emergency Exits',
      'description': 'Verify that all emergency exits are clearly marked and unobstructed.',
      'isChecked': false,
    },
    {
      'title': 'Fire Extinguishers',
      'description': 'Ensure that all fire extinguishers are in place and fully charged.',
      'isChecked': false,
    },
    {
      'title': 'Machinery Safety',
      'description': 'Inspect all machinery for proper guarding and operational safety features.',
      'isChecked': false,
    },
    {
      'title': 'Electrical Safety',
      'description': 'Check all electrical installations for compliance with safety standards.',
      'isChecked': false,
    },
    {
      'title': 'First Aid Kits',
      'description': 'Confirm that first aid kits are fully stocked and easily accessible.',
      'isChecked': false,
    },
    {
      'title': 'Signage and Warnings',
      'description': 'Ensure all safety signs and warnings are in place and clearly visible.',
      'isChecked': false,
    },
    {
      'title': 'Training Records',
      'description': 'Verify that all workers have completed required safety training and certifications.',
      'isChecked': false,
    },
  ];

  void _toggleCheck(int index) {
    setState(() {
      checkListItems[index]['isChecked'] = !checkListItems[index]['isChecked'];
    });
  }

  void _resetChecklist() {
    setState(() {
      for (var item in checkListItems) {
        item['isChecked'] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Inspection Checklist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetChecklist,
            tooltip: 'Reset Checklist',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: checkListItems.length,
        itemBuilder: (context, index) {
          return ChecklistCard(
            title: checkListItems[index]['title'],
            description: checkListItems[index]['description'],
            isChecked: checkListItems[index]['isChecked'],
            onToggle: () => _toggleCheck(index),
          );
        },
      ),
    );
  }
}

class ChecklistCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isChecked;
  final VoidCallback onToggle;

  const ChecklistCard({
    required this.title,
    required this.description,
    required this.isChecked,
    required this.onToggle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white,
      child: ListTile(
        leading: Checkbox(
          value: isChecked,
          onChanged: (_) => onToggle(),
          activeColor: Colors.black,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: isChecked ? FontWeight.bold : FontWeight.normal,
            decoration: isChecked ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(color: Colors.black54),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.black),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  content: Text(description, style: const TextStyle(color: Colors.black54, height: 1.5)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                );
              },
            );
          },
        ),
        onTap: onToggle,
      ),
    );
  }
}
