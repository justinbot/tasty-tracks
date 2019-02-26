import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/search/widgets/album_search_item.dart';
import 'package:tasty_tracks/pages/search/widgets/artist_search_item.dart';
import 'package:tasty_tracks/pages/search/widgets/header_search_item.dart';
import 'package:tasty_tracks/pages/search/widgets/track_search_item.dart';
import 'package:tasty_tracks/spotify_api.dart';

class TrackSearchDelegate extends SearchDelegate {
  // TODO Implement searching as user types, with debouncing
  // buildSuggestions
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
    // TODO Handle empty query
    // Only get search results when necessary
    if (query.isEmpty) {
      // TODO
      return Center(
        child: Text('TODO Recent searches'),
      );
    }

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

              // Get full tracks for track results
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
            });
      });

      lastQuery = query;
    }

    return FutureBuilder<Map<spotify.SearchType, List<Object>>>(
      future: searchRequest,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _combinedSearchResults(
            context,
            snapshot.data[spotify.SearchType.track],
            snapshot.data[spotify.SearchType.artist],
            snapshot.data[spotify.SearchType.album],
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

  Widget _combinedSearchResults(
      BuildContext context,
      List<spotify.TrackSimple> trackResults,
      List<spotify.Artist> artistResults,
      List<spotify.AlbumSimple> albumResults) {
    // TODO Handle empty results
    // TODO Add transitions to detail pages

    List<Widget> trackResultsItems = trackResults
        .map((track) => TrackSearchItem(onTap: close, track: track))
        .toList();
    List<Widget> artistResultsItems = artistResults
        .map((artist) => ArtistSearchItem(onTap: close, artist: artist))
        .toList();
    List<Widget> albumResultsItems = albumResults
        .map((album) => AlbumSearchItem(onTap: close, album: album))
        .toList();

    List<Widget> combinedResultsItems = List();
    combinedResultsItems
      ..add(HeaderSearchItem(
        label: 'Tracks',
      ))
      ..addAll(trackResultsItems)
      ..add(HeaderSearchItem(
        label: 'Artists',
      ))
      ..addAll(artistResultsItems)
      ..add(HeaderSearchItem(
        label: 'Albums',
      ))
      ..addAll(albumResultsItems);

    return ListView(children: combinedResultsItems);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // return buildResults(context);
    return Center(child: Text('Suggestions for ${query} go here'));
  }
}
