import 'package:coalworks/widgets/logscreen/sleek_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HazardReport extends StatefulWidget {
  const HazardReport({super.key});

  @override
  State<HazardReport> createState() => _HazardReportState();
}

class _HazardReportState extends State<HazardReport> {
  final _formKey = GlobalKey<FormState>();

  String _hazardType = 'Physical';
  String _severityLevel = 'Low';
  bool _requiresImmediateAttention = false;
  double _urgencyLevel = 0;
  String _description = '';
  DateTime _reportDate = DateTime.now();
  String _location = 'Fetching location...';

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    // Simulate location fetching, replace with actual location logic
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _location = 'Mine Shaft #3, Section B';
    });
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Submit the hazard report
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hazard report submitted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hazard Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Hazard Type',
                ),
                value: _hazardType,
                items: ['Physical', 'Chemical', 'Biological', 'Ergonomic', 'Psychosocial']
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _hazardType = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Severity Level',
                ),
                value: _severityLevel,
                items: ['Low', 'Medium', 'High']
                    .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _severityLevel = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Requires Immediate Attention'),
                value: _requiresImmediateAttention,
                onChanged: (value) {
                  setState(() {
                    _requiresImmediateAttention = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              SleekSlider(
                value: 5,
                label: 'Sevrity',
                onChanged: (value) {
                  setState(() {
                    _urgencyLevel = value;
                  });
                },
                //label: '${_urgencyLevel.toInt()}',
              ),
              const SizedBox(height: 20),
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _description = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Report Date'),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(_reportDate)),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _reportDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != _reportDate) {
                      setState(() {
                        _reportDate = pickedDate;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Location'),
                subtitle: Text(_location),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitReport,
                child: const Text('Submit Report', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
