import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/album/widgets/album_image.dart';

enum MenuActions { removeWatch, viewAlbum, viewArtist }

class TrackWatchListItem extends StatelessWidget {
  const TrackWatchListItem({
    Key key,
    this.onTap,
    this.track,
    this.trackWatch,
  }) : super(key: key);

  final onTap;
  final spotify.Track track;
  final DocumentSnapshot trackWatch;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    DateTime createdTimestamp = trackWatch.data['created_timestamp'];

    return ListTile(
      leading: Hero(
        tag: 'trackImageHero-${track.id}-watch',
        child: AlbumImage(
          album: track.album,
          diameter: 40.0,
          rounded: true,
        ),
      ),
      title: Text(
        track.name,
        style: theme.textTheme.subtitle,
      ),
      // TODO Display Explicit and other data in subtitle
      subtitle: Text(
        'Added ${DateFormat.yMMMd().format(createdTimestamp)}',
        style: theme.textTheme.caption,
      ),
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
