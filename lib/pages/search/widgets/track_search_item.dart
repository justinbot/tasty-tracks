import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;

class TrackSearchItem extends StatelessWidget {
  const TrackSearchItem({
    Key key,
    this.onTap,
    this.track,
  }) : super(key: key);

  final onTap;
  final spotify.TrackSimple track;

  @override
  Widget build(BuildContext context) {
    CircleAvatar trackAvatar = CircleAvatar(
      backgroundColor: Colors.blueGrey,
    );
    String artistNames = track.artists.map((artist) => artist.name).join(', ');

    return ListTile(
      leading: trackAvatar,
      title: Text(
        track.name,
        style: Theme.of(context).textTheme.subhead,
      ),
      // TODO Display Explicit and other data in subtitle
      subtitle: Text(artistNames),
      onTap: () {
        onTap(context, track);
      },
    );
  }
}
