import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/album/widgets/album_image.dart';

enum MenuActions { removeWatch, viewAlbum, viewArtist }

class TrackWatchListItem extends StatelessWidget {
  const TrackWatchListItem({
    Key key,
    this.onTap,
    this.trackWatch,
    this.track,
  }) : super(key: key);

  final onTap;
  final DocumentSnapshot trackWatch;
  final spotify.Track track;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String artistNames = track.artists.map((artist) => artist.name).join(', ');

    return ListTile(
      leading: Hero(
        tag: 'trackImageHero-${track.id}',
        child: AlbumImage(
          album: track.album,
          diameter: 40.0,
          rounded: true,
        ),
      ),
      title: Text(
        track.name,
        style: theme.textTheme.subhead,
      ),
      // TODO Display Explicit and other data in subtitle
      subtitle: Text(artistNames),
      trailing: PopupMenuButton(
        onSelected: (MenuActions result) {
          switch (result) {
            case MenuActions.removeWatch:
              // TODO
              break;
            case MenuActions.viewAlbum:
              // TODO
              break;
            case MenuActions.viewArtist:
              // TODO
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuActions>>[
              PopupMenuItem(
                value: MenuActions.viewAlbum,
                child: Text('View album'),
              ),
              PopupMenuItem(
                value: MenuActions.viewArtist,
                child: Text('View artist'),
              ),
              PopupMenuItem(
                value: MenuActions.removeWatch,
                child: Text('Remove watch'),
              ),
            ],
      ),
      onTap: () {
        onTap(track);
      },
    );
  }
}
