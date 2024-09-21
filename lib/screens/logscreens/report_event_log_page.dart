import 'package:coalworks/database/database_helper.dart';
import 'package:coalworks/database/postgres_helper.dart';
import 'package:flutter/material.dart';
import 'package:coalworks/widgets/logscreen/custom_switch.dart';
import 'package:coalworks/widgets/logscreen/custom_text_field.dart';
import 'package:coalworks/widgets/logscreen/date_picker.dart';
import 'package:coalworks/widgets/logscreen/location_display.dart';
import 'package:coalworks/widgets/logscreen/sleek_dropdown.dart';
import 'package:geolocator/geolocator.dart';

class LogShiftEventPage extends StatefulWidget {
  const LogShiftEventPage({super.key});

  @override
  _LogShiftEventPageState createState() => _LogShiftEventPageState();
}

class _LogShiftEventPageState extends State<LogShiftEventPage> {
  final TextEditingController _dateTimeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<String> _locations = [
    'Section A',
    'Section B',
    'Zone 1',
    'Zone 2',
    'Zone 3'
  ];
  final Map<String, dynamic> _formData = {
    'eventType': '',
    'description': '',
    'location': '',
    'timestamp': DateTime.now().toIso8601String(),
    'isResolved': false,
    'coordinates': '',
  };

  String? _selectedEventType;
  Position? _currentPosition;
  String? _selectedLocation;
  final List<String> _eventTypes = ['Shift Change', 'Maintenance', 'Breakdown'];
  final List<Icon> _eventIcons = [
    Icon(Icons.grain),
    Icon(Icons.local_hospital),
    Icon(Icons.cut)
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
          'Log a Shift Event',
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
                  label: 'Event Type',
                  hint: 'Select Event Type',
                  items: _eventTypes,
                  selectedValue: _selectedEventType,
                  iconsEach: _eventIcons,
                  onChanged: (value) => setState(() {
                    _selectedEventType = value;
                    _formData['eventType'] = value!;
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
                          }),
                    ),
                  ],
                ),
                LocationDisplay(
                  currentPosition: _currentPosition,
                  onRefresh: _getCurrentLocation,
                ),
                CustomTextField(
                  label: 'Description',
                  placeholder:
                      'Provide detailed information about the event...',
                  maxLines: 3,
                  validator: (value) =>
                      value!.isEmpty ? 'Please provide event details' : null,
                  onSaved: (value) => _formData['description'] = value!,
                ),
                CustomSwitch(
                  label: 'Event Resolved',
                  color: Colors.green,
                  value: _formData['isResolved'] ?? false,
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedEventType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an event type.')),
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
        await DatabaseHelper().insertEvent({
          'eventType': _formData['eventType'],
          'location': _formData['location'],
          'description': _formData['description'],
          'isResolved': _formData['isResolved'] ? 1 : 0,
          'coordinates': _formData['coordinates'],
          'timestamp': _formData['timestamp'],
        });
        await PostgresHelper().insertEvent({
          'eventType': _formData['eventType'],
          'location': _formData['location'],
          'description': _formData['description'],
          'isResolved': _formData['isResolved'] ? 1 : 0,
          'coordinates': _formData['coordinates'],
          'timestamp': _formData['timestamp'],
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event successfully reported!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit the Event: $e')),
        );
      }
    }
  }
}
