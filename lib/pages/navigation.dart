import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';

import 'package:tasty_tracks/pages/leaderboard/leaderboard.dart';
import 'package:tasty_tracks/pages/portfolio/portfolio.dart';
import 'package:tasty_tracks/pages/search/search.dart';

class NavigationPage extends StatefulWidget {
  static final String routeName = '/nav';

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;
  final _pages = <Widget>[
    PortfolioPage(),
    SearchPage(),
    LeaderboardPage(),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final _items = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(FeatherIcons.briefcase),
        title: Text('Portfolio'),
      ),
      BottomNavigationBarItem(
        icon: Icon(FeatherIcons.search),
        title: Text('Search'),
      ),
      BottomNavigationBarItem(
        icon: Icon(FeatherIcons.award),
        title: Text('Leaderboard'),
      ),
    ];

    return Scaffold(
      body: _currentPage(),
      bottomNavigationBar: Theme(
        data: theme.copyWith(canvasColor: theme.primaryColor),
        child: BottomNavigationBar(
          items: _items,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
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
