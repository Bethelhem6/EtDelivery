import 'package:dboy_two/pages/orders/Delivered.dart';
import 'package:dboy_two/pages/orders/allPendingOrders.dart';
// import 'package:dboy_two/pages/notification.dart';
import 'package:dboy_two/pages/settings/settings.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  final screens = [
    const PendingOrdersPage(),
    const DeliveredPage(),
    const SettingsPage(),
  ];
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to Exit?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          
          index: currentIndex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 82, 131, 84),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: currentIndex,
          unselectedItemColor: Colors.white,
          selectedItemColor: const Color.fromARGB(255, 245, 231, 181),
          onTap: (index) => setState(() {
            currentIndex = index;
          }),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.today_outlined),
              label: 'Home',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fire_truck_rounded),
              label: 'Delivered',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Settings',
              backgroundColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
