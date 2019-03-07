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
        elevation: 8,
        child: AlbumImage(
          album: album,
        ),
      ),
    );

    Widget header = Container(
      padding: EdgeInsets.symmetric(horizontal: 64.0, vertical: 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.accentColor.withOpacity(0.4),
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

    Widget previewPlayer = TrackPreviewPlayer(previewUrl: track.previewUrl);

    Widget popularity = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '${track.popularity}',
          style: theme.textTheme.display2.copyWith(color: theme.accentColor),
        ),
        const SizedBox(width: 4.0),
        Text(
          '/100 popularity',
          style: theme.textTheme.subhead,
        ),
      ],
    );

    Widget buttons = Column(
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
        OutlineButton(
          child: Text(
            'Follow',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(64.0),
          ),
          onPressed: () {
            // TODO Place bet
          },
        ),
      ],
    );

    Iterable<Widget> artistList = track.artists.map((artist) {
      return Text(artist.name);
    });

    Widget artists = Column(
      children: artistList.toList(),
    );

    Widget body = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          popularity,
          const SizedBox(height: 4.0),
          buttons,
          const SizedBox(height: 16.0),
          previewPlayer,
          const SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              Icon(FeatherIcons.music),
              Text(
                'Track',
                style: theme.textTheme.title,
              ),
            ],
          ),
          Text('${track.duration.toString()}'),
          const SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              Icon(FeatherIcons.user),
              Text(
                'Artists',
                style: theme.textTheme.title,
              ),
            ],
          ),
          artists,
          // TODO Add additional details from track analysis
        ],
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(
            bottom: 64.0,
          ),
          children: <Widget>[
            header,
            body,
          ],
        ),
      ),
    );
  }
}
