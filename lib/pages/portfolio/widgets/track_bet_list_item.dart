import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/album/album.dart';
import 'package:tasty_tracks/pages/album/widgets/album_image.dart';
import 'package:tasty_tracks/pages/artist/artist.dart';

enum MenuActions { viewAlbum, viewArtist }

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

    DateTime createdTimestamp =
        trackBet.data['created_timestamp'] ?? DateTime.now();
    double initialWager = trackBet.data['initial_wager'];
    int initialPopularity = trackBet.data['initial_popularity'];
    int popularity = track.popularity;
    // TODO Temporary outcome calculation
    double outcome = (popularity / initialPopularity) * initialWager;
    double change = outcome - initialWager;

    String changePrefix = '';
    if (change > 0) {
      changePrefix = '+';
    }

    NumberFormat numberFormat = NumberFormat.currency(symbol: '');

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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${numberFormat.format(initialWager)} — placed ${DateFormat.yMMMd().format(createdTimestamp)}',
                style: theme.textTheme.caption,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(FeatherIcons.star, size: 18.0),
                  const SizedBox(width: 4.0),
                  Text(
                    numberFormat.format(outcome),
                    style: theme.textTheme.title,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '($changePrefix${numberFormat.format(change)})',
                    style: theme.textTheme.subtitle,
                  ),
                ],
              ),
              Text(
                '${popularity} /100',
                style: theme.textTheme.subtitle,
              ),
            ],
          ),
        ],
      ),
      isThreeLine: true,
      trailing: PopupMenuButton(
        onSelected: (MenuActions result) {
          switch (result) {
            case MenuActions.viewAlbum:
              _viewAlbum(context);
              break;
            case MenuActions.viewArtist:
              _viewArtist(context);
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
            ],
      ),
      onTap: () {
        onTap(track);
      },
    );
  }

  _viewAlbum(BuildContext context) {
    Navigator.of(context).pushNamed(
      AlbumPage.routeName,
      arguments: {
        'album_id': track.album.id,
      },
    );
  }

  _viewArtist(BuildContext context) {
    Navigator.of(context).pushNamed(
      ArtistPage.routeName,
      arguments: {
        'artist_id': track.artists.first.id,
      },
    );
  }
}
