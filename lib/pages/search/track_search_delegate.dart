import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/search/widgets/album_search_item.dart';
import 'package:tasty_tracks/pages/search/widgets/artist_search_item.dart';
import 'package:tasty_tracks/pages/search/widgets/track_search_item.dart';
import 'package:tasty_tracks/spotify_api.dart';

class TrackSearchDelegate extends SearchDelegate {
  // TODO Implement searching as user types, with debouncing
  // buildSuggestions
  Future<List<spotify.Page<Object>>> searchRequest;
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
      searchRequest = spotifyApi.search.get(
        query,
        [
          spotify.SearchType.track,
          spotify.SearchType.artist,
          spotify.SearchType.album,
        ],
      ).first(5);
      lastQuery = query;
    }

    return FutureBuilder<List<spotify.Page<Object>>>(
      future: searchRequest,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<spotify.TrackSimple> trackResults = List();
          List<spotify.Artist> artistResults = List();
          List<spotify.AlbumSimple> albumResults = List();

          // Separate into lists of each type of result
          snapshot.data.forEach((spotify.Page<Object> page) {
            trackResults.addAll(page.items.whereType<spotify.TrackSimple>());
            artistResults.addAll(page.items.whereType<spotify.Artist>());
            albumResults.addAll(page.items.whereType<spotify.AlbumSimple>());
          });

          // TODO Augment track results
          return _combinedSearchResults(
            context,
            trackResults,
            artistResults,
            albumResults,
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
    List<Widget> combinedResultsItems = List<Widget>();

    List<Widget> trackResultsItems =
        trackResults.map((track) => _trackSearchItem(context, track)).toList();
    List<Widget> artistResultsItems = artistResults
        .map((artist) => ArtistSearchItem(onTap: close, artist: artist))
        .toList();
    List<Widget> albumResultsItems = albumResults
        .map((album) => AlbumSearchItem(onTap: close, album: album))
        .toList();

    combinedResultsItems
      ..add(_searchHeaderItem(context, 'Tracks'))
      ..addAll(trackResultsItems)
      ..add(_searchHeaderItem(context, 'Artists'))
      ..addAll(artistResultsItems)
      ..add(_searchHeaderItem(context, 'Albums'))
      ..addAll(albumResultsItems);

    return ListView(children: combinedResultsItems);
  }

  Widget _trackSearchItem(BuildContext context, spotify.TrackSimple track) {
    CircleAvatar trackAvatar = CircleAvatar(
      backgroundColor: Colors.blueGrey,
    );
    String artistNames = track.artists.map((artist) => artist.name).join(', ');

    return ListTile(
      leading: trackAvatar,
      title: Text(
        track.name,
        style: Theme.of(context).textTheme.subhead,
      ),
      // TODO Display Explicit and other data in subtitle
      subtitle: Text(artistNames),
      onTap: () {
        close(context, track);
      },
    );
  }

  Widget _searchHeaderItem(BuildContext context, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        label,
        style: Theme.of(context).textTheme.headline,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // return buildResults(context);
    return Center(child: Text('Suggestions for ${query} go here'));
  }
}
