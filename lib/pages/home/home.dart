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
    ThemeData theme = Theme.of(context);
    CircleAvatar userAvatar = CircleAvatar(
      backgroundColor: theme.accentColor,
      radius: 32.0,
    );

    Widget userSummary = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        userAvatar,
        SizedBox(width: 16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'username',
              style: theme.textTheme.title,
            ),
            Text(
              '123,456,789.00',
              style: theme.textTheme.headline,
            ),
          ],
        ),
      ],
    );

    Widget userPortfolio = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'My Portfolio',
          style: theme.textTheme.headline,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Nothing in your portfolio!',
              style: theme.textTheme.caption,
            ),
          ],
        ),
        SizedBox(height: 32.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              onPressed: () {},
              child: Text('View all'),
            ),
          ],
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 16.0),
              userSummary,
              Divider(
                height: 32.0,
              ),
              userPortfolio,
              Divider(
                height: 32.0,
              ),
              Text('TODO Trends'),
            ],
          ),
        ),
      ),
    );
  }
}
