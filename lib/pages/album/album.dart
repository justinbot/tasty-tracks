import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/album/widgets/album_details.dart';
import 'package:tasty_tracks/spotify_api.dart';
import 'package:tasty_tracks/widgets/error_page.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({
    Key key,
    this.albumId,
  }) : super(key: key);

  static final String routeName = '/album-details';
  final String albumId;

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
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
      return Scaffold(
        body: SafeArea(
          child: ErrorPage(
            errorText: 'Failed to load album :(',
            onRetry: () => _loadData(),
          ),
        ),
      );
    } else if (_isBusy) {
      // TODO Placeholder AlbumDetails
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return AlbumDetails(
        album: _album,
        tracks: _tracks,
        palette: _palette,
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
