import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;
import 'package:url_launcher/url_launcher.dart';

enum MenuActions { openSpotify }

class ArtistAppBar extends StatelessWidget implements PreferredSizeWidget {
  ArtistAppBar({
    Key key,
    this.artist,
  }) : super(key: key);

  final spotify.Artist artist;

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
              case MenuActions.openSpotify:
                _openSpotify(context);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuActions>>[
                PopupMenuItem(
                  value: MenuActions.openSpotify,
                  child: Text('Open with Spotify'),
                ),
              ],
        ),
      ],
    );
  }

  _openSpotify(BuildContext context) async {
    String url = artist.uri;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      String errorMessage = "Couldn't open with Spotify";
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }
}
