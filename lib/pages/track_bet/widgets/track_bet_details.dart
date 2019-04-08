import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrackBetDetails extends StatelessWidget {
  const TrackBetDetails({
    Key key,
    this.trackBet,
    this.onPressed,
  }) : super(key: key);

  final DocumentSnapshot trackBet;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    DateTime createdTimestamp = trackBet.data['created_timestamp'] ?? DateTime.now();

    NumberFormat numberFormat = NumberFormat.currency(symbol: '');

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.accentColor, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
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
              children: [
                Text(
                  '${numberFormat.format(trackBet.data['initial_wager'])} at 100 popularity',
                  style: theme.textTheme.subhead,
                ),
                Text('on ${DateFormat.yMMMd().format(createdTimestamp)}'),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // TODO current value
                  '${numberFormat.format(trackBet.data['initial_wager'])}',
                  style: theme.textTheme.display1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.accentColor,
                  ),
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
