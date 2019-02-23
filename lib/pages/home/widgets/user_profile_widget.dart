import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';

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
      backgroundColor: theme.primaryColor,
      radius: 48.0,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        userAvatar,
        const SizedBox(width: 24.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'username goes here',
              style: theme.textTheme.title,
            ),
            Text(
              '123,456,789.00',
              style: theme.textTheme.display1.apply(color: theme.accentColor),
            ),
          ],
        ),
      ],
    );
  }
}
