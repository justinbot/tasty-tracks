import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';

class UserProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserProfileState();
  }
}

class UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    super.initState();
    // TODO Fetch user profile data
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
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
    );
  }
}
