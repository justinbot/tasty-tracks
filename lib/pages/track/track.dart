import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/models/track_bet_model.dart';
import 'package:tasty_tracks/models/track_watch_model.dart';
import 'package:tasty_tracks/pages/album/widgets/album_image.dart';
import 'package:tasty_tracks/pages/track/widgets/track_app_bar.dart';
import 'package:tasty_tracks/pages/track/widgets/track_details.dart';
import 'package:tasty_tracks/pages/track/widgets/track_placeholder.dart';
import 'package:tasty_tracks/pages/track/widgets/track_preview_player.dart';
import 'package:tasty_tracks/pages/track_bet/track_bet_create.dart';
import 'package:tasty_tracks/pages/track_bet/widgets/track_bet_details.dart';
import 'package:tasty_tracks/spotify_api.dart';
import 'package:tasty_tracks/utils/theme_with_palette.dart';
import 'package:tasty_tracks/widgets/error_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class TrackPage extends StatefulWidget {
  // TODO take trackId or spotify.Track object
  const TrackPage({
    Key key,
    this.trackId,
    this.trackImageUrl,
    this.heroSuffix,
  }) : super(key: key);

  static const String routeName = '/track-details';
  final String trackId;
  final String trackImageUrl;
  final String heroSuffix;

  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  bool _isBusy = false;
  bool _hasError = false;
  TrackBetModel _trackBetModel;
  TrackWatchModel _trackWatchModel;
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
      return TrackPlaceholder(
        trackId: widget.trackId,
        trackImageUrl: widget.trackImageUrl,
        heroSuffix: widget.heroSuffix,
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

      Widget popularity = Row(
        mainAxisAlignment: MainAxisAlignment.center,
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

      Widget buttons = ScopedModelDescendant<TrackBetModel>(
        rebuildOnChange: false,
        builder: (context, child, trackBetModel) {
          return StreamBuilder(
            stream: trackBetModel.snapshots(trackId: _track.id),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData && snapshot.data.documents.isNotEmpty) {
                DocumentSnapshot trackBet = snapshot.data.documents.first;
                return TrackBetDetails(
                  trackBet: trackBet,
                  track: _track,
                  onPressed: () => _cancelBet(context, trackBetModel),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RaisedButton(
                      child: Text('Place bet...'),
                      color: theme.accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(64.0),
                      ),
                      onPressed: () => _placeBet(context),
                    ),
                    const SizedBox(height: 8.0),
                    ScopedModelDescendant<TrackWatchModel>(
                      rebuildOnChange: false,
                      builder: (context, child, trackWatchModel) {
                        return StreamBuilder(
                          stream: trackWatchModel.snapshots(trackId: _track.id),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data.documents.isNotEmpty) {
                              return OutlineButton(
                                child: Text('Remove watch'),
                                highlightedBorderColor: theme.accentColor,
                                splashColor: theme.accentColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(64.0),
                                ),
                                onPressed: () =>
                                    trackWatchModel.remove(_track.id),
                              );
                            } else {
                              return OutlineButton(
                                child: Text('Watch'),
                                highlightedBorderColor: theme.accentColor,
                                splashColor: theme.accentColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(64.0),
                                ),
                                onPressed: () => trackWatchModel.add(_track.id),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                );
              }
            },
          );
        },
      );

      Widget previewPlayer = TrackPreviewPlayer(previewUrl: _track.previewUrl);

      Widget copyrights = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _album.copyrights.map((c) {
          return Text(
            c.text,
            style: theme.textTheme.caption,
          );
        }).toList(),
      );

      Widget credits = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Available in ${_album.availableMarkets.length} markets.'),
          const SizedBox(height: 8.0),
          Text('${_album.label}'),
          const SizedBox(height: 4.0),
          copyrights,
        ],
      );

      return ScopedModel<TrackBetModel>(
        model: _trackBetModel,
        child: ScopedModel<TrackWatchModel>(
          model: _trackWatchModel,
          child: Theme(
            data: theme,
            child: Scaffold(
              appBar: TrackAppBar(
                track: _track,
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
                      const SizedBox(height: 8.0),
                      TrackDetails(
                        track: _track,
                        album: _album,
                        center: true,
                      ),
                      const SizedBox(height: 8.0),
                      popularity,
                      const SizedBox(height: 8.0),
                      buttons,
                      const SizedBox(height: 8.0),
                      previewPlayer,
                      const Divider(height: 24.0),
                      credits,
                    ],
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

    TrackWatchModel trackWatch;
    TrackBetModel trackBet;
    spotify.Track track;
    spotify.Album album;
    PaletteGenerator palette;
    try {
      trackWatch = TrackWatchModel(user: await _auth.currentUser());
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
      _trackWatchModel = trackWatch;
      _trackBetModel = trackBet;
      _track = track;
      _album = album;
      _palette = palette;
    });
  }

  _placeBet(BuildContext context) async {
    DocumentReference bet = await Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return TrackBetCreate(
          trackId: _track.id,
          trackImageUrl: widget.trackImageUrl,
          heroSuffix: widget.heroSuffix,
        );
      },
      fullscreenDialog: true,
    ));

    if (bet != null) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Bet placed.')));
    }
  }

  _cancelBet(BuildContext context, TrackBetModel trackBetModel) async {
    await trackBetModel.remove(_track.id);
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Bet cashed out.')));
  }
}
