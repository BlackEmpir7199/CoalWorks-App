import 'package:coalworks/home_page.dart';
import 'package:coalworks/handover_tasks_page.dart';
import 'package:coalworks/settings_page.dart';
import 'package:coalworks/shift_logs_page.dart';
import 'package:coalworks/smp_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:geolocator/geolocator.dart';
void main() {
  runApp(CoalWorksApp());
}

class CoalWorksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoalWorks',
      theme: ThemeData(
        primaryColor: Colors.black,
        focusColor: Colors.black, 
        hoverColor: Colors.black,
        indicatorColor: Colors.black,
        colorScheme: ColorScheme(brightness: Brightness.light, primary: Colors.black, onPrimary: Colors.white, secondary: Colors.white, onSecondary: Colors.black, error: Colors.red, onError: Colors.red, surface: Colors.white, onSurface: Colors.black),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme:const AppBarTheme(
              backgroundColor: Colors.white, foregroundColor: Colors.black),
          dialogBackgroundColor: Colors.black,
          bottomNavigationBarTheme:const BottomNavigationBarThemeData(
            type: BottomNavigationBarType.shifting,
            selectedItemColor: Colors.redAccent,
            elevation: 0,
            unselectedItemColor: Colors.grey,
          )),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    HandOverPage(),
    ShiftLogs(),
    SmpPage(),
    //NotifactionsPage(),
    //SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsPage()));
          }, icon: const Icon(Icons.settings))
        ],
        title: const Row(
          children: [
            Text(
              'CoalWorks',
              style: TextStyle(
                  fontWeight: FontWeight.w900, fontFamily: 'Times New Roman'),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar:Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1.0,color:Colors.black)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
          child: GNav(
            padding: EdgeInsets.all(10.0),
            color: Colors.grey,
            tabMargin: EdgeInsets.all(5.0),
            gap: 8,
            activeColor: Colors.black,
            tabActiveBorder: Border.all(width: 1,color: Colors.black),
            backgroundColor: Colors.white,
            haptic: true,
            style: GnavStyle.google,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.engineering,
                text: 'Handover',
              ),
              GButton(
                icon: Icons.assignment,
                text: 'Logs',
              ),
              GButton(
                icon: Icons.security,
                text: 'SMP',
              ),
          
            ],
            selectedIndex: _selectedIndex,
            onTabChange: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

Future<Position?> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null; // Location services are not enabled
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null; // Permissions are denied
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return null; // Permissions are denied forever
  }

  try {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  } catch (e) {
    // Handle any location retrieval errors here
    return null;
  }
}