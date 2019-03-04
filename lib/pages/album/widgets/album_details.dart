import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/track/track.dart';
import 'package:tasty_tracks/utils/format_date.dart';
import 'package:tasty_tracks/widgets/album_image.dart';
import 'package:tasty_tracks/widgets/palette_accent.dart';

enum MenuActions { viewArtist, openSpotify }

class AlbumDetails extends StatelessWidget {
  const AlbumDetails({
    Key key,
    this.album,
    this.tracks,
    this.palette,
  }) : super(key: key);

  final spotify.Album album;
  final List<spotify.TrackSimple> tracks;
  final PaletteGenerator palette;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Widget appBar = AppBar(
      backgroundColor: theme.canvasColor,
      actions: <Widget>[
        PopupMenuButton(
          onSelected: (MenuActions result) {
            switch (result) {
              case MenuActions.viewArtist:
                // TODO
                break;
              case MenuActions.openSpotify:
                // TODO
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

    String artistNames = album.artists.map((artist) => artist.name).join(', ');

    Widget header = Expanded(
      child: Column(
        children: <Widget>[
          Hero(
            tag: 'albumImageHero-${album.id}',
            child: AlbumImage(
              album: album,
              diameter: 300.0,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            album.name,
            style: theme.textTheme.headline,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4.0),
          Text(
            '${album.albumType} by ${artistNames}',
            style: theme.textTheme.subhead,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4.0),
          Text(
            formatDate(album.releaseDate, album.releaseDatePrecision),
            style: theme.textTheme.caption,
          ),
        ],
      ),
    );

    Widget body = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '${album.popularity}',
                style: theme.textTheme.display2,
              ),
              const SizedBox(width: 4.0),
              Text('/100 popularity'),
            ],
          ),
          // TODO Add additional details from track analysis
          Text('Tracks'),
        ],
      ),
    );

    return PaletteAccent(
      palette: palette,
      child: Scaffold(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      children: <Widget>[
                        body,
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
