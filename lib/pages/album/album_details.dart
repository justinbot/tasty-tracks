import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/track/track_details.dart';
import 'package:tasty_tracks/spotify_api.dart';
import 'package:tasty_tracks/utils/format_date.dart';
import 'package:tasty_tracks/widgets/album_image.dart';
import 'package:tasty_tracks/widgets/palette_accent.dart';

enum MenuActions { viewArtist, openSpotify }

class AlbumDetailsPage extends StatefulWidget {
  const AlbumDetailsPage({
    Key key,
    this.albumId,
  }) : super(key: key);

  static final String routeName = '/album-details';
  final String albumId;

  @override
  _AlbumDetailsPageState createState() => _AlbumDetailsPageState();
}

class _AlbumDetailsPageState extends State<AlbumDetailsPage> {
  bool _isBusy;
  bool _hasError;
  spotify.Album _album;
  List<spotify.TrackSimple> _tracks;
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
            Text('Error loading your album :('),
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
        child: _AlbumDetails(
          album: _album,
          tracks: _tracks,
        ),
      );
    }
  }

  void _loadData() async {
    setState(() {
      _isBusy = true;
      _hasError = false;
    });

    spotify.Album album;
    Iterable<spotify.TrackSimple> tracks;
    PaletteGenerator palette;
    try {
      album = await spotifyApi.albums.get(widget.albumId);
      tracks =
          (await spotifyApi.albums.getTracks(widget.albumId).all()).toList();

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
      _album = album;
      _tracks = tracks;
      _palette = palette;
    });
  }
}

class _AlbumDetails extends StatelessWidget {
  const _AlbumDetails({
    Key key,
    this.album,
    this.tracks,
  }) : super(key: key);

  final spotify.Album album;
  final List<spotify.TrackSimple> tracks;

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
          itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<MenuActions>>[
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
