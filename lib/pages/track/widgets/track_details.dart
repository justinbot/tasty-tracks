import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/album/widgets/album_image.dart';
import 'package:tasty_tracks/utils/format_date.dart';

class TrackDetails extends StatelessWidget {
  TrackDetails({
    Key key,
    this.track,
    this.album,
    this.heroSuffix,
  }) : super(key: key);

  final spotify.Track track;
  final spotify.Album album;
  final String heroSuffix;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    String artistNames = track.artists.map((artist) => artist.name).join(', ');

    Widget albumImage = Hero(
      tag: 'trackImageHero-${heroSuffix ?? track.id}',
      child: Material(
        elevation: 8,
        child: AlbumImage(
          album: album,
        ),
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.accentColor.withOpacity(0.25),
            theme.accentColor.withOpacity(0.0)
          ],
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: albumImage,
          ),
          const SizedBox(height: 16.0),
          Text(
            track.name,
            style:
                theme.textTheme.headline.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4.0),
          Text(
            artistNames,
            style: theme.textTheme.subhead,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          Text(
            '${album.name}',
            style: theme.textTheme.subtitle,
            textAlign: TextAlign.center,
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
      ),
    );
  }
}
