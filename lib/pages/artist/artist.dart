import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/artist/widgets/artist_app_bar.dart';
import 'package:tasty_tracks/pages/artist/widgets/artist_details.dart';
import 'package:tasty_tracks/pages/artist/widgets/artist_image.dart';
import 'package:tasty_tracks/spotify_api.dart';
import 'package:tasty_tracks/utils/theme_with_palette.dart';
import 'package:tasty_tracks/widgets/error_page.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage({
    Key key,
    this.artistId,
    this.artistImageUrl,
    this.heroSuffix,
  }) : super(key: key);

  static const String routeName = '/artist-details';
  final String artistId;
  final String artistImageUrl;
  final String heroSuffix;

  @override
  _ArtistPageState createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  bool _isBusy;
  bool _hasError;
  spotify.Artist _artist;
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
            errorText: 'Failed to load artist :(',
            onRetry: () => _loadData(),
          ),
        ),
      );
    } else if (_isBusy) {
      // TODO Placeholder ArtistDetails
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      ThemeData theme = themeWithPalette(Theme.of(context), _palette);

      Widget artistImage = Hero(
        tag: 'trackImageHero-${widget.heroSuffix ?? _artist.id}',
        child: Material(
          elevation: 8,
          child: ArtistImage(
            artist: _artist,
          ),
        ),
      );

      return Theme(
        data: theme,
        child: Scaffold(
          appBar: ArtistAppBar(
            artist: _artist,
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
                      child: artistImage,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ArtistDetails(
                    artist: _artist,
                    center: true,
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

    spotify.Artist artist;
    PaletteGenerator palette;
    try {
      artist = await spotifyApi.artists.get(widget.artistId);

      // TODO Get artist top tracks
      // TODO Get related artists

      if (artist.images.isNotEmpty) {
        // TODO Causes stutter when loading with larger images
        // This is why we use the last (narrowest) image
        ImageProvider artistImage = NetworkImage(artist.images.last.url);
        palette = await PaletteGenerator.fromImageProvider(artistImage);
      }
    } catch (e) {
      // TODO Log to error reporting
      setState(() {
        _hasError = true;
      });
    }

    setState(() {
      _isBusy = false;
      _artist = artist;
      _palette = palette;
    });
  }
}
