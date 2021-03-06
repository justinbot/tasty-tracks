import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/album/widgets/album_image.dart';

class AlbumSearchItem extends StatelessWidget {
  const AlbumSearchItem({
    Key key,
    this.onTap,
    this.album,
    this.trailing,
  }) : super(key: key);

  final onTap;
  final spotify.AlbumSimple album;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String artistNames = album.artists.map((artist) => artist.name).join(', ');

    return ListTile(
      leading: Hero(
        tag: 'albumImageHero-${album.id}-search',
        child: AlbumImage(
          album: album,
          diameter: 40.0,
          rounded: true,
        ),
      ),
      subtitle: Text(artistNames),
      title: Text(
        album.name,
        style: theme.textTheme.subhead,
      ),
      trailing: trailing,
      onTap: () {
        onTap(album);
      },
    );
  }
}
