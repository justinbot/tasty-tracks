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
    return Scaffold(appBar: AppBar(), body: SafeArea(child: _content()));
  }

  Widget _content() {
    if (_busy) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _trackHeader(context),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: <Widget>[
                  _trackDetails(context),
                ],
              ),
            ),
          ]);
    }
  }

  Widget _trackHeader(BuildContext context) {
    String artistNames = _track.artists.map((artist) => artist.name).join(', ');

    return Expanded(
        child: Column(
      children: <Widget>[
        Image.network(
          // TODO FadeInImage
          _album.images.first.url,
          fit: BoxFit.cover,
          height: 256,
        ),
        SizedBox(height: 16.0),
        Text(
          _track.name,
          style: Theme.of(context).textTheme.title,
        ),
        SizedBox(height: 8.0),
        Text(
          artistNames,
          style: Theme.of(context).textTheme.subtitle,
        ),
        SizedBox(height: 8.0),
        Text(
          '${_album.name}',
          style: Theme.of(context).textTheme.subtitle,
        ),
        SizedBox(height: 8.0),
        Text(
          '${_album.releaseDate}',
          style: Theme.of(context).textTheme.subtitle,
        ),
      ],
    ));
  }

  Widget _trackDetails(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
              child: Text(
                'Place Bet',
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(64.0)),
              onPressed: () {}),
          SizedBox(height: 16.0),
          Text('Popularity: ${_track.popularity}/100'),
          Text('${_track.duration.toString()}'),
        ],
      ),
    );
  }
}
