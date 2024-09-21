import 'package:coalworks/database/database_helper.dart';
import 'package:coalworks/database/postgres_helper.dart';
import 'package:coalworks/widgets/logscreen/custom_switch.dart';
import 'package:coalworks/widgets/logscreen/custom_text_field.dart';
import 'package:coalworks/widgets/logscreen/date_picker.dart';
import 'package:coalworks/widgets/logscreen/location_display.dart';
import 'package:coalworks/widgets/logscreen/sleek_dropdown.dart';
import 'package:coalworks/widgets/logscreen/sleek_slider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ReportEquipmentIssuePage extends StatefulWidget {
  const ReportEquipmentIssuePage({super.key});

  @override
  _ReportEquipmentIssuePageState createState() =>
      _ReportEquipmentIssuePageState();
}

class _ReportEquipmentIssuePageState extends State<ReportEquipmentIssuePage> {
  final TextEditingController _dateTimeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'equipmentName': '',
    'issueType': '',
    'location': '',
    'urgencyLevel': 5.0,
    'timestamp': DateTime.now().toIso8601String(),
    'coordinates': '',
    'description': '',
    'isResolved': false,
  };

  String? _selectedEquipment;
  String? _selectedIssueType;
  String? _selectedLocation;
  Position? _currentPosition;

  final List<String> _equipmentList = [
    'Conveyor Belt',
    'Drill Machine',
    'Loader',
    'Crusher'
  ];
  final List<String> _issueTypes = [
    'Mechanical',
    'Electrical',
    'Hydraulic',
    'Software'
  ];
  final List<String> _locations = [
    'Section A',
    'Section B',
    'Zone 1',
    'Zone 2',
    'Zone 3'
  ];

  final List<Icon> _equipmentIcons = [
    Icon(Icons.build),
    Icon(Icons.precision_manufacturing),
    Icon(Icons.agriculture),
    Icon(Icons.construction),
  ];

  final List<Icon> _issueTypeIcons = [
    Icon(Icons.settings),
    Icon(Icons.electrical_services),
    Icon(Icons.opacity),
    Icon(Icons.computer),
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
      return; // Location services are not enabled
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return; // Permissions are denied
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return; // Permissions are denied forever
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      _formData['coordinates'] = '${position.latitude}, ${position.longitude}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Report an Equipment Issue',
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
                  label: 'Equipment Name',
                  hint: 'Select Equipment',
                  items: _equipmentList,
                  selectedValue: _selectedEquipment,
                  iconsEach: _equipmentIcons,
                  onChanged: (value) => setState(() {
                    _selectedEquipment = value;
                    _formData['equipmentName'] = value!;
                  }),
                ),
                SleekDropdown(
                  label: 'Issue Type',
                  hint: 'Select Issue Type',
                  items: _issueTypes,
                  selectedValue: _selectedIssueType,
                  iconsEach: _issueTypeIcons,
                  onChanged: (value) => setState(() {
                    _selectedIssueType = value;
                    _formData['issueType'] = value!;
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
                      label: 'Time of Issue',
                      hint: 'Select Time',
                      onDateSelected: (date) {
                        setState(() {
                          _formData['timestamp'] = date.toIso8601String();
                        });
                      },
                    )),
                  ],
                ),
                LocationDisplay(
                  currentPosition: _currentPosition,
                  onRefresh: _getCurrentLocation,
                ),
                CustomTextField(
                  validator: (value) => value!.isEmpty
                      ? 'Please provide a detailed description'
                      : null,
                  label: 'Description',
                  placeholder: 'Describe the issue in detail...',
                  maxLines: 3,
                  onSaved: (value) => _formData['description'] = value!,
                ),
                SizedBox(height: 20),
                SleekSlider(
                    label: 'Urgency Level',
                    value: _formData['urgencyLevel'],
                    onChanged: (value) {
                      setState(() {
                        _formData['urgencyLevel'] = value;
                      });
                    }),
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedIssueType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an Issue type.')),
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
        await DatabaseHelper().insertIssue({
          'equipmentName': _formData['equipmentName'],
          'issueType': _formData['issueType'],
          'location': _formData['location'],
          'description': _formData['description'],
          'isResolved': _formData['isResolved'] ? 1 : 0,
          'urgencyLevel': _formData['urgencyLevel'],
          'coordinates': _formData['coordinates'],
          'timestamp': _formData['timestamp'],
        });
        await PostgresHelper().insertIssue({
          'equipmentName': _formData['equipmentName'],
          'issueType': _formData['issueType'],
          'location': _formData['location'],
          'description': _formData['description'],
          'isResolved': _formData['isResolved'] ? 1 : 0,
          'urgencyLevel': _formData['urgencyLevel'],
          'coordinates': _formData['coordinates'],
          'timestamp': _formData['timestamp'],
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Issue successfully reported!')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit the Issues: $e')),
        );
      }
    }
  }
}
