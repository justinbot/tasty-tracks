import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tasty_tracks/pages/auth/landing.dart';
import 'package:tasty_tracks/pages/auth/sign_up.dart';
import 'package:tasty_tracks/pages/auth/widgets/sign_in_anonymously_form.dart';
import 'package:tasty_tracks/pages/auth/widgets/sign_in_with_email_and_password_form.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignInPage extends StatefulWidget {
  static final String routeName = '/sign-in';
  final String pageTitle = 'Sign In';

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
              Spacer(),
              Text('Tasty Tracks'),
              Spacer(),
              SignInWithEmailAndPasswordForm(),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(SignUpPage.routeName);
                  },
                  child: Text('Create an account')),
              Divider(),
              SignInAnonymouslyForm(),
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
