import 'package:dlivremappv2/home_screen.dart';
import 'package:dlivremappv2/orders_screen.dart';
import 'package:dlivremappv2/profile_screen.dart';
import 'package:dlivremappv2/search_screen.dart';
import 'package:flutter/material.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 3;

  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal[500],
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          color: Colors.teal[500],
        ),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        iconSize: 24,
        elevation: 5,
        backgroundColor: Colors.white,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        selectedIconTheme: IconThemeData(
          size: 28,
          color: Colors.teal[500],
        ),
        unselectedIconTheme: IconThemeData(
          size: 24,
          color: Colors.grey,
        ),
        mouseCursor: SystemMouseCursors.click,
        enableFeedback: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}