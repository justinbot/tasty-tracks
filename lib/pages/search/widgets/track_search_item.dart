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
    Widget avatarImage = ClipOval(
      child: FadeInImage.assetNetwork(
        placeholder: 'assets/album_cover_placeholder.png',
        image:
            track.album.images.isNotEmpty ? track.album.images.first.url : '',
        fit: BoxFit.cover,
        height: 40.0,
      ),
    );

    String artistNames = track.artists.map((artist) => artist.name).join(', ');

    return ListTile(
      leading: Hero(
        tag: 'avatarImageHero-${track.id}',
        child: avatarImage,
      ),
      title: Text(
        track.name,
        style: Theme.of(context).textTheme.subhead,
      ),
      // TODO Display Explicit and other data in subtitle
      subtitle: Text(artistNames),
      onTap: () {
        print('presst ${track.id}');
        onTap(context, track);
      },
    );
  }
}
