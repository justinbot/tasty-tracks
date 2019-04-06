import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/models/track_bet_model.dart';
import 'package:tasty_tracks/pages/portfolio/widgets/track_bet_list_item.dart';
import 'package:tasty_tracks/pages/portfolio/widgets/track_bets_header.dart';
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
                // TODO Calculate change over past day
                // Percent or value?
                Iterable<DocumentSnapshot> bets = snapshot.data.keys;

                return Column(
                  children: [
                    TrackBetsHeader(
                      // TODO
                      change: 1234.0,
                      updated: DateTime.now(),
                    ),
                    Expanded(
                      child: Scrollbar(
                        child: ListView.builder(
                          itemCount: bets.length,
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot bet = bets.elementAt(index);
                            spotify.Track track = snapshot.data[bet];

                            return TrackBetListItem(
                              trackBet: bet,
                              track: track,
                              onTap: (i) => _onItemTapped(context, i),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Text(
                    "You haven't bet on any tracks.",
                    style: theme.textTheme.caption,
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Failed to load your portfolio :('),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      },
    );

    return trackBets;
  }

  Future<Map<DocumentSnapshot, spotify.Track>> _loadData(
      TrackBetModel trackBetModel) async {
    QuerySnapshot trackBets = await trackBetModel.getAll();

    if (trackBets.documents.isNotEmpty) {
      // Get corresponding tracks
      Iterable<String> trackIds =
          trackBets.documents.map((t) => t.data['track_id'] as String);
      Iterable<spotify.Track> tracks = await spotifyApi.tracks.list(trackIds);

      return Map.fromIterables(trackBets.documents, tracks);
    } else {
      return Map();
    }
  }

  _onItemTapped(BuildContext context, spotify.Track selectedItem) {
    String imageUrl = selectedItem.album.images.isNotEmpty
        ? selectedItem.album.images.first.url
        : null;
    Navigator.of(context).pushNamed(
      TrackPage.routeName,
      arguments: {
        'track_id': selectedItem.id,
        'track_image_url': imageUrl,
        'hero_suffix': '${selectedItem.id}-bet',
      },
    );
  }
}
