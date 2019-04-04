import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/models/track_bet_model.dart';
import 'package:tasty_tracks/pages/album/widgets/album_image.dart';
import 'package:tasty_tracks/pages/track/widgets/track_details.dart';
import 'package:tasty_tracks/pages/track_bet/widgets/track_bet_create_placeholder.dart';
import 'package:tasty_tracks/spotify_api.dart';
import 'package:tasty_tracks/utils/theme_with_palette.dart';
import 'package:tasty_tracks/widgets/error_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class TrackBetCreate extends StatefulWidget {
  const TrackBetCreate({
    Key key,
    this.trackId,
    this.trackImageUrl,
    this.heroSuffix,
  }) : super(key: key);

  static const String routeName = '/track-bet/create';
  final String trackId;
  final String trackImageUrl;
  final String heroSuffix;

  @override
  State<StatefulWidget> createState() => _TrackBetCreateState();
}

class _TrackBetCreateState extends State<TrackBetCreate> {
  bool _isBusy = false;
  bool _hasError = false;
  TrackBetModel _trackBetModel;
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
      return Scaffold(
        body: SafeArea(
          child: ErrorPage(
            errorText: 'Failed to load track :(',
            onRetry: () => _loadData(),
          ),
        ),
      );
    } else if (_isBusy) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      ThemeData theme = themeWithPalette(Theme.of(context), _palette);

      Widget albumImage = Hero(
        tag: 'trackImageHero-${widget.heroSuffix ?? _track.id}',
        child: Material(
          elevation: 8,
          child: AlbumImage(
            album: _album,
          ),
        ),
      );

      return ScopedModel<TrackBetModel>(
        model: _trackBetModel,
        child: Theme(
          data: themeWithPalette(Theme.of(context), _palette),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: theme.accentColor.withOpacity(0.15),
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.accentColor.withOpacity(0.25),
                    theme.accentColor.withOpacity(0.0)
                  ],
                ),
              ),
              child: SafeArea(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 32.0,
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 64.0),
                      child: albumImage,
                    ),
                    const SizedBox(height: 16.0),
                    TrackDetails(
                      track: _track,
                      album: _album,
                      center: true,
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  void _loadData() async {
    setState(() {
      _isBusy = true;
      _hasError = false;
    });

    TrackBetModel trackBet;
    spotify.Track track;
    spotify.Album album;
    PaletteGenerator palette;
    try {
      trackBet = TrackBetModel(user: await _auth.currentUser());

      // Get track
      track = await spotifyApi.tracks.get(widget.trackId);

      // Get album
      album = await spotifyApi.albums.get(track.album.id);

      // Set palette
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
      _trackBetModel = trackBet;
      _track = track;
      _album = album;
      _palette = palette;
    });
  }
}
