import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/album/album.dart';
import 'package:tasty_tracks/utils/format_date.dart';
import 'package:tasty_tracks/utils/theme_with_palette.dart';
import 'package:tasty_tracks/pages/album/widgets/album_image.dart';

enum MenuActions { openSpotify }

class ArtistDetails extends StatelessWidget {
  const ArtistDetails({
    Key key,
    this.artist,
    this.palette,
  }) : super(key: key);

  final spotify.Artist artist;
  final PaletteGenerator palette;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    theme = themeWithPalette(theme, palette);
    NavigatorState navigator = Navigator.of(context);

    Widget appBar = AppBar(
      backgroundColor: theme.canvasColor,
      actions: <Widget>[
        PopupMenuButton(
          onSelected: (MenuActions result) {
            switch (result) {
              case MenuActions.openSpotify:
                // TODO
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

    Widget header = Expanded(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16.0),
          Text(
            artist.name,
            style: theme.textTheme.headline,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      header,
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
