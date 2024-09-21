import 'package:coalworks/database/database_helper.dart';
import 'package:coalworks/database/postgres_helper.dart';
import 'package:coalworks/widgets/logscreen/custom_switch.dart';
import 'package:coalworks/widgets/logscreen/custom_text_field.dart';
import 'package:coalworks/widgets/logscreen/location_display.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:coalworks/widgets/logscreen/date_picker.dart';
import 'package:coalworks/widgets/logscreen/sleek_dropdown.dart';

class ReportInjuryPage extends StatefulWidget {
  const ReportInjuryPage({super.key});

  @override
  _ReportInjuryPageState createState() => _ReportInjuryPageState();
}

class _ReportInjuryPageState extends State<ReportInjuryPage> {
  final TextEditingController _dateTimeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'injuryType': '',
    'injuredPerson': '',
    'location': '',
    'coordinates': '',
    'severity': '',
    'description': '',
    'timestamp': DateTime.now().toIso8601String(),
    'isResolved': false,
  };

  String? _selectedInjuryType;
  String? _selectedSeverity;
  Position? _currentPosition;
  String? _selectedLocation;
  final List<String> _severityOptions = ['Mild', 'Severe', 'Critical'];
  final List<String> _injuryTypes = ['Fracture', 'Bruise', 'Cuts'];
  final List<Icon> _injuryIcons = [
    Icon(Icons.grain),
    Icon(Icons.local_hospital),
    Icon(Icons.cut)
  ];
  final List<String> _locations = [
    'Section A',
    'Section B',
    'Zone 1',
    'Zone 2',
    'Zone 3'
  ];
  final Map<String, Color> _severityColors = {
    'Mild': Colors.green,
    'Severe': Colors.orange,
    'Critical': Colors.red,
  };

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _dateTimeController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        _formData['coordinates'] =
            'Lat: ${position.latitude}, Lon: ${position.longitude}';
      });
    } catch (e) {
      // Handle location error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Report an Injury',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SleekDropdown(
                  hint: 'Select Injury Type',
                  items: _injuryTypes,
                  label: 'Injury Type',
                  iconsEach: _injuryIcons,
                  onChanged: (value) => setState(() {
                    _selectedInjuryType = value;
                    _formData['injuryType'] = value!;
                  }),
                  selectedValue: _selectedInjuryType,
                ),
                CustomTextField(
                  label: 'Injured Person',
                  placeholder: 'Name of the injured person',
                  validator: (value) => value!.isEmpty
                      ? 'Please enter the name of the injured person'
                      : null,
                  onSaved: (value) => _formData['injuredPerson'] = value!,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SleekDropdown(
                        label: 'Location',
                        hint: 'Select Location',
                        items: _locations,
                        selectedValue: _selectedLocation,
                        onChanged: (value) => setState(() {
                          _selectedLocation = value;
                          _formData['location'] = value!;
                        }),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: buildDatePicker(
                          dateTimeController: _dateTimeController,
                          label: 'Select Time',
                          hint: 'Select Time',
                          onDateSelected: (date) {
                            setState(() {
                              _formData['timestamp'] = date.toIso8601String();
                            });
                          }),
                    ),
                  ],
                ),
                LocationDisplay(
                  currentPosition: _currentPosition,
                  onRefresh: _getCurrentLocation,
                ),
                _buildChoiceChips(),
                CustomTextField(
                  label: 'Description',
                  placeholder: 'Describe the incident in detail...',
                  maxLines: 3,
                  validator: (value) => value!.isEmpty
                      ? 'Please provide a detailed description'
                      : null,
                  onSaved: (value) => _formData['description'] = value!,
                ),
                CustomSwitch(
                  label: 'First Aid Provided',
                  color: Colors.green,
                  value: _formData['isResolved'],
                  onChanged: (value) {
                    setState(() {
                      _formData['isResolved'] = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 48), // Full-width button
                  ),
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        children: _severityOptions.map((severity) {
          final color = _severityColors[severity]!;
          return ChoiceChip(
            showCheckmark: false,
            label: Text(
              severity,
              style: TextStyle(color: color),
            ),
            selected: _selectedSeverity == severity,
            selectedColor: color.withOpacity(0.2),
            backgroundColor: Colors.white,
            shape: StadiumBorder(
              side: BorderSide(color: color),
            ),
            onSelected: (selected) {
              setState(() {
                _selectedSeverity = selected ? severity : null;
                _formData['severity'] = _selectedSeverity;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedInjuryType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an alert type.')),
        );
        return;
      }

      if (_selectedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a location.')),
        );
        return;
      }

      try {
        await DatabaseHelper().insertInjury({
          'injuryType': _formData['injuryType'],
          'location': _formData['location'],
          'description': _formData['description'],
          'injuredPerson': _formData['injuredPerson'],
          'isResolved': _formData['isResolved'] ? 1 : 0,
          'severity': _formData['severity'],
          'coordinates': _formData['coordinates'],
          'timestamp': _formData['timestamp'],
        });
        await PostgresHelper().insertInjury({
          'injuryType': _formData['injuryType'],
          'location': _formData['location'],
          'description': _formData['description'],
          'injuredPerson': _formData['injuredPerson'],
          'isResolved': _formData['isResolved'] ? 1 : 0,
          'severity': _formData['severity'],
          'coordinates': _formData['coordinates'],
          'timestamp': _formData['timestamp'],
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Injury successfully reported!')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit the Injury: $e')),
        );
      }
    }
  }
}
