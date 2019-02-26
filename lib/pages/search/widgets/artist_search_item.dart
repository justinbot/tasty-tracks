import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;

class ArtistSearchItem extends StatelessWidget {
  const ArtistSearchItem({
    Key key,
    this.onTap,
    this.artist,
  }) : super(key: key);

  final onTap;
  final spotify.Artist artist;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    CircleAvatar albumAvatar = CircleAvatar(
      backgroundColor: Colors.blueGrey,
      backgroundImage:
          artist.images.isEmpty ? null : NetworkImage(artist.images.first.url),
    );

    return ListTile(
      leading: albumAvatar,
      title: Text(
        artist.name,
        style: theme.textTheme.subhead,
      ),
      subtitle: Row(
        children: <Widget>[
          Text(
            '${artist.popularity}/100 popularity',
          ),
        ],
      ),
      onTap: () {
        onTap(context, artist);
      },
    );
  }
}
