import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spotify/spotify_io.dart' as spotify;

class ArtistDetails extends StatelessWidget {
  ArtistDetails({
    Key key,
    this.artist,
    this.center = false,
    this.heroSuffix,
  }) : super(key: key);

  final spotify.Artist artist;
  final bool center;
  final String heroSuffix;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    NumberFormat numberFormat = NumberFormat();

    Widget popularity = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${artist.popularity}',
          style: theme.textTheme.display2.copyWith(color: theme.accentColor),
        ),
        const SizedBox(width: 4.0),
        Text(
          '/100 popularity',
          style: theme.textTheme.subhead,
        ),
      ],
    );

    return Column(
      crossAxisAlignment:
          center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          artist.name,
          style: theme.textTheme.headline.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4.0),
        Text(
          '${numberFormat.format(artist.followers.total)} followers',
          style: theme.textTheme.caption,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16.0),
        popularity,
      ],
    );
  }
}
