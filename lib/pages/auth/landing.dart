import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tasty_tracks/pages/auth/sign_in.dart';
import 'package:tasty_tracks/pages/home/home.dart';

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
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
