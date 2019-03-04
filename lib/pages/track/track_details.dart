import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/album/album_details.dart';
import 'package:tasty_tracks/spotify_api.dart';
import 'package:tasty_tracks/utils/format_date.dart';
import 'package:tasty_tracks/widgets/album_image.dart';
import 'package:tasty_tracks/widgets/palette_accent.dart';

enum MenuActions { viewAlbum, viewArtist, openSpotify }

class TrackDetailsPage extends StatefulWidget {
  const TrackDetailsPage({
    Key key,
    this.trackId,
  }) : super(key: key);

  static final String routeName = '/track-details';
  final String trackId;

  @override
  _TrackDetailsPageState createState() => _TrackDetailsPageState();
}

class _TrackDetailsPageState extends State<TrackDetailsPage> {
  bool _isBusy = false;
  bool _hasError = false;
  spotify.Track _track;
  spotify.Album _album;
  PaletteGenerator _palette;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Error loading your track :('),
            // TODO Try again button
          ],
        ),
      );
    } else if (_isBusy) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return PaletteAccent(
        palette: _palette,
        child: _TrackDetails(
          track: _track,
          album: _album,
        ),
      );
    }
  }

  void _loadData() async {
    setState(() {
      _isBusy = true;
      _hasError = false;
    });

    spotify.Track track;
    spotify.Album album;
    PaletteGenerator palette;
    try {
      track = await spotifyApi.tracks.get(widget.trackId);
      album = await spotifyApi.albums.get(track.album.id);

      if (album.images.isNotEmpty) {
        // TODO Causes stutter when loading with larger images
        // This is why we use the last (narrowest) image
        ImageProvider albumCover = NetworkImage(album.images.last.url);
        palette = await PaletteGenerator.fromImageProvider(albumCover);
      }
    } catch (e) {
      // TODO Log to error reporting
      setState(() {
        _hasError = true;
      });
    }

    setState(() {
      _isBusy = false;
      _track = track;
      _album = album;
      _palette = palette;
    });
  }
}

class _TrackDetails extends StatelessWidget {
  const _TrackDetails({
    Key key,
    this.track,
    this.album,
  }) : super(key: key);

  final spotify.Track track;
  final spotify.Album album;

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
                navigator.pushNamed(
                    AlbumDetailsPage.routeName + ':${track.album.id}');
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
    );
  }
}
