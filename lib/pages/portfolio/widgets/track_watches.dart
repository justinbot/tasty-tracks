import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/models/track_watch_model.dart';
import 'package:tasty_tracks/pages/portfolio/widgets/track_watch_list_item.dart';
import 'package:tasty_tracks/pages/track/track.dart';
import 'package:tasty_tracks/spotify_api.dart';

class TrackWatches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Widget trackWatches = ScopedModelDescendant<TrackWatchModel>(
      rebuildOnChange: false,
      builder: (context, child, trackWatchModel) {
        return FutureBuilder<Map<DocumentSnapshot, spotify.Track>>(
          future: _loadData(trackWatchModel),
          builder: (BuildContext context,
              AsyncSnapshot<Map<DocumentSnapshot, spotify.Track>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.isNotEmpty) {
                Iterable<DocumentSnapshot> watches = snapshot.data.keys;

                return Scrollbar(
                  child: ListView.builder(
                    itemCount: watches.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot watch = watches.elementAt(index);
                      spotify.Track track = snapshot.data[watch];

                      return TrackWatchListItem(
                        trackWatch: watch,
                        track: track,
                        onTap: (i) => _onItemTapped(context, i),
                      );
                    },
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    'No tracks being watched.',
                    style: theme.textTheme.caption,
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Failed to load your watched tracks :('),
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

    return trackWatches;
  }

  Future<Map<DocumentSnapshot, spotify.Track>> _loadData(
      TrackWatchModel trackWatchModel) async {
    QuerySnapshot trackWatches = await trackWatchModel.getAll();

    if (trackWatches.documents.isNotEmpty) {
      // Get corresponding tracks
      Iterable<String> trackIds =
          trackWatches.documents.map((t) => t.data['track_id'] as String);
      Iterable<spotify.Track> tracks = await spotifyApi.tracks.list(trackIds);

      return Map.fromIterables(trackWatches.documents, tracks);
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
        'hero_suffix': '${selectedItem.id}-watch',
      },
    );
  }
}
