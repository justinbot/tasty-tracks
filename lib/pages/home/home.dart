import 'package:flutter/material.dart';

import 'package:tasty_tracks/pages/home/widgets/user_profile_widget.dart';
import 'package:tasty_tracks/pages/home/widgets/trends_widget.dart';

class HomePage extends StatefulWidget {
  static final String routeName = '/home';
  final String pageTitle = 'Home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserProfileSummary _profileSummary;
  UserTrendsSummary _userTrendsSummary;

  @override
  void initState() {
    super.initState();

    _profileSummary = UserProfileSummary();
    _userTrendsSummary = UserTrendsSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 32.0),
              _profileSummary,
              const SizedBox(height: 32.0),
              _userTrendsSummary,
            ],
          ),
        ),
      ),
    );
  }
}
