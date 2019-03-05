import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/track/widgets/track_details.dart';
import 'package:tasty_tracks/pages/track/widgets/track_details_placeholder.dart';
import 'package:tasty_tracks/spotify_api.dart';
import 'package:tasty_tracks/widgets/error_message.dart';

class TrackPage extends StatefulWidget {
  const TrackPage({
    Key key,
    this.trackId,
  }) : super(key: key);

  static final String routeName = '/track-details';
  final String trackId;

  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
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
      return Scaffold(
        body: SafeArea(
          child: ErrorMessage(
            errorText: 'Failed to load track :(',
            onRetry: () => _loadData(),
          ),
        ),
      );
    } else if (_isBusy) {
      // TODO Placeholder TrackDetails
      return TrackDetailsPlaceholder(
        trackId: widget.trackId,
      );
    } else {
      return TrackDetails(
        track: _track,
        album: _album,
        palette: _palette,
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
