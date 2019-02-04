import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class CreateUserWithEmailAndPasswordForm extends StatefulWidget {
  @override
  CreateUserWithEmailAndPasswordFormState createState() {
    return CreateUserWithEmailAndPasswordFormState();
  }
}

class CreateUserWithEmailAndPasswordFormState
    extends State<CreateUserWithEmailAndPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
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
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a password';
                }
              },
            ),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm password',
              ),
              focusNode: _confirmPasswordFocusNode,
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please confirm your password';
                } else if (value != _passwordController.text) {
                  return "Passwords don't match";
                }
              },
            ),
            RaisedButton(
                onPressed: _busy ? null : _createUserWithEmailAndPassword,
                child: Text('Sign up')),
          ],
        ));
  }

  _createUserWithEmailAndPassword() async {
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
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      String errorMessage = "Couldn't sign up. Please try again.";
      if (e.code == 'ERROR_INVALID_EMAIL') {
        errorMessage = 'This email address is invalid.';
      } else if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        errorMessage = 'An account with this email already exists.';
      } else if (e.code == 'ERROR_WEAK_PASSWORD') {
        errorMessage =
            'This password is too weak, please choose a stronger password.';
      }

      Scaffold.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }).whenComplete(() {
      setState(() {
        _busy = false;
      });
    });
  }
}
