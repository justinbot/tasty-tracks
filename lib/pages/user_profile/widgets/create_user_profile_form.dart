import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:tasty_tracks/models/user_profile_model.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class CreateUserProfileForm extends StatefulWidget {
  @override
  CreateUserProfileFormState createState() {
    return CreateUserProfileFormState();
  }
}

class CreateUserProfileFormState
    extends State<CreateUserProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
              keyboardType: TextInputType.text,
              maxLines: 1,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a username';
                }
              },
            ),
            const SizedBox(height: 16.0),
            RaisedButton(
                onPressed: _busy ? null : _createUserProfile,
                child: Text('Save')),
          ],
        ));
  }

  _createUserProfile() async {
    bool valid = _formKey.currentState.validate();
    if (!valid) {
      return;
    }

    String username = _usernameController.text;
    setState(() {
      _busy = true;
    });

    FirebaseUser user = await _auth.currentUser();

    UserProfileModel userProfileModel = UserProfileModel(user: user);

    DocumentReference userProfile = await userProfileModel.create(username);

    setState(() {
      _busy = false;
    });

    if (userProfile == null) {
      String errorMessage = 'Failed to create profile';
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }
}