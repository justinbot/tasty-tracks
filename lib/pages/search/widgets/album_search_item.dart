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
    String artistNames = album.artists.map((artist) => artist.name).join(', ');

    Widget avatarImage;
    if (album.images.isNotEmpty) {
      avatarImage = FadeInImage.assetNetwork(
        placeholder: 'assets/album_cover_placeholder.png',
        image: album.images.first.url,
        fit: BoxFit.cover,
        width: 40.0,
        height: 40.0,
      );
    } else {
      avatarImage = Image.asset(
        'assets/album_cover_placeholder.png',
        width: 40.0,
        height: 40.0,
      );
    }

    return ListTile(
      leading: ClipOval(
        child: avatarImage,
      ),
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
