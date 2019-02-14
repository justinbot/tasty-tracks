import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/spotify_api.dart';

class TrackDetailsPage extends StatefulWidget {
  static final String routeName = '/track-details';
  final String trackId;

  const TrackDetailsPage({Key key, this.trackId}) : super(key: key);

  @override
  _TrackDetailsPageState createState() => _TrackDetailsPageState();
}

class _TrackDetailsPageState extends State<TrackDetailsPage> {
  bool _busy = false;
  spotify.Track _track;
  spotify.Album _album;

  @override
  void initState() {
    super.initState();

    setState(() {
      _busy = true;
    });
    // Get full track
    spotifyApi.tracks.get(widget.trackId).then((track) {
      // Get full album
      spotifyApi.albums.get(track.album.id).then((album) {
        setState(() {
          _track = track;
          _album = album;
        });
      }).whenComplete(() {
        setState(() {
          _busy = false;
        });
      });
    }).catchError((error) {
      // TODO Handle error
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _trackHeader(context),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(children: <Widget>[
                      _trackDetails(context),
                    ])),
              ]),
        ));
  }

  Widget _trackHeader(BuildContext context) {
    if (_busy) {
      // TODO Placeholder album cover
      return Expanded(child: Center(child: CircularProgressIndicator()));
    } else {
      String artistNames =
      _track.artists.map((artist) => artist.name).join(', ');

      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Image.network(
              // TODO FadeInImage
              _album.images.first.url,
              fit: BoxFit.cover,
              height: 256,
            ),
          ),
          Text(
            _track.name,
            style: Theme
                .of(context)
                .textTheme
                .title,
          ),
          Text(
            artistNames,
            style: Theme
                .of(context)
                .textTheme
                .subtitle,
          ),
        ],
      );
    }
  }

  Widget _trackDetails(BuildContext context) {
    if (_busy) {
      return Expanded(child: Center(child: CircularProgressIndicator()));
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Album: ${_album.name}, released ${_album.releaseDate}'),
          Text('Popularity: ${_track.popularity}/100'),
          Text('${_track.duration.toString()}'),
        ],
      );
    }
  }
}
