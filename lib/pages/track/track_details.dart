import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/spotify_api.dart';

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
    ThemeData theme = Theme.of(context);

    if (_palette != null) {
      // Try to get a color from the palette to use as an accent
      Color trackColor = _palette.lightVibrantColor?.color ??
          _palette.vibrantColor?.color ??
          _palette.lightMutedColor?.color;
      if (trackColor != null) {
        theme = theme.copyWith(accentColor: trackColor);
      }
    }

    return Theme(
        data: theme,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: theme.canvasColor,
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
            child: _content(),
          ),
        ));
  }

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

  Widget _content() {
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Error loading your track :('),
            FlatButton(
              onPressed: () {
                _loadData();
              },
              child: Text('Try again'),
            ),
          ],
        ),
      );
    } else if (_isBusy) {
      return Center(
        child: CircularProgressIndicator(),
      );
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

    Widget avatarImage;
    if (album.images.isNotEmpty) {
      avatarImage = FadeInImage.assetNetwork(
        placeholder: 'assets/album_cover_placeholder.png',
        image: album.images.first.url,
        fit: BoxFit.cover,
        width: 300.0,
        height: 300.0,
      );
    } else {
      avatarImage = Image.asset(
        'assets/album_cover_placeholder.png',
        width: 300.0,
        height: 300.0,
      );
    }

    return Expanded(
        child: Column(
      children: <Widget>[
        Hero(
          tag: 'avatarImageHero-${track.id}',
          child: avatarImage,
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
