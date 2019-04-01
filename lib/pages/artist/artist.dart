import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/artist/widgets/artist_details.dart';
import 'package:tasty_tracks/spotify_api.dart';
import 'package:tasty_tracks/widgets/error_page.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage({
    Key key,
    this.artistId,
  }) : super(key: key);

  static const String routeName = '/artist-details';
  final String artistId;

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
      return ArtistDetails(
        artist: _artist,
        palette: _palette,
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
