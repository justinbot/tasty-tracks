import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/models/search_history_model.dart';
import 'package:tasty_tracks/pages/search/widgets/search_history.dart';
import 'package:tasty_tracks/pages/search/widgets/search_results.dart';
import 'package:tasty_tracks/spotify_api.dart';

class MusicSearchDelegate extends SearchDelegate {
  MusicSearchDelegate({
    Key key,
    this.searchHistoryModel,
  });

  final SearchHistoryModel searchHistoryModel;

  Future<Map<spotify.SearchType, List<Object>>> searchRequest;
  String lastQuery;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(FeatherIcons.x),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(FeatherIcons.arrowLeft),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return ScopedModel(
        model: searchHistoryModel,
        child: SearchHistory(
          onSelectedItem: (selectedItem) {
            close(context, selectedItem);
          },
        ),
      );
    } else {
      _handleSearchRequest();

      return FutureBuilder<Map<spotify.SearchType, List<Object>>>(
        future: searchRequest,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SearchResults(
              onSelectedItem: (selectedItem) {
                close(context, selectedItem);
              },
              tracks: snapshot.data[spotify.SearchType.track],
              artists: snapshot.data[spotify.SearchType.artist],
              albums: snapshot.data[spotify.SearchType.album],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error getting your results :('),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO Implement debouncing
    return buildResults(context);
  }

  _handleSearchRequest() {
    // Only make a new request when necessary
    if (searchRequest == null || query != lastQuery) {
      searchRequest = Future<Map<spotify.SearchType, List<Object>>>(() {
        String formattedQuery = query + '*';
        return spotifyApi.search
            .get(
              formattedQuery,
              [
                spotify.SearchType.track,
                spotify.SearchType.artist,
                spotify.SearchType.album,
              ],
            )
            .first(5)
            .then((pages) {
              // Separate paged items into lists of each type of result
              List<spotify.TrackSimple> trackResults = List();
              List<spotify.Artist> artistResults = List();
              List<spotify.AlbumSimple> albumResults = List();

              pages.forEach((spotify.Page<Object> page) {
                trackResults.addAll(
                  page.items.whereType<spotify.TrackSimple>(),
                );
                artistResults.addAll(
                  page.items.whereType<spotify.Artist>(),
                );
                albumResults.addAll(
                  page.items.whereType<spotify.AlbumSimple>(),
                );
              });

              if (trackResults.isNotEmpty) {
                // Get full tracks for any track results
                return spotifyApi.tracks
                    .list(trackResults.map((t) => t.id))
                    .then((fullTracks) {
                  Map<spotify.SearchType, List<Object>> results = {
                    spotify.SearchType.track: fullTracks.toList(),
                    spotify.SearchType.artist: artistResults,
                    spotify.SearchType.album: albumResults,
                  };
                  return results;
                });
              } else {
                Map<spotify.SearchType, List<Object>> results = {
                  spotify.SearchType.track: List<spotify.Track>(),
                  spotify.SearchType.artist: artistResults,
                  spotify.SearchType.album: albumResults,
                };
                return results;
              }
            });
      });

      lastQuery = query;
    }
  }
}
