import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/album/widgets/album_image.dart';

enum MenuActions { removeWatch, viewAlbum, viewArtist }

class TrackBetListItem extends StatelessWidget {
  const TrackBetListItem({
    Key key,
    this.onTap,
    this.track,
    this.trackBet,
  }) : super(key: key);

  final onTap;
  final spotify.Track track;
  final DocumentSnapshot trackBet;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    DateTime createdTimestamp = trackBet.data['created_timestamp'];

    return ListTile(
      leading: Hero(
        tag: 'trackImageHero-${track.id}-bet',
        child: AlbumImage(
          album: track.album,
          diameter: 40.0,
          rounded: true,
        ),
      ),
      title: Text(
        track.name,
        style: theme.textTheme.subhead,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      // TODO Display Explicit and other data in subtitle
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${track.popularity}/100 popularity'),
          Text('Added ${DateFormat.yMMMd().format(createdTimestamp)}')
        ],
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
