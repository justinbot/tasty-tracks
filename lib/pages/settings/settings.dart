import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tasty_tracks/pages/auth/landing.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SettingsPage extends StatefulWidget {
  static final String routeName = '/settings';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _appName = '';
  String _version = '';

  @override
  initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _appName = packageInfo.appName;
        _version = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                onPressed: _signOutUser,
                child: Text('Sign out'),
              ),
              Text('$_appName $_version'),
            ],
          ),
        ),
      ),
    );
  }

  _signOutUser() async {
    // TODO Clear search history
    await _auth.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil(
        LandingPage.routeName, (Route<dynamic> route) => false);
  }
}
