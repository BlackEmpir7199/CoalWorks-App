import 'package:flutter/material.dart';
import 'database/database_helper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Account Settings'),
              _listTileCard(
                title: 'Profile',
                subtitle: 'Edit your profile information',
                icon: Icons.person,
                onTap: () {
                  // Navigate to Profile Edit Page
                },
              ),
              _listTileCard(
                title: 'Change Password',
                subtitle: 'Update your password',
                icon: Icons.lock,
                onTap: () {
                  // Navigate to Change Password Page
                },
              ),
              _sectionTitle('Notifications'),
              _toggleTile(
                title: 'Email Notifications',
                subtitle: 'Receive updates via email',
                value: true,
                onChanged: (bool value) {
        
                },
              ),
              _toggleTile(
                title: 'Push Notifications',
                subtitle: 'Receive push notifications',
                value: false,
                onChanged: (bool value) {
                  // Handle toggle change
                },
              ),
              _sectionTitle('Appearance'),
              _listTileCard(
                title: 'Theme',
                subtitle: 'Select Light or Dark mode',
                icon: Icons.palette,
                onTap: () {
                  // Navigate to Theme Selection Page
                },
              ),
              _sectionTitle('Privacy'),
              _listTileCard(
                title: 'Privacy Policy',
                subtitle: 'View our privacy policy',
                icon: Icons.privacy_tip,
                onTap: () {
                  // Navigate to Privacy Policy Page
                },
              ),
              _listTileCard(
                title: 'App Permissions',
                subtitle: 'Manage permissions',
                icon: Icons.security,
                onTap: () {
                  // Navigate to Permissions Page
                },
              ),
              _sectionTitle('Other'),
              _listTileCard(
                title: 'Help & Support',
                subtitle: 'Get help and support',
                icon: Icons.help,
                onTap: () {
                  // Navigate to Help & Support Page
                },
              ),
              _listTileCard(
                title: 'About',
                subtitle: 'Learn more about the app',
                icon: Icons.info,
                onTap: () {
                  // Navigate to About Page
                },
              ),
              _listTileCard(
                title: 'Delete db',
                subtitle: 'Delete database',
                icon: Icons.dataset,
                onTap: () {
                  _dbHelper.resetDatabase();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _listTileCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8.0), // Define rounded corners directly
    clipBehavior: Clip.hardEdge, // Clip the ripple within the boundaries
    child: InkWell(
      onTap: onTap,
      splashColor: Colors.grey.withOpacity(0.3),
      highlightColor: Colors.grey.withOpacity(0.1),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: Icon(icon, color: Colors.black),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 16.0,
          ),
          subtitleTextStyle: const TextStyle(
            fontSize: 12.0,
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
  }

  Widget _toggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      shadowColor: Colors.white,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: SwitchListTile(
        title: Text(title,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black,fontSize: 16.0),),
        subtitle: Text(subtitle,),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.black,
      ),
    );
  }
}
