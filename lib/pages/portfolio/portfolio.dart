import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:tasty_tracks/models/track_bet_model.dart';
import 'package:tasty_tracks/models/track_watch_model.dart';
import 'package:tasty_tracks/models/user_profile_model.dart';
import 'package:tasty_tracks/pages/portfolio/widgets/portfolio_app_bar.dart';
import 'package:tasty_tracks/pages/portfolio/widgets/track_bets.dart';
import 'package:tasty_tracks/pages/portfolio/widgets/track_watches.dart';
import 'package:tasty_tracks/pages/portfolio/widgets/transaction_history.dart';
import 'package:tasty_tracks/widgets/error_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class PortfolioPage extends StatefulWidget {
  static final String routeName = '/home';

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  bool _isBusy;
  bool _hasError;
  TrackWatchModel _trackWatchModel;
  TrackBetModel _trackBetModel;
  UserProfileModel _userProfileModel;

  @override
  initState() {
    super.initState();

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return ErrorPage(
        errorText: 'Failed to load your portfolio :(',
        onRetry: () => _loadData(),
      );
    } else if (_isBusy) {
      return Scaffold(
        appBar: AppBar(),
        body: CircularProgressIndicator(),
      );
    } else {
      return DefaultTabController(
        length: 3,
        child: ScopedModel<UserProfileModel>(
          model: _userProfileModel,
          child: Scaffold(
            appBar: PortfolioAppBar(),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                ScopedModel<TrackBetModel>(
                  model: _trackBetModel,
                  child: TrackBets(),
                ),
                ScopedModel<TrackWatchModel>(
                  model: _trackWatchModel,
                  child: TrackWatches(),
                ),
                TransactionHistory(),
              ],
            ),
          ),
        ),
      );
    }
  }

  _loadData() async {
    setState(() {
      _isBusy = true;
      _hasError = false;
    });

    TrackWatchModel trackWatchModel;
    TrackBetModel trackBetModel;
    UserProfileModel userProfileModel;
    try {
      FirebaseUser user = await _auth.currentUser();
      trackWatchModel = TrackWatchModel(user: user);
      trackBetModel = TrackBetModel(user: user);
      userProfileModel = UserProfileModel(user: user);
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
      _userProfileModel = userProfileModel;
    });
  }
}
