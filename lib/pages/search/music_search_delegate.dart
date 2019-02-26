import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/constants/sharedPrefs.dart';
import 'package:tasty_tracks/pages/search/widgets/search_results.dart';
import 'package:tasty_tracks/spotify_api.dart';

class MusicSearchDelegate extends SearchDelegate {
  Future<Map<spotify.SearchType, List<Object>>> searchRequest;
  String lastQuery;

  // TODO Instance search history

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
      // TODO Show history if empty query
      return Center(
        child: Text('TODO Recent searches'),
      );
    } else {
      _handleSearchRequest();

      return FutureBuilder<Map<spotify.SearchType, List<Object>>>(
        future: searchRequest,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SearchResults(
              onTap: _handleSelectedItem,
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
    // TODO Implement searching as user types, with debouncing
    // return buildResults(context);
    // TODO Show history if empty query
    return Center(child: Text('Suggestions for ${query} go here'));
  }

  _handleSearchRequest() {
    // Only make a new request when necessary
    if (searchRequest == null || query != lastQuery) {
      searchRequest = Future<Map<spotify.SearchType, List<Object>>>(() {
        return spotifyApi.search
            .get(
              query,
              [
                spotify.SearchType.track,
                spotify.SearchType.artist,
                spotify.SearchType.album,
              ],
            )
            .first(10)
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

  _handleSelectedItem(BuildContext context, Object result) {
    // Save selected result to search history
    SharedPreferences.getInstance().then((prefs) {
      String prefsKey;
      List<String> history;
      String resultId;

      if (result is spotify.TrackSimple) {
        prefsKey = searchHistoryTracksKey;
        resultId = result.id;
      } else if (result is spotify.ArtistSimple) {
        prefsKey = searchHistoryArtistsKey;
        resultId = result.id;
      } else if (result is spotify.AlbumSimple) {
        prefsKey = searchHistoryAlbumsKey;
        resultId = result.id;
      }

      history = prefs.getStringList(prefsKey) ?? List();
      if (!history.contains(resultId)) {
        history.add(resultId);
        prefs.setStringList(prefsKey, history);
      }
    });

    close(context, result);
  }
}
