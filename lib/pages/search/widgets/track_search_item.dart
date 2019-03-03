import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/widgets/album_image.dart';

class TrackSearchItem extends StatelessWidget {
  const TrackSearchItem({
    Key key,
    this.onTap,
    this.track,
  }) : super(key: key);

  final onTap;
  final spotify.Track track;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String artistNames = track.artists.map((artist) => artist.name).join(', ');

    return ListTile(
      leading: Hero(
        tag: 'trackImageHero-${track.id}',
        child: AlbumImage(
          album: track.album,
          diameter: 40.0,
          rounded: true,
        ),
      ),
      title: Text(
        track.name,
        style: theme.textTheme.subhead,
      ),
      // TODO Display Explicit and other data in subtitle
      subtitle: Text(artistNames),
      onTap: () {
        onTap(track);
      },
    );
  }
}
