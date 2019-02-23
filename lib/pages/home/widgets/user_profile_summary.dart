import 'package:flutter/material.dart';

class UserProfileSummary extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserProfileSummaryState();
  }
}

class UserProfileSummaryState extends State<UserProfileSummary> {
  @override
  void initState() {
    super.initState();
    // TODO Fetch user profile data
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    CircleAvatar userAvatar = CircleAvatar(
      backgroundColor: theme.accentColor,
      radius: 32.0,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        userAvatar,
        const SizedBox(width: 32.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'username goes here',
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
  }
}
