import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/spotify_api.dart';

class TrackDetailsPage extends StatefulWidget {
  static final String routeName = '/track-details';
  final String trackId;

  const TrackDetailsPage({Key key, this.trackId}) : super(key: key);

  @override
  _TrackDetailsPageState createState() => _TrackDetailsPageState();
}

class _TrackDetailsPageState extends State<TrackDetailsPage> {
  bool _busy = false;
  spotify.Track _track;
  spotify.Album _album;
  PaletteGenerator _paletteGenerator;

  @override
  void initState() {
    super.initState();

    setState(() {
      _busy = true;
    });
    // Get full track
    spotifyApi.tracks.get(widget.trackId).then((track) {
      // Get full album
      spotifyApi.albums.get(track.album.id).then((album) {
        setState(() {
          _track = track;
          _album = album;
        });
        ImageProvider albumCover = NetworkImage(_album.images.first.url);
        PaletteGenerator.fromImageProvider(albumCover).then((p) {
          setState(() => _paletteGenerator = p);
        });
      }).whenComplete(() {
        setState(() {
          _busy = false;
        });
      });
    }).catchError((error) {
      // TODO Handle error
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    // Get a vibrant color from the image to use as an accent
    Color trackColor = _paletteGenerator?.lightVibrantColor?.color ??
        _paletteGenerator?.vibrantColor?.color;
    if (trackColor != null) {
      theme = theme.copyWith(accentColor: trackColor);
    }

    return Theme(
        data: theme,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: theme.canvasColor,
            actions: <Widget>[
              PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  List<PopupMenuItem> items = [
                    PopupMenuItem(
                      child: Text('View album'),
                    ),
                    PopupMenuItem(
                      child: Text('View artist'),
                    ),
                  ];
                  return items;
                },
              ),
            ],
          ),
          body: SafeArea(
            child: _content(),
          ),
        ));
  }

  Widget _content() {
    if (_busy) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TrackHeader(
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
                    TrackDetails(
                      track: _track,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}

class TrackHeader extends StatelessWidget {
  const TrackHeader({
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

    // Format release date according to its precision
    String releaseDateFormatted = '';
    if (album.releaseDatePrecision == 'year') {
      DateTime releaseDate = DateTime.parse(album.releaseDate + '-01-01');
      releaseDateFormatted = DateFormat.y().format(releaseDate);
    } else if (album.releaseDatePrecision == 'month') {
      DateTime releaseDate = DateTime.parse(album.releaseDate + '-01');
      releaseDateFormatted = DateFormat.yMMM().format(releaseDate);
    } else if (album.releaseDatePrecision == 'day') {
      DateTime releaseDate = DateTime.parse(album.releaseDate);
      releaseDateFormatted = DateFormat.yMMMd().format(releaseDate);
    }

    return Expanded(
        child: Column(
      children: <Widget>[
        FadeInImage.assetNetwork(
          placeholder: 'assets/album_cover_placeholder.png',
          image: album.images.first.url,
          height: 256,
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
          releaseDateFormatted,
          style: theme.textTheme.caption,
        ),
      ],
    ));
  }
}

class TrackDetails extends StatelessWidget {
  const TrackDetails({
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
