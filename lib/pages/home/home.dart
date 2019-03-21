import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:tasty_tracks/models/track_bet_model.dart';
import 'package:tasty_tracks/models/track_watch_model.dart';
import 'package:tasty_tracks/pages/home/widgets/track_bets.dart';
import 'package:tasty_tracks/pages/home/widgets/track_watches.dart';
import 'package:tasty_tracks/pages/home/widgets/user_profile_widget.dart';
import 'package:tasty_tracks/widgets/error_message.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {
  static final String routeName = '/home';
  final String pageTitle = 'Home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isBusy;
  bool _hasError;
  TrackWatchModel _trackWatchModel;
  TrackBetModel _trackBetModel;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() async {
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
    Widget body;
    if (_hasError) {
      body = ErrorMessage(
        errorText: 'Failed to load your home page :(',
        onRetry: () => _loadData(),
      );
    } else if (_isBusy) {
      body = CircularProgressIndicator();
    } else {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 32.0),
          UserProfileWidget(),
          const SizedBox(height: 32.0),
          ScopedModel<TrackBetModel>(
            model: _trackBetModel,
            child: TrackBets(),
          ),
          const SizedBox(height: 32.0),
          ScopedModel<TrackWatchModel>(
            model: _trackWatchModel,
            child: TrackWatches(),
          ),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        child: body,
      ),
    );
  }
}
