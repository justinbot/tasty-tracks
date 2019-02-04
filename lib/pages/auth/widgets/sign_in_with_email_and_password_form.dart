import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignInWithEmailAndPasswordForm extends StatefulWidget {
  @override
  SignInWithEmailAndPasswordFormState createState() {
    return SignInWithEmailAndPasswordFormState();
  }
}

class SignInWithEmailAndPasswordFormState
    extends State<SignInWithEmailAndPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  bool _busy = false;

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter an email';
                }
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              focusNode: _passwordFocusNode,
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a password';
                }
              },
            ),
            RaisedButton(
                onPressed: _busy ? null : _signInWithEmailAndPassword,
                child: Text('Sign in')),
          ],
        ));
  }

  _signInWithEmailAndPassword() async {
    bool valid = _formKey.currentState.validate();
    if (!valid) {
      return;
    }

    String email = _emailController.text;
    String password = _passwordController.text;

    setState(() {
      _busy = true;
    });
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      String errorMessage = "Couldn't log in.";
      if (e.code == 'ERROR_INVALID_EMAIL') {
        errorMessage = 'No account found with this email address.';
      } else if (e.code == 'ERROR_USER_NOT_FOUND') {
        errorMessage = 'No account found with this email address.';
      } else if (e.code == 'ERROR_USER_DISABLED') {
        errorMessage = 'This account has been disabled by an administrator.';
      } else if (e.code == 'ERROR_WRONG_PASSWORD') {
        errorMessage = 'Incorrect password.';
      } else {
        // TODO Log to error reporting
      }

      Scaffold.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }).whenComplete(() {
      setState(() {
        _busy = false;
      });
    });
  }
}
