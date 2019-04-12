import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/album/widgets/album_image.dart';

class TrackSearchItem extends StatelessWidget {
  const TrackSearchItem({
    Key key,
    this.onTap,
    this.track,
    this.trailing,
  }) : super(key: key);

  final onTap;
  final spotify.Track track;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String artistNames = track.artists.map((artist) => artist.name).join(', ');

    List<Widget> subtitle = [
      Text(
        '${track.popularity}',
        style: theme.textTheme.subhead,
      ),
      Text(
        ' /100 popularity',
      ),
    ];

    if (track.explicit) {
      subtitle.insertAll(0, [
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.0,
              vertical: 3.0,
            ),
            child: Text(
              'explicit',
              style: theme.textTheme.caption.copyWith(letterSpacing: 0.6),
            ),
          ),
        ),
        Text(' — '),
      ]);
    }

    return ListTile(
      leading: Hero(
        tag: 'trackImageHero-${track.id}-search',
        child: AlbumImage(
          album: track.album,
          diameter: 40.0,
          rounded: true,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: subtitle,
            ),
          ),
          Text(artistNames),
        ],
      ),
      title: Text(
        track.name,
      ),
      trailing: trailing,
      onTap: () {
        onTap(track);
      },
    );
  }
}
