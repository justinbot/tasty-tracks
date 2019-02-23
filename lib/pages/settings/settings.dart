import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SettingsPage extends StatefulWidget {
  static final String routeName = '/settings';
  final String pageTitle = 'Settings';

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

  _signOutUser() {
    _auth.signOut().then((_) {
      Navigator.pushReplacementNamed(context, '/');
    }).catchError((e) {
      // TODO Display error
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
}
