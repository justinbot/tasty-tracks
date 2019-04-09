import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/album/widgets/album_app_bar.dart';
import 'package:tasty_tracks/pages/album/widgets/album_details.dart';
import 'package:tasty_tracks/pages/album/widgets/album_image.dart';
import 'package:tasty_tracks/spotify_api.dart';
import 'package:tasty_tracks/utils/theme_with_palette.dart';
import 'package:tasty_tracks/widgets/error_page.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({
    Key key,
    this.albumId,
    this.albumImageUrl,
    this.heroSuffix,
  }) : super(key: key);

  static const String routeName = '/album-details';
  final String albumId;
  final String albumImageUrl;
  final String heroSuffix;

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  bool _isBusy;
  bool _hasError;
  spotify.Album _album;
  Iterable<spotify.TrackSimple> _tracks;
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
      ThemeData theme = themeWithPalette(Theme.of(context), _palette);

      Widget albumImage = Hero(
        tag: 'trackImageHero-${widget.heroSuffix ?? _album.id}',
        child: Material(
          elevation: 8,
          child: AlbumImage(
            album: _album,
          ),
        ),
      );

      return Theme(
        data: theme,
        child: Scaffold(
          appBar: AlbumAppBar(
            album: _album,
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
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: albumImage,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  AlbumDetails(
                    center: true,
                    album: _album,
                  ),
                  const SizedBox(height: 16.0),
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

    spotify.Album album;
    Iterable<spotify.TrackSimple> tracks;
    PaletteGenerator palette;
    try {
      album = await spotifyApi.albums.get(widget.albumId);
      tracks = await spotifyApi.albums.getTracks(widget.albumId).all();

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
