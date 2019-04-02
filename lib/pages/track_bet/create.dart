import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/models/track_bet_model.dart';
import 'package:tasty_tracks/spotify_api.dart';
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
      return ScopedModel<TrackBetModel>(
        model: _trackBetModel,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Place bet'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Track name'),
                  Text('Artist name'),
                ],
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
