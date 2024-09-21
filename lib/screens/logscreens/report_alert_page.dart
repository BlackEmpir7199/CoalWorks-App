import 'package:coalworks/database/database_helper.dart';
import 'package:coalworks/database/postgres_helper.dart';  // Import PostgresHelper
import 'package:coalworks/widgets/logscreen/custom_switch.dart';
import 'package:coalworks/widgets/logscreen/custom_text_field.dart';
import 'package:coalworks/widgets/logscreen/date_picker.dart';
import 'package:coalworks/widgets/logscreen/location_display.dart';
import 'package:coalworks/widgets/logscreen/sleek_dropdown.dart';
import 'package:coalworks/widgets/logscreen/sleek_slider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ReportAlertPage extends StatefulWidget {
  const ReportAlertPage({super.key});

  @override
  State<ReportAlertPage> createState() => _ReportAlertPageState();
}

class _ReportAlertPageState extends State<ReportAlertPage> {
  final TextEditingController _dateTimeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'alertType': '',
    'location': '',
    'description': '',
    'isResolved': false,
    'urgencyLevel': 5.0,
    'coordinates': '',
    'timestamp': DateTime.now().toIso8601String(),
  };

  String? _selectedAlertType;
  String? _selectedLocation;
  Position? _currentPosition;

  final List<String> _alertTypes = [
    'Gas Leak',
    'Fire',
    'Equipment Malfunction',
    'Unauthorized Entry'
  ];
  final List<String> _locations = [
    'Section A',
    'Section B',
    'Zone 1',
    'Zone 2',
    'Zone 3'
  ];
  final List<Icon> _alertIcons = [
    Icon(Icons.gas_meter),
    Icon(Icons.local_fire_department),
    Icon(Icons.construction),
    Icon(Icons.block)
  ];

  @override
  void dispose() {
    _dateTimeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location permissions are permanently denied.')),
      );
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        _formData['coordinates'] =
            '${position.latitude}, ${position.longitude}';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get current location: $e')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedAlertType == null) {
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
        // Save to SQLite
        await DatabaseHelper().insertAlert({
          'alertType': _formData['alertType'],
          'location': _formData['location'],
          'description': _formData['description'],
          'isResolved': _formData['isResolved'] ? 1 : 0,
          'urgencyLevel': _formData['urgencyLevel'],
          'coordinates': _formData['coordinates'],
          'timestamp': _formData['timestamp'],
        });

        await PostgresHelper().insertAlert({
          'alertType': _formData['alertType'],
          'location': _formData['location'],
          'description': _formData['description'],
          'isResolved': _formData['isResolved'] ? 1:0,
          'urgencyLevel': _formData['urgencyLevel'],
          'coordinates': _formData['coordinates'],
          'timestamp': _formData['timestamp'],
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alert successfully reported!')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit the alert: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Report an Alert',
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
                  label: 'Alert Type',
                  hint: 'Select Alert Type',
                  items: _alertTypes,
                  selectedValue: _selectedAlertType,
                  iconsEach: _alertIcons,
                  onChanged: (value) => setState(() {
                    _selectedAlertType = value;
                    _formData['alertType'] = value!;
                  }),
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
                        },
                      ),
                    ),
                  ],
                ),
                LocationDisplay(
                  currentPosition: _currentPosition,
                  onRefresh: _getCurrentLocation,
                ),
                CustomTextField(
                  label: 'Description',
                  placeholder: 'Describe the incident in detail...',
                  maxLines: 3,
                  validator: (value) => value!.isEmpty
                      ? 'Please provide a detailed description'
                      : null,
                  onSaved: (value) => _formData['description'] = value!,
                ),
                SleekSlider(
                  label: 'Urgency Level',
                  value: _formData['urgencyLevel'],
                  onChanged: (value) {
                    setState(() {
                      _formData['urgencyLevel'] = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                CustomSwitch(
                  label: 'Issue Resolved',
                  color: Colors.green,
                  value: _formData['isResolved'],
                  onChanged: (value) {
                    setState(() {
                      _formData['isResolved'] = value;
                    });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
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
}
