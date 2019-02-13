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

  @override
  void initState() {
    super.initState();

    setState(() {
      _busy = true;
    });
    // Get track data
    spotifyApi.tracks.get(widget.trackId).then((track) {
      setState(() {
        _track = track;
      });
    }).catchError((error) {
      // TODO Handle error
    }).whenComplete(() {
      setState(() {
        _busy = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Column(children: <Widget>[
            Row(
              children: <Widget>[
                _trackHeader(context),
              ],
            ),
            Row(
              children: <Widget>[
                _trackDetails(context),
              ],
            ),
          ]),
        ));
  }

  Widget _trackHeader(BuildContext context) {
    if (_busy) {
      return Center(child: CircularProgressIndicator());
    } else {
      String artistNames = _track.artists.map((artist) => artist.name).join(', ');

      return Expanded(
          child: Column(
        children: <Widget>[
          Image.network(
            _track.album.images.first.url,
            fit: BoxFit.cover,
            height: 200,
          ),
          Text(
            _track.name,
            style: Theme.of(context).textTheme.title,
          ),
          Text(
            artistNames,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ],
      ));
    }
  }

  Widget _trackDetails(BuildContext context) {
    if (_busy) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Column(children: <Widget>[
        Text('Other stuff about this track'),
      ]);
    }
  }
}
