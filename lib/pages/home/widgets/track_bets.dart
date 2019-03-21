import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';

class TrackBets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(FeatherIcons.folder),
                Text(
                  'Portfolio',
                  style: theme.textTheme.title,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Text(
              'Last updated time',
              style: theme.textTheme.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Text(
                'No bets to show yet!',
                style: theme.textTheme.caption,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
