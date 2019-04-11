import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class TrackBetsHeader extends StatelessWidget {
  const TrackBetsHeader({
    Key key,
    this.change,
    this.updated,
  }) : super(key: key);

  final double change;
  final DateTime updated;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    NumberFormat numberFormat = NumberFormat.currency(symbol: '');

    Icon changeIcon;
    if (change > 0.0) {
      changeIcon = Icon(
        FeatherIcons.trendingUp,
        color: Colors.greenAccent,
      );
    } else if (change < 0.0) {
      changeIcon = Icon(
        FeatherIcons.trendingDown,
        color: Colors.pinkAccent,
      );
    } else {
      changeIcon = Icon(
        FeatherIcons.minus,
        color: theme.disabledColor,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  changeIcon,
                  const SizedBox(width: 12.0),
                  Text(
                    numberFormat.format(change),
                    style: theme.textTheme.title,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Updated ${timeago.format(updated)}',
                    style: theme.textTheme.caption,
                  ),
                  const SizedBox(width: 8.0),
                  Tooltip(
                    message: 'Bet outcomes are re-calculated every few hours.',
                    child: Icon(
                      FeatherIcons.helpCircle,
                      color: theme.textTheme.caption.color,
                      size: 20.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
