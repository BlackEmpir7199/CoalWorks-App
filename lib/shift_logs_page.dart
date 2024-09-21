import 'package:coalworks/database/database_helper.dart';
import 'package:coalworks/screens/logscreens/report_alert_page.dart';
import 'package:coalworks/screens/logscreens/report_equipment_issue_page.dart';
import 'package:coalworks/screens/logscreens/report_event_log_page.dart';
import 'package:coalworks/screens/logscreens/report_injury_page.dart';
import 'package:flutter/material.dart';

class ShiftLogs extends StatefulWidget {
  const ShiftLogs({super.key});

  @override
  _ShiftLogsState createState() => _ShiftLogsState();
}

class _ShiftLogsState extends State<ShiftLogs> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Use a ValueNotifier to manage the state of the data
  ValueNotifier<List<Map<String, dynamic>>> alertLogs = ValueNotifier([]);
  ValueNotifier<List<Map<String, dynamic>>> injuryLogs = ValueNotifier([]);
  ValueNotifier<List<Map<String, dynamic>>> issueLogs = ValueNotifier([]);
  ValueNotifier<List<Map<String, dynamic>>> eventLogs = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    alertLogs.dispose();
    injuryLogs.dispose();
    issueLogs.dispose();
    eventLogs.dispose();
    super.dispose();
  }

  void _fetchData() async {
    // Fetch data from the database and update the ValueNotifiers
    alertLogs.value = await _dbHelper.queryAllRows('alerts');
    injuryLogs.value = await _dbHelper.queryAllRows('injuries');
    issueLogs.value = await _dbHelper.queryAllRows('issues');
    eventLogs.value = await _dbHelper.queryAllRows('events');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shift Handover Log',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Alert'),
            Tab(text: 'Injury'),
            Tab(text: 'Issue'),
            Tab(text: 'Event'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildTabContent(alertLogs, 'alerts'),
            _buildTabContent(injuryLogs, 'injurys'),
            _buildTabContent(issueLogs, 'issues'),
            _buildTabContent(eventLogs, 'events'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: () {
          _showBottomSheet(context);
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTabContent(ValueNotifier<List<Map<String, dynamic>>> logs, String type) {
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: logs,
      builder: (context, items, _) {
        if (items.isEmpty) {
          return Center(
            child: Text(
              'No $type logs available.',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              title: Text(
                item[type.substring(0, type.length - 1) + 'Type'] ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                item['description'] ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
              leading: Icon(
                item['isResolved'] == 1 ? Icons.check_circle : Icons.dangerous,
                color: item['isResolved'] == 1 ? Colors.green : Colors.red,
              ),
              onTap: () {
                // Handle item tap
              },
            );
          },
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Options',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.keyboard_arrow_down_outlined, size: 30.0),
                  ),
                ],
              ),
              _bottomSheetButton(
                context: context,
                title: 'Report an Alert',
                icon: Icons.warning_amber_rounded,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ReportAlertPage()))
                    .then((_) => _fetchData()); // Refresh data after returning
                },
                iconcolor: Colors.red,
              ),
              _bottomSheetButton(
                context: context,
                title: 'Report an Injury',
                icon: Icons.local_hospital,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ReportInjuryPage()))
                    .then((_) => _fetchData()); // Refresh data after returning
                },
                iconcolor: Colors.orange,
              ),
              _bottomSheetButton(
                context: context,
                title: 'Report an Equipment Issue',
                icon: Icons.build_circle,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ReportEquipmentIssuePage()))
                    .then((_) => _fetchData()); // Refresh data after returning
                },
                iconcolor: Colors.blue,
              ),
              _bottomSheetButton(
                context: context,
                title: 'Log a Shift Event',
                icon: Icons.event_note,
                onTap: () {
                  Navigator.pop(context);          
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LogShiftEventPage()))
                    .then((_) => _fetchData()); // Refresh data after returning
                },
                iconcolor: Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bottomSheetButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required Color iconcolor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.black.withOpacity(0.1),
          highlightColor: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Icon(icon, color: iconcolor),
                const SizedBox(width: 16.0),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
