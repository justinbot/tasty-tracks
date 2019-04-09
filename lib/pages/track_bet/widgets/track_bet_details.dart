import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spotify/spotify_io.dart' as spotify;

class TrackBetDetails extends StatelessWidget {
  const TrackBetDetails({
    Key key,
    this.trackBet,
    this.track,
    this.onPressed,
  }) : super(key: key);

  final DocumentSnapshot trackBet;
  final spotify.Track track;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    DateTime createdTimestamp =
        trackBet.data['created_timestamp'] ?? DateTime.now();
    double initialWager = trackBet.data['initial_wager'];
    int initialPopularity = trackBet.data['initial_popularity'];
    int popularity = track.popularity;
    // TODO Temporary outcome calculation
    double outcome = (popularity / initialPopularity) * initialWager;

    double change = outcome - initialWager;

    NumberFormat numberFormat = NumberFormat.currency(symbol: '');

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.accentColor, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: theme.canvasColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'BET PLACED',
              style: theme.textTheme.subtitle,
            ),
            Divider(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${numberFormat.format(initialWager)} at ${initialPopularity} popularity',
                  style: theme.textTheme.subhead,
                ),
                Text('on ${DateFormat.yMMMd().format(createdTimestamp)}'),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              '+${numberFormat.format(change)}',
              style: theme.textTheme.subhead,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      FeatherIcons.star,
                      size: 32.0,
                      color: theme.accentColor,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '${numberFormat.format(outcome)}',
                      style: theme.textTheme.display1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.accentColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  'current value',
                  style: theme.textTheme.subhead,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            OutlineButton(
              child: Text('Cash out'),
              splashColor: theme.accentColor,
              highlightedBorderColor: theme.accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(64.0),
              ),
              onPressed: () => onPressed(),
            ),
          ],
        ),
      ),
    );
  }
}
