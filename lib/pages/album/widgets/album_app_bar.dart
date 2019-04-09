import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;
import 'package:url_launcher/url_launcher.dart';

import 'package:tasty_tracks/pages/artist/artist.dart';

enum MenuActions { viewArtist, openSpotify }

class AlbumAppBar extends StatelessWidget implements PreferredSizeWidget {
  AlbumAppBar({
    Key key,
    this.album,
  }) : super(key: key);

  final spotify.Album album;

  @override
  final Size preferredSize = Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.accentColor.withOpacity(0.15),
      actions: [
        PopupMenuButton(
          onSelected: (MenuActions result) {
            switch (result) {
              case MenuActions.viewArtist:
                _viewArtist(context);
                break;
              case MenuActions.openSpotify:
                _openSpotify(context);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuActions>>[
                PopupMenuItem(
                  value: MenuActions.viewArtist,
                  child: Text('View artist'),
                ),
                PopupMenuItem(
                  value: MenuActions.openSpotify,
                  child: Text('Open with Spotify'),
                ),
              ],
        ),
      ],
    );
  }

  _viewArtist(BuildContext context) {
    Navigator.of(context).pushNamed(
      ArtistPage.routeName,
      arguments: {
        'artist_id': album.artists.first.id,
      },
    );
  }

  _openSpotify(BuildContext context) async {
    String url = album.uri;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      String errorMessage = "Couldn't open with Spotify";
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }
}
