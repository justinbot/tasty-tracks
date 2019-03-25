import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:tasty_tracks/models/track_bet_model.dart';
import 'package:tasty_tracks/models/track_watch_model.dart';
import 'package:tasty_tracks/pages/portfolio/widgets/track_bets.dart';
import 'package:tasty_tracks/pages/portfolio/widgets/track_watches.dart';
import 'package:tasty_tracks/pages/home/widgets/user_profile.dart';
import 'package:tasty_tracks/widgets/error_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class PortfolioPage extends StatefulWidget {
  static final String routeName = '/home';
  final String pageTitle = 'Home';

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  bool _isBusy;
  bool _hasError;
  TrackWatchModel _trackWatchModel;
  TrackBetModel _trackBetModel;

  @override
  initState() {
    super.initState();

    _loadData();
  }

  _loadData() async {
    setState(() {
      _isBusy = true;
      _hasError = false;
    });

    TrackWatchModel trackWatchModel;
    TrackBetModel trackBetModel;
    try {
      FirebaseUser user = await _auth.currentUser();
      trackWatchModel = TrackWatchModel(user: user);
      trackBetModel = TrackBetModel(user: user);
    } catch (e) {
      // TODO Log to error reporting
      setState(() {
        _hasError = true;
      });
    }

    setState(() {
      _isBusy = false;
      _trackWatchModel = trackWatchModel;
      _trackBetModel = trackBetModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Widget body;
    if (_hasError) {
      body = ErrorPage(
        errorText: 'Failed to load your home page :(',
        onRetry: () => _loadData(),
      );
    } else if (_isBusy) {
      body = CircularProgressIndicator();
    } else {
      body = TabBarView(
        children: [
          ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ScopedModel<TrackBetModel>(
                    model: _trackBetModel,
                    child: TrackBets(),
                  ),
                ],
              ),
            ],
          ),
          ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ScopedModel<TrackWatchModel>(
                    model: _trackWatchModel,
                    child: TrackWatches(),
                  ),
                ],
              ),
            ],
          ),
          Text('History'),
        ],
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '999,999.99',
            style: theme.textTheme.headline.copyWith(color: theme.accentColor),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(FeatherIcons.moreVertical),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Bets',
              ),
              Tab(
                text: 'Watching',
              ),
              Tab(
                text: 'History',
              ),
            ],
          ),
        ),
        body: body,
      ),
    );
  }
}
