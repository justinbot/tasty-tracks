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

    DateTime createdTimestamp = trackBet.data['created_timestamp'];

    NumberFormat numberFormat = NumberFormat.currency(symbol: '');

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.accentColor, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bet placed',
              style: theme.textTheme.subtitle,
            ),
            Divider(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${numberFormat.format(trackBet.data['amount'])}',
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
                  '${numberFormat.format(trackBet.data['amount'])}',
                  style: theme.textTheme.headline.copyWith(fontWeight: FontWeight.bold),
                ),
                Text('current value', style: theme.textTheme.body2,),
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
