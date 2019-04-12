import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/artist/widgets/artist_image.dart';

class ArtistSearchItem extends StatelessWidget {
  const ArtistSearchItem({
    Key key,
    this.onTap,
    this.artist,
    this.trailing,
  }) : super(key: key);

  final onTap;
  final spotify.Artist artist;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ListTile(
      leading: Hero(
        tag: 'artistImageHero-${artist.id}-search',
        child: ArtistImage(
          artist: artist,
          diameter: 40.0,
          rounded: true,
        ),
      ),
      trailing: trailing,
      subtitle: Row(
        children: [
          Text(
            '${artist.popularity}',
            style: theme.textTheme.subhead,
          ),
          Text(
            ' /100 popularity',
          ),
        ],
      ),
      title: Text(
        artist.name,
        style: theme.textTheme.subhead,
      ),
      onTap: () {
        onTap(artist);
      },
    );
  }
}
