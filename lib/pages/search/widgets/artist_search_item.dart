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

    Widget avatarImage;
    if (artist.images.isNotEmpty) {
      avatarImage = FadeInImage.assetNetwork(
        image: artist.images.first.url,
        placeholder: 'assets/album_cover_placeholder.png',
        fit: BoxFit.cover,
        fadeOutDuration: const Duration(milliseconds: 100),
        fadeInDuration: const Duration(milliseconds: 300),
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
