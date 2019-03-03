import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/spotify_api.dart';
import 'package:tasty_tracks/widgets/details_page.dart';
import 'package:tasty_tracks/widgets/album_image.dart';
import 'package:tasty_tracks/utils/format_date.dart';

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
    return DetailsPage(
      isBusy: _isBusy,
      hasError: _hasError,
      errorText: 'Error loading your track :(',
      palette: _palette,
      content: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          actions: <Widget>[
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: Text('View album'),
                  ),
                  PopupMenuItem(
                    child: Text('View artist'),
                  ),
                ];
              },
            ),
          ],
        ),
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
                        _TrackHeader(
                          track: _track,
                          album: _album,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      children: <Widget>[
                        _TrackBody(
                          track: _track,
                        )
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

  // TODO Rewrite as Future for FutureBuilder?
  _loadData() async {
    setState(() => _isBusy = true);

    try {
      spotify.Track track = await spotifyApi.tracks.get(widget.trackId);
      spotify.Album album = await spotifyApi.albums.get(track.album.id);
      PaletteGenerator palette;
      if (album.images.isNotEmpty) {
        // Generate palette from album cover
        // TODO Causes stutter when loading with larger images
        // This is why we use the last (narrowest) image
        ImageProvider albumCover = NetworkImage(album.images.last.url);
        palette = await PaletteGenerator.fromImageProvider(albumCover);
      }

      setState(() {
        _track = track;
        _album = album;
        _isBusy = false;
        if (palette != null) {
          _palette = palette;
        }
      });
    } catch (e) {
      setState(() {
        _isBusy = false;
        _hasError = true;
      });
    }
  }
}

class _TrackHeader extends StatelessWidget {
  const _TrackHeader({
    Key key,
    this.track,
    this.album,
  }) : super(key: key);

  final spotify.Track track;
  final spotify.Album album;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String artistNames = track.artists.map((artist) => artist.name).join(', ');

    return Expanded(
        child: Column(
      children: <Widget>[
        Hero(
          tag: 'avatarImageHero-${track.id}',
          child: AlbumImage(
            album: album,
            diameter: 300.0,
          ),
        ),
        SizedBox(height: 16.0),
        Text(
          track.name,
          style: theme.textTheme.headline,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.0),
        Text(
          artistNames,
          style: theme.textTheme.subhead,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.0),
        Text(
          '${album.name}',
          style: theme.textTheme.subtitle,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.0),
        Text(
          formatDate(album.releaseDate, album.releaseDatePrecision),
          style: theme.textTheme.caption,
        ),
      ],
    ));
  }
}

class _TrackBody extends StatelessWidget {
  const _TrackBody({
    Key key,
    this.track,
  }) : super(key: key);

  final spotify.Track track;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Expanded(
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
              onPressed: () {}),
          SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              Text(
                '${track.popularity}',
                style: theme.textTheme.display2,
              ),
              SizedBox(width: 4.0),
              Text('/100 popularity'),
            ],
          ),
          SizedBox(height: 8.0),
          Text('${track.duration.toString()}'),
          // TODO Add additional details from track analysis
        ],
      ),
    );
  }
}
