import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/models/track_watch_model.dart';
import 'package:tasty_tracks/models/track_bet_model.dart';
import 'package:tasty_tracks/pages/home/widgets/track_watch_list_item.dart';
import 'package:tasty_tracks/pages/track/track.dart';
import 'package:tasty_tracks/spotify_api.dart';

class TrackBets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Widget trackBets = ScopedModelDescendant<TrackBetModel>(
      rebuildOnChange: false,
      builder: (context, child, trackBetModel) {
        return FutureBuilder<Map<DocumentSnapshot, spotify.Track>>(
          future: _loadData(trackBetModel),
          builder: (BuildContext context,
              AsyncSnapshot<Map<DocumentSnapshot, spotify.Track>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.isNotEmpty) {
                return Column(
                  children: snapshot.data.keys
                      .map((w) => TrackWatchListItem(
                            trackWatch: w,
                            track: snapshot.data[w],
                            onTap: (i) => _onItemTapped(context, i),
                          ))
                      .toList(),
                );
              } else {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 48.0),
                    child: Text(
                      "You haven't bet on any tracks.",
                      style: theme.textTheme.caption,
                    ),
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 48.0),
                  child: Text('Failed to load your portfolio :('),
                ),
              );
            } else {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 48.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        );
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Portfolio',
                style: theme.textTheme.title,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        trackBets
      ],
    );
  }

  Future<Map<DocumentSnapshot, spotify.Track>> _loadData(
      TrackBetModel trackBetModel) async {
    QuerySnapshot trackBets = await trackBetModel.getAll();

    if (trackBets.documents.isNotEmpty) {
      // Get corresponding tracks
      Iterable<String> trackIds =
          trackBets.documents.map((t) => t.data['track_id'] as String);
      List<spotify.Track> tracks =
          (await spotifyApi.tracks.list(trackIds)).toList();

      return Map.fromIterables(trackBets.documents, tracks);
    } else {
      return Map();
    }
  }

  _onItemTapped(BuildContext context, spotify.Track selectedItem) {
    if (selectedItem.album.images.isNotEmpty) {
      String trackImageUrl = selectedItem.album.images.first.url;
      // Encode the URL
      String encodedTrackImageUrl = utf8.fuse(base64Url).encode(trackImageUrl);

      Navigator.of(context).pushNamed(TrackPage.routeName +
          ':${selectedItem.id}' +
          ':${encodedTrackImageUrl}');
    } else {
      Navigator.of(context)
          .pushNamed(TrackPage.routeName + ':${selectedItem.id}');
    }
  }
}
