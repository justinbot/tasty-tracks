import 'package:duration/duration.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify_io.dart' as spotify;
import 'package:url_launcher/url_launcher.dart';

import 'package:tasty_tracks/pages/album/album.dart';
import 'package:tasty_tracks/pages/album/widgets/album_image.dart';
import 'package:tasty_tracks/pages/artist/artist.dart';
import 'package:tasty_tracks/pages/track/widgets/track_preview_player.dart';
import 'package:tasty_tracks/utils/format_date.dart';

enum MenuActions { viewAlbum, viewArtist, openSpotify }

class TrackDetails extends StatelessWidget {
  TrackDetails({
    Key key,
    this.track,
    this.album,
    this.palette,
  }) : super(key: key);

  final spotify.Track track;
  final spotify.Album album;
  final PaletteGenerator palette;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Widget appBar = AppBar(
      backgroundColor: theme.canvasColor,
      actions: <Widget>[
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
      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: albumImage,
          ),
          const SizedBox(height: 16.0),
          Text(
            track.name,
            style:
                theme.textTheme.headline.copyWith(fontWeight: FontWeight.bold),
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
          Text(
            printDuration(track.duration),
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
            // TODO Place bet on Track
          },
        ),
        OutlineButton(
          child: Text(
            'Watch',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(64.0),
          ),
          onPressed: () {
            // TODO Place watch on Track
          },
        ),
      ],
    );

    Widget copyrights = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: album.copyrights.map((c) {
        return Text(
          c.text,
          style: theme.textTheme.caption,
        );
      }).toList(),
    );

    Widget credits = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Available in ${album.availableMarkets.length} markets.'),
        const SizedBox(height: 8.0),
        Text('${album.label}'),
        const SizedBox(height: 4.0),
        copyrights,
      ],
    );

    Widget body = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          popularity,
          const SizedBox(height: 8.0),
          buttons,
          const SizedBox(height: 8.0),
          previewPlayer,
          const SizedBox(height: 16.0),
          credits,
        ],
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
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

  void _viewAlbum(BuildContext context) {
    Navigator.of(context).pushNamed(AlbumPage.routeName + ':${track.album.id}');
  }

  void _viewArtist(BuildContext context) {
    Navigator.of(context)
        .pushNamed(ArtistPage.routeName + ':${track.artists.first.id}');
  }

  void _openSpotify(BuildContext context) async {
    String url = track.uri;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      String errorMessage = "Couldn't open with Spotify";
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }
}
