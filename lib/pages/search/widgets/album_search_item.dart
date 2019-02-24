import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;

class AlbumSearchItem extends StatelessWidget {
  const AlbumSearchItem({
    Key key,
    this.onTap,
    this.album,
  }) : super(key: key);

  final onTap;
  final spotify.AlbumSimple album;

  @override
  Widget build(BuildContext context) {
    CircleAvatar albumAvatar = CircleAvatar(
      backgroundImage: NetworkImage(album.images.first.url),
    );
    String artistNames = album.artists.map((artist) => artist.name).join(', ');

    return ListTile(
      leading: albumAvatar,
      title: Text(
        album.name,
        style: Theme.of(context).textTheme.subhead,
      ),
      subtitle: Text(artistNames),
      onTap: () {
        onTap(context, album);
      },
    );
  }
}
