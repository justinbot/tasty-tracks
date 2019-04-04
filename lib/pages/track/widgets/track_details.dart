import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/utils/format_date.dart';

class TrackDetails extends StatelessWidget {
  TrackDetails({
    Key key,
    this.track,
    this.album,
    this.center = false,
  }) : super(key: key);

  final spotify.Track track;
  final spotify.Album album;
  final bool center;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    String artistNames = track.artists.map((artist) => artist.name).join(', ');

    return Column(
      crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          track.name,
          style: theme.textTheme.headline.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4.0),
        Text(
          artistNames,
          style: theme.textTheme.subhead,
        ),
        const SizedBox(height: 16.0),
        Text(
          '${album.name}',
          style: theme.textTheme.subtitle,
        ),
        const SizedBox(height: 4.0),
        Text(
          formatDate(album.releaseDate, album.releaseDatePrecision),
          style: theme.textTheme.caption,
        ),
        Text(
          printDuration(track.duration),
          style: theme.textTheme.caption,
        ),
      ],
    );
  }
}
