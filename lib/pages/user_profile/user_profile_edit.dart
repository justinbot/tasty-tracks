import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tasty_tracks/models/user_profile_model.dart';
import 'package:tasty_tracks/pages/auth/landing.dart';
import 'package:tasty_tracks/pages/user_profile/widgets/create_user_profile_form.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class UserProfileEditPage extends StatefulWidget {
  static final String routeName = '/user-profile/edit';

  @override
  _UserProfileEditPageState createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends State<UserProfileEditPage> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit profile'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
          child: Column(
            children: [
              CreateUserProfileForm(),
            ],
          ),
        ),
      ),
    );
  }
}
