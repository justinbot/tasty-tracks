import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/models/track_bet_model.dart';
import 'package:tasty_tracks/models/track_watch_model.dart';
import 'package:tasty_tracks/models/user_profile_model.dart';
import 'package:tasty_tracks/pages/album/widgets/album_image.dart';
import 'package:tasty_tracks/pages/track_bet/widgets/track_bet_create_form.dart';
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
  TrackWatchModel _trackWatchModel;
  UserProfileModel _userProfileModel;
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
      return TrackBetCreatePlaceholder(
        trackId: widget.trackId,
        trackImageUrl: widget.trackImageUrl,
        heroSuffix: widget.heroSuffix,
      );
    } else {
      ThemeData theme = themeWithPalette(Theme.of(context), _palette);

      String artistNames =
          _track.artists.map((artist) => artist.name).join(', ');

      Widget albumImage = Hero(
        tag: 'trackImageHero-${widget.heroSuffix ?? _track.id}',
        child: Material(
          elevation: 8,
          child: AlbumImage(
            album: _album,
          ),
        ),
      );

      Widget popularity = Row(
        children: [
          Text(
            '${_track.popularity}',
            style: theme.textTheme.display2.copyWith(color: theme.accentColor),
          ),
          const SizedBox(width: 4.0),
          Text(
            '/100 popularity',
            style: theme.textTheme.subhead,
          ),
        ],
      );

      Widget appBar = AppBar(
        backgroundColor: theme.accentColor.withOpacity(0.15),
        title: Text('Place bet'),
        actions: [
          IconButton(
            icon: Icon(FeatherIcons.helpCircle),
            onPressed: () {
              // TODO
            },
          ),
        ],
      );

      return ScopedModel<TrackBetModel>(
        model: _trackBetModel,
        child: ScopedModel<TrackWatchModel>(
          model: _trackWatchModel,
          child: ScopedModel<UserProfileModel>(
            model: _userProfileModel,
            child: Theme(
              data: themeWithPalette(Theme.of(context), _palette),
              child: Scaffold(
                appBar: appBar,
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
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 32.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: albumImage,
                              ),
                              SizedBox(width: 32.0),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    popularity,
                                    Text(
                                      _track.name,
                                      style: theme.textTheme.headline.copyWith(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      artistNames,
                                      style: theme.textTheme.subhead,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 64.0),
                          TrackBetCreateForm(
                            trackId: _track.id,
                          ),
                        ],
                      ),
                    ),
                  ),
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

    TrackWatchModel trackWatchModel;
    TrackBetModel trackBetModel;
    UserProfileModel userProfileModel;
    spotify.Track track;
    spotify.Album album;
    PaletteGenerator palette;
    try {
      FirebaseUser user = await _auth.currentUser();
      trackBetModel = TrackBetModel(user: user);
      trackWatchModel = TrackWatchModel(user: user);
      userProfileModel = UserProfileModel(user: user);

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
      _trackBetModel = trackBetModel;
      _trackWatchModel = trackWatchModel;
      _userProfileModel = userProfileModel;
      _track = track;
      _album = album;
      _palette = palette;
    });
  }
}
