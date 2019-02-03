import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  static final String routeName = '/search';
  final String pageTitle = 'Search';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Search'),
          ],
        ),
      ),
    );
  }
}
