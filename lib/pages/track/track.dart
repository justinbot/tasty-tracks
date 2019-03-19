import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/track/widgets/track_details.dart';
import 'package:tasty_tracks/models/track_watch_model.dart';
import 'package:tasty_tracks/pages/track/widgets/track_details_placeholder.dart';
import 'package:tasty_tracks/spotify_api.dart';
import 'package:tasty_tracks/widgets/error_message.dart';
import 'package:tasty_tracks/utils/theme_with_palette.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _firestore = Firestore.instance;

class TrackPage extends StatefulWidget {
  const TrackPage({
    Key key,
    this.trackId,
    this.trackImageUrl,
  }) : super(key: key);

  static final String routeName = '/track-details';
  final String trackId;
  final String trackImageUrl;

  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  bool _isBusy = false;
  bool _hasError = false;
  TrackWatchModel _trackWatchModel;
  spotify.Track _track;
  spotify.Album _album;
  PaletteGenerator _palette;

  StreamSubscription _watchesSubscription;

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
          child: ErrorMessage(
            errorText: 'Failed to load track :(',
            onRetry: () => _loadData(),
          ),
        ),
      );
    } else if (_isBusy) {
      return TrackDetailsPlaceholder(
        trackId: widget.trackId,
        trackImageUrl: widget.trackImageUrl,
      );
    } else {
      return Theme(
        data: themeWithPalette(Theme.of(context), _palette),
        child: ScopedModel<TrackWatchModel>(
          model: _trackWatchModel,
          child: TrackDetails(
            track: _track,
            album: _album,
            palette: _palette,
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

    TrackWatchModel trackWatch;
    spotify.Track track;
    spotify.Album album;
    PaletteGenerator palette;
    try {
      trackWatch = TrackWatchModel(user: await _auth.currentUser());

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
      _trackWatchModel = trackWatch;
      _track = track;
      _album = album;
      _palette = palette;
    });
  }

  @override
  void dispose() {
    _watchesSubscription?.cancel();

    super.dispose();
  }
}
