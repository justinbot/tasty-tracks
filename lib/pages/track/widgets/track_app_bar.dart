import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;
import 'package:url_launcher/url_launcher.dart';

import 'package:tasty_tracks/pages/album/album.dart';
import 'package:tasty_tracks/pages/artist/artist.dart';

enum MenuActions { viewAlbum, viewArtist, openSpotify }

class TrackAppBar extends StatelessWidget implements PreferredSizeWidget {
  TrackAppBar({
    Key key,
    this.track,
    this.album,
  }) : super(key: key);

  final spotify.Track track;
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
              case MenuActions.viewAlbum:
                _viewAlbum(context);
                break;
              case MenuActions.viewArtist:
                _viewArtist(context);
                break;
              case MenuActions.openSpotify:
                _openSpotify(context);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuActions>>[
                PopupMenuItem<MenuActions>(
                  value: MenuActions.viewAlbum,
                  child: Text('View album'),
                ),
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

  _openSpotify(BuildContext context) async {
    String url = track.uri;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      String errorMessage = "Couldn't open with Spotify";
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }
}
