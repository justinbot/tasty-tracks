import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/album/album.dart';
import 'package:tasty_tracks/utils/format_date.dart';
import 'package:tasty_tracks/widgets/album_image.dart';
import 'package:tasty_tracks/widgets/palette_accent.dart';

enum MenuActions { viewAlbum, viewArtist, openSpotify }

class TrackDetails extends StatelessWidget {
  const TrackDetails({
    Key key,
    this.track,
    this.album,
    this.palette,
  }) : super(key: key);

  final spotify.Track track;
  final spotify.Album album;
  final PaletteGenerator palette;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    NavigatorState navigator = Navigator.of(context);

    Widget appBar = AppBar(
      backgroundColor: theme.canvasColor,
      actions: <Widget>[
        PopupMenuButton(
          onSelected: (MenuActions result) {
            switch (result) {
              case MenuActions.viewAlbum:
                navigator.pushNamed(AlbumPage.routeName + ':${track.album.id}');
                break;
              case MenuActions.viewArtist:
                // TODO
                break;
              case MenuActions.openSpotify:
                // TODO
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

    String artistNames = track.artists.map((artist) => artist.name).join(', ');

    Widget header = Expanded(
      child: Column(
        children: <Widget>[
          Hero(
            tag: 'trackImageHero-${track.id}',
            child: AlbumImage(
              album: album,
              diameter: 300.0,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            track.name,
            style: theme.textTheme.headline,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4.0),
          Text(
            artistNames,
            style: theme.textTheme.subhead,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          Text(
            '${album.name}',
            style: theme.textTheme.subtitle,
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
          RaisedButton(
            child: Text(
              'Place Bet',
            ),
            color: theme.accentColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(64.0)),
            onPressed: () {
              // TODO Place bet
            },
          ),
          const SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              Text(
                '${track.popularity}',
                style: theme.textTheme.display2,
              ),
              const SizedBox(width: 4.0),
              Text('/100 popularity'),
            ],
          ),
          const SizedBox(height: 8.0),
          Text('${track.duration.toString()}'),
          // TODO Add additional details from track analysis
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
