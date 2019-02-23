import 'package:flutter/material.dart';

import 'package:tasty_tracks/pages/home/widgets/user_portfolio_summary.dart';
import 'package:tasty_tracks/pages/home/widgets/user_profile_summary.dart';

class HomePage extends StatefulWidget {
  static final String routeName = '/home';
  final String pageTitle = 'Home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserPortfolioSummary _portfolioSummary;
  UserProfileSummary _profileSummary;

  @override
  void initState() {
    super.initState();

    _portfolioSummary = UserPortfolioSummary();
    _profileSummary = UserProfileSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 16.0),
              _profileSummary,
              const Divider(height: 32.0),
              _portfolioSummary,
              const Divider(height: 32.0),
              Text('TODO Trends'),
            ],
          ),
        ),
      ),
    );
  }
}
