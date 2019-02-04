import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

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
              onPressed: _busy ? null : _signInAnonymously,
              child: Text('Sign in anonymously')),
        ]);
  }

  _signInAnonymously() async {
    setState(() {
      _busy = true;
    });
    _auth.signInAnonymously().catchError((e) {
      String errorMessage = "Couldn't log in.";
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }).whenComplete(() {
      setState(() {
        _busy = false;
      });
    });
  }
}
