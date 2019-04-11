import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/utils/format_date.dart';

class AlbumDetails extends StatelessWidget {
  AlbumDetails({
    Key key,
    this.album,
    this.center = false,
    this.heroSuffix,
  }) : super(key: key);

  final spotify.Album album;
  final bool center;
  final String heroSuffix;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    String artistNames = album.artists.map((artist) => artist.name).join(', ');

    return Column(
      crossAxisAlignment:
          center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          album.name,
          style: theme.textTheme.headline.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4.0),
        Text(
          '${album.albumType} by ${artistNames}',
          style: theme.textTheme.subhead,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4.0),
        Text(
          formatDate(album.releaseDate, album.releaseDatePrecision),
          style: theme.textTheme.caption,
          textAlign: TextAlign.center,
        ),
        // TODO List tracks
      ],
    );
  }
}
