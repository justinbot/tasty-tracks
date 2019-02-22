import 'package:flutter/material.dart';

import 'package:tasty_tracks/pages/home.dart';
import 'package:tasty_tracks/pages/search/search.dart';
import 'package:tasty_tracks/pages/settings.dart';

class NavigationPage extends StatefulWidget {
  static final String routeName = '/nav';
  final String pageTitle = 'Home';

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;
  final _pages = <Widget>[
    HomePage(),
    SearchPage(),
    SettingsPage(),
  ];

  final _items = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: Icon(Icons.home), title: Text('Home')
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.search), title: Text('Search')
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.settings), title: Text('Settings')
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _currentPage() {
    return _pages[_selectedIndex];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
