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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'My Portfolio',
              style: theme.textTheme.headline,
              textAlign: TextAlign.center,
            ),
            FlatButton(
              onPressed: () {
                // TODO Navigate to Portfolio Page
              },
              child: Text('View all'),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Text(
                'Nothing in your portfolio!',
                style: theme.textTheme.caption,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
