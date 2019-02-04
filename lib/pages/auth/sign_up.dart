import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tasty_tracks/pages/auth/landing.dart';
import 'package:tasty_tracks/pages/auth/widgets/create_user_with_email_and_password_form.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUpPage extends StatefulWidget {
  static final String routeName = '/sign-up';
  final String pageTitle = 'Sign up';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  void initState() {
    super.initState();

    // Navigate once signed in
    _auth.onAuthStateChanged.firstWhere((user) => user != null).then((user) {
      Navigator.of(context).pushReplacementNamed(LandingPage.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Tasty Tracks'),
              CreateUserWithEmailAndPasswordForm(),
            ],
          ),
        ),
      ),
    );
  }
}
