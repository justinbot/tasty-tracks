import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';

import 'package:tasty_tracks/pages/home/home.dart';
import 'package:tasty_tracks/pages/portfolio/portfolio.dart';
import 'package:tasty_tracks/pages/search/search.dart';
import 'package:tasty_tracks/pages/settings/settings.dart';

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
    PortfolioPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final _items = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        activeIcon: Icon(
          FeatherIcons.home,
          color: theme.accentColor,
        ),
        icon: Icon(FeatherIcons.home),
        title: Text('Home'),
      ),
      BottomNavigationBarItem(
        activeIcon: Icon(
          FeatherIcons.search,
          color: theme.accentColor,
        ),
        icon: Icon(FeatherIcons.search),
        title: Text('Search'),
      ),
      BottomNavigationBarItem(
        activeIcon: Icon(
          FeatherIcons.briefcase,
          color: theme.accentColor,
        ),
        icon: Icon(FeatherIcons.briefcase),
        title: Text('Portfolio'),
      ),
      BottomNavigationBarItem(
        activeIcon: Icon(
          FeatherIcons.settings,
          color: theme.accentColor,
        ),
        icon: Icon(FeatherIcons.settings),
        title: Text('Settings'),
      ),
    ];

    return Scaffold(
      body: _currentPage(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
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
