import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tasty_tracks/models/user_profile_model.dart';
import 'package:tasty_tracks/pages/auth/sign_in.dart';
import 'package:tasty_tracks/pages/navigation.dart';
import 'package:tasty_tracks/pages/user_profile/onboard.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LandingPage extends StatefulWidget {
  static final String routeName = '/';

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  var _onAuthStateChangedSubscription;

  @override
  void initState() {
    super.initState();

    // Check login status and navigate
    _onAuthStateChangedSubscription = _auth.onAuthStateChanged.listen((user) {
      if (user != null) {
        // Already logged in
        UserProfileModel userProfileModel = UserProfileModel(user: user);
        userProfileModel.get().then((userProfile) {
          if (userProfile == null) {
            // Take to on-boarding if no user profile
            Navigator.of(context).pushReplacementNamed(OnboardPage.routeName);
          } else {
            Navigator.of(context)
                .pushReplacementNamed(NavigationPage.routeName);
          }
        });
      } else {
        // Not logged in
        Navigator.of(context).pushReplacementNamed(SignInPage.routeName);
      }
    });
  }

  @override
  void dispose() {
    _onAuthStateChangedSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.canvasColor,
      body: Container(
        child: Center(
          child: Hero(
            tag: 'logoHero',
            child: Image.asset(
              'assets/tasty_tracks_logo_outline_1200.png',
              color: theme.accentColor,
              width: 256.0,
            ),
          ),
        ),
      ),
    );
  }
}
