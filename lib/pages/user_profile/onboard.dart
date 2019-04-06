import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tasty_tracks/models/user_profile_model.dart';
import 'package:tasty_tracks/pages/auth/landing.dart';
import 'package:tasty_tracks/pages/user_profile/widgets/create_user_profile_form.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class OnboardPage extends StatefulWidget {
  static final String routeName = '/onboard';

  @override
  _OnboardPageState createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  @override
  void initState() {
    super.initState();

    // Navigate once profile is created
    _auth.currentUser().then((user) {
      UserProfileModel(user: user)
          .snapshots()
          .firstWhere((querySnapshot) => querySnapshot.documents.isNotEmpty)
          .then((querySnapshot) {
        Navigator.of(context).pushReplacementNamed(LandingPage.routeName);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logoHero',
                child: Image.asset(
                  'assets/tasty_tracks_logo_outline_1200.png',
                  color: theme.accentColor,
                  width: 256.0,
                ),
              ),
              const SizedBox(height: 64.0),
              Text(
                "Let's set up your profile...",
                style: theme.textTheme.title,
              ),
              const SizedBox(height: 16.0),
              CreateUserProfileForm(),
            ],
          ),
        ),
      ),
    );
  }
}
