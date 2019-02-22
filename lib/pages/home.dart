import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static final String routeName = '/home';
  final String pageTitle = 'Home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Home'),
            ],
          ),
        ),
      ),
    );
  }
}
