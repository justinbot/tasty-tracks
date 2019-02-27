import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;

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
    Widget avatarImage;
    if (track.album.images.isNotEmpty) {
      avatarImage = FadeInImage.assetNetwork(
        image: track.album.images.first.url,
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

    String artistNames = track.artists.map((artist) => artist.name).join(', ');

    return ListTile(
      leading: Hero(
        tag: 'avatarImageHero-${track.id}',
        child: ClipOval(
          child: avatarImage,
        ),
      ),
      title: Text(
        track.name,
        style: Theme.of(context).textTheme.subhead,
      ),
      // TODO Display Explicit and other data in subtitle
      subtitle: Text(artistNames),
      onTap: () {
        onTap(track);
      },
    );
  }
}
