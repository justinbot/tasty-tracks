import 'package:flutter/material.dart';

import 'package:tasty_tracks/pages/auth/landing.dart';
import 'package:tasty_tracks/pages/auth/sign_in.dart';
import 'package:tasty_tracks/pages/auth/sign_up.dart';
import 'package:tasty_tracks/pages/home/home.dart';

class TastyTracksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasty Tracks',
      routes: {
        LandingPage.routeName: (BuildContext context) => LandingPage(),
        SignInPage.routeName: (BuildContext context) => SignInPage(),
        SignUpPage.routeName: (BuildContext context) => SignUpPage(),
        HomePage.routeName: (BuildContext context) => HomePage(),
      },
      onUnknownRoute: _onUnknownRoute,
    );
  }
}

Route<dynamic> _onUnknownRoute(RouteSettings settings) {
  // TODO Log unknown route to error reporting
  // Navigate to sign in page
  return MaterialPageRoute<void>(
    settings: settings,
    builder: (BuildContext context) => SignInPage(),
    fullscreenDialog: true,
  );
}
