import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tasty_tracks/pages/auth/landing.dart';

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
    _auth.onAuthStateChanged.firstWhere((user) => user != null).then((user) =>
        Navigator.of(context).pushReplacementNamed(LandingPage.routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            // TODO Add logo
            Text('Tasty Tracks'),
            Spacer(),
            SignInAnonymouslyForm(),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class SignInAnonymouslyForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignInAnonymouslyFormState();
  }
}

class SignInAnonymouslyFormState extends State<SignInAnonymouslyForm> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
              onPressed: _signInAnonymously,
              child: Text('Sign in anonymously')),
        ]);
  }

  _signInAnonymously() {
    setState(() {
      _busy = true;
    });
    _auth.signInAnonymously().catchError((e) {
      // TODO Display errors see: https://github.com/flutter/plugins/pull/775
      String errorMessage = "Couldn't log in.";
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }).whenComplete(() => setState(() => _busy = false));
  }
}
