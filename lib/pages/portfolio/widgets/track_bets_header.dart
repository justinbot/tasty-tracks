import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

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
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
                    change.toString(),
                    style: theme.textTheme.title,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Updated 35 minutes ago',
                    style: theme.textTheme.caption,
                  ),
                  const SizedBox(width: 8.0),
                  Tooltip(
                    message: 'Bet outcomes are recalculated every few hours.',
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
