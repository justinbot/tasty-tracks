import 'package:flutter/material.dart';

class UserPortfolioSummary extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserPortfolioSummaryState();
  }
}

class UserPortfolioSummaryState extends State<UserPortfolioSummary> {
  @override
  void initState() {
    super.initState();
    // TODO Fetch user portfolio data
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'My Portfolio',
          style: theme.textTheme.headline,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Nothing in your portfolio!',
              style: theme.textTheme.caption,
            ),
          ],
        ),
        const SizedBox(height: 32.0),
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
  }
}
