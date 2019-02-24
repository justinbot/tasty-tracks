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
    CircleAvatar albumAvatar = CircleAvatar(
      backgroundColor: Colors.blueGrey,
      backgroundImage:
          artist.images.isEmpty ? null : NetworkImage(artist.images.first.url),
    );

    return ListTile(
      leading: albumAvatar,
      title: Text(
        artist.name,
        style: Theme.of(context).textTheme.subhead,
      ),
      subtitle: Text('${artist.popularity}'),
      onTap: () {
        onTap(context, artist);
      },
    );
  }
}
