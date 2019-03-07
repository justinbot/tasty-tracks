import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/album/album.dart';
import 'package:tasty_tracks/pages/album/widgets/album_image.dart';
import 'package:tasty_tracks/pages/track/widgets/track_preview_player.dart';
import 'package:tasty_tracks/utils/format_date.dart';

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

    Widget albumImage = Hero(
      tag: 'trackImageHero-${track.id}',
      child: Material(
        elevation: 5,
        child: AlbumImage(
          album: album,
        ),
      ),
    );

    Widget header = Container(
      padding: EdgeInsets.symmetric(horizontal: 64.0, vertical: 32.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.accentColor.withOpacity(0.2),
            theme.accentColor.withOpacity(0.0)
          ],
        ),
      ),
      child: Column(
        children: <Widget>[
          albumImage,
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

//    Iterable<Widget> artistList = track.artists.map((artist) {
//      return
//    });

    Widget previewPlayer = TrackPreviewPlayer(previewUrl: track.previewUrl);

    Widget body = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    'Place Bet',
                  ),
                  color: theme.accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(64.0),
                  ),
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
                previewPlayer,
                // TODO Add additional details from track analysis
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            header,
            body,
          ],
        ),
      ),
    );
  }
}
